defmodule ExAdsWeb.Api.AnnouncementControllerTest do
  use ExAdsWeb.ConnCase

  test "list all announcements", %{conn: conn} do
    conn = get(conn, Routes.api_announcement_path(conn, :index))

    response = json_response(conn, 200)

    assert response == %{"data" => []}
  end
end
