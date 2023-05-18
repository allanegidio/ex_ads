defmodule ExAds.AnnouncementsTest do
  use ExAds.DataCase

  alias ExAds.Announcements

  test "list_announcements/0 returns all categories" do
    assert Announcements.list_announcements() == []
  end
end
