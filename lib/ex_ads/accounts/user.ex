defmodule ExAds.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @role_values [:user, :admin]
  @fields [:role]
  @required_fields [
    :first_name,
    :last_name,
    :username,
    :email,
    :role,
    :password,
    :password_confirmation
  ]

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :role, Ecto.Enum, values: @role_values, default: :user

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/, message: "type a valid e-mail")
    |> validate_length(:password, min: 6, max: 100)
    |> update_change(:email, &String.downcase/1)
    |> validate_confirmation(:password)
    |> unique_constraint([:email, :username], name: :users_email_username_index)
    |> hash_password()
  end

  defp hash_password(%{valid?: true} = changeset) do
    password = get_field(changeset, :password)

    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset), do: changeset
end
