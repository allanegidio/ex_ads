defmodule ExAdsWeb.PageControllerTest do
  use ExAdsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Allan!"
  end
end
