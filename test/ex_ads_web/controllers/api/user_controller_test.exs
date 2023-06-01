defmodule ExAdsWeb.Api.UserControllerTest do
  use ExAdsWeb.ConnCase

  alias ExAds.AccountsFixtures
  alias ExAds.Shared.Tokenr

  @valid_attrs %{
    first_name: "Unit",
    last_name: "Test",
    email: "test@domain.com",
    username: "unitest",
    password: "123456789",
    password_confirmation: "123456789"
  }

  describe "get user" do
    setup [:create_user]

    test "render user when id is valid", %{conn: conn, user: user} do
      %{id: id, email: email, username: username} = user

      conn = get(conn, Routes.api_user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => ^email,
               "username" => ^username
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @valid_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "test@domain.com",
               "username" => "unitest"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs =
        @valid_attrs
        |> Map.put(:email, "invalid.email")
        |> Map.put(:password, "123")

      conn = post(conn, Routes.api_user_path(conn, :create), user: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "forgot/reset password user" do
    setup [:create_user]

    test "when forgot password should receive instruction to reset on email", %{
      conn: conn,
      user: user
    } do
      conn = post(conn, Routes.api_user_path(conn, :forgot_password, email: user.email))

      assert "Your password reset instruction was sent to your email" =
               json_response(conn, 200)["message"]
    end

    test "when forgot password using not registered email should receive not found", %{conn: conn} do
      conn =
        post(conn, Routes.api_user_path(conn, :forgot_password, email: "notfound@domain.com"))

      assert "Not Found" == json_response(conn, 404)
    end

    test "when reset password using valid token should update password", %{conn: conn, user: user} do
      token = Tokenr.generate_forgot_email_token(user)

      new_password = %{
        password: "new_password",
        password_confirmation: "new_password"
      }

      conn =
        post(
          conn,
          Routes.api_user_path(conn, :reset_password, token: token, user: new_password)
        )

      assert user.email == json_response(conn, 200)["data"]["email"]
    end

    test "when reset password using invalid token should return error", %{conn: conn} do
      token = "Trololo"

      new_password = %{
        password: "new_password",
        password_confirmation: "new_password"
      }

      conn =
        post(
          conn,
          Routes.api_user_path(conn, :reset_password, token: token, user: new_password)
        )

      assert %{"message" => "Invalid token"} = json_response(conn, 400)
    end
  end

  defp create_user(_) do
    user = AccountsFixtures.user_fixture()
    %{user: user}
  end
end
