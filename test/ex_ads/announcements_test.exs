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

  test "get_announcement!/1" do
    attrs = %{title: "Title test", content: "Content test"}
    {:ok, announcement} = Announcements.create_announcement(attrs)

    assert announcement == Announcements.get_announcement!(announcement.id)
  end

  test "update_announcement/2" do
    attrs = %{title: "Title test", content: "Content test"}
    {:ok, announcement} = Announcements.create_announcement(attrs)

    {:ok, announcement_updated} =
      Announcements.update_announcement(announcement, %{content: "Content Updated test"})

    assert announcement_updated.content == "Content Updated test"
  end

  test "delete_announcement/1" do
    attrs = %{title: "Title test", content: "Content test"}
    {:ok, announcement} = Announcements.create_announcement(attrs)

    {:ok, _announcement_deleted} = Announcements.delete_announcement(announcement)

    assert_raise Ecto.NoResultsError, fn -> Announcements.get_announcement!(announcement.id) end
  end
end
