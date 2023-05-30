defmodule ExAds.Shared.TokenrTest do
  use ExAds.DataCase

  alias ExAds.AccountsFixtures
  alias ExAds.Shared.Tokenr

  describe "create token" do
    setup [:create_user]

    test "generate_auth_token/1 should create token and verify user into token", %{user: user} do
      token = Tokenr.generate_auth_token(user)

      assert {:ok, user_from_token} = Tokenr.verify_auth_token(token)
      assert user_from_token == user
    end
  end

  defp create_user(_) do
    user = AccountsFixtures.user_fixture()
    %{user: user}
  end
end
