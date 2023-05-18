defmodule ExAds.Announcements.Announcement do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "announcements" do
    field :title, :string
    field :content, :string

    timestamps()
  end
end
