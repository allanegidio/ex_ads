defmodule ExAds.Announcements do
  alias ExAds.Announcements.Announcement
  alias ExAds.Repo

  def list_announcements() do
    Repo.all(Announcement)
  end

  def create_announcement(attrs \\ %{}) do
    %Announcement{}
    |> Announcement.changeset(attrs)
    |> Repo.insert()
  end
end
