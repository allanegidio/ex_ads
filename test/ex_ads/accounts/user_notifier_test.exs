defmodule ExAds.Accounts.UserNotifierTest do
  use ExAds.DataCase

  import Swoosh.TestAssertions

  alias ExAds.Accounts.UserNotifier
  alias ExAds.AccountsFixtures

  describe "User Notifier Tests" do
    setup [:create_user]

    test "Create email to reset password", %{user: user} do
      token = "trololo"

      result = UserNotifier.email_reset_password_instructions(user, token)

      assert result.html_body =~ "Ex Ads - Reset Password"
    end

    test "Send email to reset password", %{user: user} do
      token = "trololol"

      Task.await(UserNotifier.send_forgot_password_email(user, token))

      assert {:email, email_result} = assert_email_sent()
      assert [{user.first_name, user.email}] == email_result.to
    end
  end

  defp create_user(_) do
    user = AccountsFixtures.user_fixture()
    %{user: user}
  end
end
