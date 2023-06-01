defmodule ExAds.Sessions do
  alias ExAds.Accounts.User
  alias ExAds.Repo
  alias ExAds.Shared.Tokenr

  def authenticate(token) do
    Tokenr.verify_auth_token(token)
  end

  def create(email, password) do
    User
    |> Repo.get_by(email: email)
    |> check_user_exists()
    |> validate_password(password)
  end

  defp check_user_exists(nil), do: {:error, "User not found"}
  defp check_user_exists(user), do: user

  defp validate_password({:error, _reason} = error, _password), do: error

  defp validate_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      token = Tokenr.generate_auth_token(user)
      {:ok, user, token}
    else
      {:error, "Email or password is incorrect"}
    end
  end
end
