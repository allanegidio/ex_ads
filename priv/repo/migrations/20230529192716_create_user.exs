defmodule ExAds.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :username, :string
      add :password_hash, :string
      add :email, :string
      add :role, :string, default: "user", null: false

      timestamps()
    end

    create unique_index(:users, [:email, :username])
  end
end
