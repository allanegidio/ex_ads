defmodule ExAds.Announcements do
  alias ExAds.Announcements.Announcement
  alias ExAds.Repo

  def list_announcements do
    Repo.all(Announcement)
  end

  def create_announcement(attrs \\ %{}) do
    %Announcement{}
    |> Announcement.changeset(attrs)
    |> Repo.insert()
  end

  def get_announcement!(id) do
    Repo.get!(Announcement, id)
  end

  def update_announcement(announcement, attrs) do
    announcement
    |> Announcement.changeset(attrs)
    |> Repo.update()
  end

  def delete_announcement(announcement) do
    Repo.delete(announcement)
  end
end
