defmodule CovidWeb.API.CountryController do
  use CovidWeb, :controller
  alias Covid.Database

  def index(conn, _params) do
    populations = Database.get_populations()

    countries =
      Database.get_regions()
      |> Enum.map(fn {country, map} ->
        {country, Map.put(map, :population, Map.get(populations, country))}
      end)
      |> Map.new()

    conn
    |> put_status(200)
    |> json(countries)
  end
end
