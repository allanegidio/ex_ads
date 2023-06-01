defmodule ExAds.SessionsTest do
  use ExAds.DataCase

  alias ExAds.AccountsFixtures
  alias ExAds.Sessions

  describe "Session tests" do
    setup [:create_user]

    test "authenticate/1 get user from token", %{user: user} do
      assert {:ok, _user_from_session, token} = Sessions.create(user.email, user.password)
      assert {:ok, user_authenticated} = Sessions.authenticate(token)
      assert user.email == user_authenticated.email
    end

    test "create/2 return authenticated user", %{user: user} do
      password = "123456789"

      assert {:ok, authenticated_user, _token} = Sessions.create(user.email, password)

      assert authenticated_user.email == user.email
    end

    test "create/2 throw error when password is incorrect", %{user: user} do
      password = "incorrectpassword"

      assert {:error, message} = Sessions.create(user.email, password)

      assert message == "Email or password is incorrect"
    end

    test "create/2 throw error when email is invalid", %{user: _user} do
      email = "unsigned_email@domain.com"
      password = "123456789"

      assert {:error, message} = Sessions.create(email, password)

      assert message == "User not found"
    end
  end

  defp create_user(_) do
    user = AccountsFixtures.user_fixture()

    %{user: user}
  end
end
