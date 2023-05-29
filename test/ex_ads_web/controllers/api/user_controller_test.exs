defmodule ExAdsWeb.Api.UserControllerTest do
  use ExAdsWeb.ConnCase

  alias ExAds.AccountsFixtures

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

  defp create_user(_) do
    user = AccountsFixtures.user_fixture()
    %{user: user}
  end
end
