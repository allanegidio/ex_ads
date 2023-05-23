defmodule ExAds.AnnouncementsTest do
  use ExAds.DataCase

  alias ExAds.Announcements
  alias ExAds.Announcements.Announcement

  test "list_announcements/0 returns all categories" do
    assert Announcements.list_announcements() == []
  end

  test "create_announcement/1 with valid data" do
    attrs = %{title: "Title test", content: "Content test"}

    assert {:ok, %Announcement{title: "Title test", content: "Content test"}} =
             Announcements.create_announcement(attrs)
  end

  test "create_announcement/1 with invalid data" do
    attrs = %{title: "Title test"}

    assert {:error, changeset} = Announcements.create_announcement(attrs)
    assert %{content: ["can't be blank"]} == errors_on(changeset)
  end
end
