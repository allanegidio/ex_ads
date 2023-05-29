defmodule ExAds.AccountsFixtures do
  alias ExAds.Accounts

  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExAds.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}@domain.com"

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: "Unit",
        last_name: "Test",
        email: unique_user_email(),
        username: unique_user_username(),
        password: "123456789",
        password_confirmation: "123456789"
      })
      |> Accounts.create_user()

    user
  end
end
