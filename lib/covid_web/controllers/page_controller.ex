defmodule CovidWeb.PageController do
  use CovidWeb, :controller
  alias CovidWeb.ConfirmedLive

  def confirmed(conn, _params) do
    live_render(conn, ConfirmedLive, session: %{})
  end
end
