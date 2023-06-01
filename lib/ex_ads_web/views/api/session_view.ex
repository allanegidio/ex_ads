defmodule ExAdsWeb.Api.SessionView do
  use ExAdsWeb, :view

  alias ExAdsWeb.Api.SessionView
  alias ExAdsWeb.Api.UserView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{
      token: session.token,
      user: UserView.render("show.json", user: session.user)
    }
  end
end
