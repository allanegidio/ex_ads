defmodule ExAdsWeb.Api.Admin.AnnouncementControllerTest do
  use ExAdsWeb.ConnCase

  alias ExAds.AnnouncementFixtures

  setup :include_admin_token

  test "list all announcements", %{conn: conn} do
    conn = get(conn, Routes.api_admin_announcement_path(conn, :index))

    response = json_response(conn, 200)

    assert response == %{"data" => []}
  end

  test "create announcement when data is valid", %{conn: conn} do
    attrs = %{title: "Test title", content: "Content test"}
    conn = post(conn, Routes.api_admin_announcement_path(conn, :create, announcement: attrs))
    assert %{"data" => %{"id" => id}} = json_response(conn, 201)

    conn = get(conn, Routes.api_admin_announcement_path(conn, :show, id))

    assert %{"data" => %{"id" => ^id}} = json_response(conn, 200)
  end

  test "create announcement when data is invalid", %{conn: conn} do
    attrs = %{title: "", content: ""}

    conn = post(conn, Routes.api_admin_announcement_path(conn, :create, announcement: attrs))

    assert %{
             "errors" => %{
               "content" => ["can't be blank"],
               "title" => ["can't be blank"]
             }
           } = json_response(conn, 422)
  end

  describe "update announcement" do
    setup [:create_announcement]

    test "update announcement with valid data", %{conn: conn, announcement: announcement} do
      conn =
        patch(conn, Routes.api_admin_announcement_path(conn, :update, announcement),
          announcement: %{content: "Content updated"}
        )

      assert %{"data" => %{"id" => id}} = json_response(conn, 200)

      conn = get(conn, Routes.api_admin_announcement_path(conn, :show, id))

      assert %{"data" => %{"id" => ^id, "content" => "Content updated"}} =
               json_response(conn, 200)
    end
  end

  describe "delete announcement" do
    setup [:create_announcement]

    test "delete announcement", %{conn: conn, announcement: announcement} do
      conn = delete(conn, Routes.api_admin_announcement_path(conn, :update, announcement))

      assert response(conn, 204)

      assert_error_sent :not_found, fn ->
        get(conn, Routes.api_admin_announcement_path(conn, :show, announcement.id))
      end
    end
  end

  defp create_announcement(_) do
    announcement = AnnouncementFixtures.announcement_fixture()

    %{announcement: announcement}
  end
end
