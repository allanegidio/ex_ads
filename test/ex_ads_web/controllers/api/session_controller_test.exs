defmodule ExAdsWeb.Api.SessionControllerTest do
  use ExAdsWeb.ConnCase

  alias ExAds.AccountsFixtures
  alias ExAds.Sessions

  describe "Sessions Controller Tests" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.api_session_path(conn, :create),
          email: user.email,
          password: "123456789"
        )

      assert user.email == json_response(conn, 201)["data"]["user"]["data"]["email"]
    end

    test "get session", %{conn: conn, user: user, token: token} do
      conn = post(conn, Routes.api_session_path(conn, :sign_in, token: token))

      assert user.email == json_response(conn, 200)["data"]["user"]["data"]["email"]
    end
  end

  defp create_user(_) do
    user = AccountsFixtures.user_fixture()

    {:ok, _user, token} = Sessions.create(user.email, user.password)

    %{user: user, token: token}
  end
end
