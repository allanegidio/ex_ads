defmodule ExAds.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text

      timestamps()
    end

    create unique_index(:announcements, [:title])
  end
end
