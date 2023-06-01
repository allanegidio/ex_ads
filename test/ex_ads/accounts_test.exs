defmodule ExAds.AccountsTest do
  use ExAds.DataCase

  alias ExAds.Accounts
  alias ExAds.Accounts.User
  alias ExAds.Shared.Tokenr

  @valid_attrs %{
    first_name: "Unit",
    last_name: "Test",
    email: "test@domain.com",
    username: "unitest",
    password: "123456789",
    password_confirmation: "123456789"
  }

  describe "Accounts Create User Tests" do
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@domain.com"
      assert user.username == "unitest"
    end

    test "create_user/1 return an error when email is already using" do
      Accounts.create_user(@valid_attrs)

      assert {:error, changeset} = Accounts.create_user(@valid_attrs)
      assert %{email: ["has already been taken"]} == errors_on(changeset)
    end

    test "create_user/1 return an error when email is invalid" do
      invalid_attrs = Map.put(@valid_attrs, :email, "invalidemail.com")

      assert {:error, changeset} = Accounts.create_user(invalid_attrs)
      assert %{email: ["type a valid e-mail"]} == errors_on(changeset)
    end

    test "create_user/1 return an error when password is less than 6 characteres" do
      invalid_attrs =
        @valid_attrs
        |> Map.put(:password, "12345")
        |> Map.put(:password_confirmation, "12345")

      assert {:error, changeset} = Accounts.create_user(invalid_attrs)
      assert %{password: ["should be at least 6 character(s)"]} == errors_on(changeset)
    end
  end

  describe "Accounts Forgot password tests" do
    test "deliver_user_reset_password_instructions/1 get token to change password" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:ok, user_from_email, _token} =
               Accounts.deliver_user_reset_password_instructions(user.email)

      assert user.email == user_from_email.email
    end

    test "deliver_user_reset_password_instructions/1 get user from token" do
      assert {:error, message} =
               Accounts.deliver_user_reset_password_instructions("usernotfound@domain.com")

      assert message == :not_found
    end
  end

  describe "Accounts reset password tests" do
    test "reset_password/2 should reset password" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      token = Tokenr.generate_forgot_email_token(user)

      new_password_params = %{
        "password" => "new_password",
        "password_confirmation" => "new_password"
      }

      assert {:ok, user_updated} = Accounts.reset_password(token, new_password_params)

      assert user.email == user_updated.email
    end

    test "reset_password/2 should return error when using invalid token" do
      token = "invalid_token"

      new_password_params = %{
        "password" => "new_password",
        "password_confirmation" => "new_password"
      }

      assert {:error, message} = Accounts.reset_password(token, new_password_params)

      assert message == "Invalid token"
    end
  end
end
