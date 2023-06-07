defmodule ExAdsWeb.Api.SessionControllerTest do
  use ExAdsWeb.ConnCase

  describe "Sessions Controller Tests" do
    setup [:include_admin_token]

    test "renders user when data is valid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.api_session_path(conn, :create),
          email: user.email,
          password: "123456789"
        )

      assert user.email == json_response(conn, 201)["data"]["user"]["data"]["email"]
    end

    test "throw an error when user is not authenticated", %{conn: conn} do
      conn = post(conn, Routes.api_session_path(conn, :sign_in, token: "token_invalido"))

      assert %{"message" => "invalid"} = json_response(conn, 400)
    end

    test "get session", %{conn: conn, user: user, token: token} do
      conn = post(conn, Routes.api_session_path(conn, :sign_in, token: token))

      assert user.email == json_response(conn, 200)["data"]["user"]["data"]["email"]
    end
  end
end
