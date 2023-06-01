defmodule ExAds.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias ExAds.Accounts.{User, UserNotifier}
  alias ExAds.Repo
  alias ExAds.Shared.Tokenr

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def deliver_user_reset_password_instructions(email) do
    User
    |> Repo.get_by(email: email)
    |> deliver_user_reset_password_token()
  end

  def reset_password(token, user_new_password) do
    token
    |> Tokenr.verify_forgot_email_token()
    |> update_new_password(user_new_password)
  end

  defp update_new_password({:error, _}, _params), do: {:error, "Invalid token"}

  defp update_new_password({:ok, user}, user_new_password) do
    update_user(user, user_new_password)
  end

  defp deliver_user_reset_password_token(nil), do: {:error, :not_found}

  defp deliver_user_reset_password_token(user) do
    token = Tokenr.generate_forgot_email_token(user)

    UserNotifier.send_forgot_password_email(user, token)

    {:ok, user, token}
  end
end
