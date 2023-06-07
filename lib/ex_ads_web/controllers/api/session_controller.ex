defmodule ExAdsWeb.Api.SessionController do
  use ExAdsWeb, :controller

  alias ExAds.Sessions

  action_fallback ExAdsWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Sessions.create(email, password) do
      session = %{user: user, token: token}

      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    end
  end

  def sign_in(conn, %{"token" => token}) do
    with {:ok, user} <- Sessions.authenticate(token) do
      session = %{user: user, token: token}

      render(conn, "show.json", session: session)
    end
  end
end
