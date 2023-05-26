defmodule ExAdsWeb.AnnouncementFixtures do
  alias ExAds.Announcements

  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExAds.Announcements` context.
  """

  @doc """
  Generate a unique announcement title.
  """
  def unique_announcement_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def announcement_fixture(attrs \\ %{}) do
    {:ok, announcement} =
      attrs
      |> Enum.into(%{
        content: "some description",
        title: unique_announcement_title()
      })
      |> Announcements.create_announcement()

    announcement
  end
end
