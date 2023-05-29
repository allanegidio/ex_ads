defmodule ExAds.AccountsTest do
  use ExAds.DataCase

  alias ExAds.Accounts
  alias ExAds.Accounts.User

  @valid_attrs %{
    first_name: "Unit",
    last_name: "Test",
    email: "test@domain.com",
    username: "unitest",
    password: "123456789",
    password_confirmation: "123456789"
  }

  describe "Accounts Tests" do
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
end
