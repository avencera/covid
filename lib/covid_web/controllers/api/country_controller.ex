defmodule CovidWeb.API.CountryController do
  use CovidWeb, :controller
  alias Covid.Database

  def index(conn, _params) do
    populations = Database.get_populations()

    countries =
      Database.get_countries_and_regions()
      |> Enum.map(fn {country, regions} ->
        {country.name,
         %{regions: Enum.map(regions, & &1.name), population: Map.get(populations, country.name)}}
      end)
      |> Map.new()

    conn
    |> put_status(200)
    |> json(countries)
  end
end
