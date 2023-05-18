defmodule ExAdsWeb.Api.AnnouncementController do
  use ExAdsWeb, :controller

  alias ExAds.Announcements

  def index(conn, _params) do
    announcements = Announcements.list_announcements()

    render(conn, "index.json", announcements: announcements)
  end
end
