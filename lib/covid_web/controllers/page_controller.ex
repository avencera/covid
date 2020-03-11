defmodule CovidWeb.PageController do
  use CovidWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
