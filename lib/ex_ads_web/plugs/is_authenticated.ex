defmodule ExAdsWeb.Plugs.IsAuthenticated do
  import Plug.Conn

  alias ExAds.Shared.Tokenr

  def init(opt), do: opt

  def call(conn, _opts) do
    with ["Bearer" <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Tokenr.verify_auth_token(token) do
      put_req_header(conn, "user_id", user.id)
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "User does not have this permission"}))
        |> halt()
    end
  end
end
