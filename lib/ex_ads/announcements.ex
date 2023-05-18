defmodule ExAds.Announcements do
  alias ExAds.Announcements.Announcement
  alias ExAds.Repo

  def list_announcements() do
    Repo.all(Announcement)
  end
end
