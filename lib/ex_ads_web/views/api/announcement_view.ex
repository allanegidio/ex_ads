defmodule ExAdsWeb.Api.AnnouncementView do
  use ExAdsWeb, :view

  def render("index.json", %{announcements: announcements}) do
    %{data: render_many(announcements, __MODULE__, "announcements.json")}
  end

  def render("show.json", %{announcement: announcement}) do
    %{data: render_one(announcement, __MODULE__, "announcements.json")}
  end

  def render("announcements.json", %{announcement: announcement}) do
    %{
      id: announcement.id,
      title: announcement.title,
      content: announcement.content
    }
  end
end
