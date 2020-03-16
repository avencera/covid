defmodule CovidWeb.API.CountryController do
  use CovidWeb, :controller
  alias Covid.Database

  def index(conn, _params) do
    populations = Database.get_populations()

    countries =
      Database.dump_confirmed()
      |> Enum.map(fn e -> {e.country, e.region} end)
      |> Enum.uniq()
      |> Enum.group_by(
        fn {country, _region} -> country end,
        fn {_country, region} ->
          case region do
            "" -> nil
            region -> region
          end
        end
      )
      |> Enum.map(fn {country, regions} ->
        {country,
         %{
           regions: Enum.reject(regions, &is_nil/1),
           population: Map.get(populations, country)
         }}
      end)
      |> Map.new()

    conn
    |> put_status(200)
    |> json(countries)
  end
end
