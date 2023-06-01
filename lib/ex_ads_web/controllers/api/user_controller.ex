defmodule ExAdsWeb.Api.UserController do
  use ExAdsWeb, :controller

  alias ExAds.Accounts
  alias ExAds.Accounts.User

  action_fallback ExAdsWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def forgot_password(conn, %{"email" => email}) do
    with {:ok, _user, _token} <- Accounts.deliver_user_reset_password_instructions(email) do
      conn
      |> put_resp_content_type("application/json")
      |> json(%{message: "Your password reset instruction was sent to your email"})
    end
  end

  def reset_password(conn, %{"token" => token, "user" => user_new_password}) do
    with {:ok, user} <- Accounts.reset_password(token, user_new_password) do
      render(conn, "show.json", user: user)
    end
  end
end
