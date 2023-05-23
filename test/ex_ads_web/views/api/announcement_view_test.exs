defmodule ExAdsWeb.Api.AnnouncementViewTest do
  use ExAdsWeb.ConnCase

  alias ExAdsWeb.Api.AnnouncementView
  alias ExAds.Announcements.Announcement

  test "render/2 should render many json" do
    announcements = [
      %Announcement{id: "uuid", title: "Title test 1", content: "Content test 1"},
      %Announcement{id: "uuid", title: "Title test 2", content: "Content test 2"},
      %Announcement{id: "uuid", title: "Title test 3", content: "Content test 3"}
    ]

    assert %{data: announcements} =
             AnnouncementView.render("index.json", %{announcements: announcements})
  end
end
