defmodule CovidWeb.API.CountryController do
  use CovidWeb, :controller
  alias Covid.Database

  def index(conn, _params) do
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
      |> Enum.map(fn {country, regions} -> {country, Enum.reject(regions, &is_nil/1)} end)
      |> Map.new()

    conn
    |> put_status(200)
    |> json(countries)
  end
end
