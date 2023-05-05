defmodule ExAdsWeb.PageController do
  use ExAdsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
