defmodule ExAdsWeb.AnnouncementFactory do
  alias ExAds.Announcements

  def build(attrs \\ %{}) do
    {:ok, announcement} = Announcements.create_announcement(attrs)

    announcement
  end
end
