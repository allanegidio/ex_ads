defmodule ExAds.Announcements.Announcement do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "announcements" do
    field :title, :string
    field :content, :string

    timestamps()
  end

  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
