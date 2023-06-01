defmodule ExAdsWeb.Api.Admin.AnnouncementController do
  use ExAdsWeb, :controller

  alias ExAds.Announcements

  action_fallback ExAdsWeb.FallbackController

  def index(conn, _params) do
    announcements = Announcements.list_announcements()

    render(conn, "index.json", announcements: announcements)
  end

  def create(conn, %{"announcement" => announcement} = _params) do
    with {:ok, announcement} <- Announcements.create_announcement(announcement) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.api_admin_announcement_path(conn, :show, announcement)
      )
      |> render("show.json", announcement: announcement)
    end
  end

  def show(conn, %{"id" => id} = _params) do
    announcement = Announcements.get_announcement!(id)

    conn
    |> put_status(200)
    |> render("show.json", announcement: announcement)
  end

  def update(conn, %{"id" => id, "announcement" => announcement_params}) do
    announcement = Announcements.get_announcement!(id)

    with {:ok, announcement_updated} <-
           Announcements.update_announcement(announcement, announcement_params) do
      render(conn, "show.json", announcement: announcement_updated)
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    announcement = Announcements.get_announcement!(id)

    with {:ok, _announcement} <- Announcements.delete_announcement(announcement) do
      send_resp(conn, :no_content, "")
    end
  end
end
