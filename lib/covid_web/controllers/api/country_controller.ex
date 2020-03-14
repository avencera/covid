defmodule CovidWeb.API.CountryController do
  use CovidWeb, :controller
  alias Covid.Database
  alias Covid.Predict.Cache

  def index(conn, _params) do
    countries =
      Database.dump_confirmed()
      |> Enum.map(fn e -> e.country end)
      |> Enum.uniq()

    conn
    |> put_status(200)
    |> json(countries)
  end
end
