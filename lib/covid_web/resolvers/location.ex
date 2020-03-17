defmodule CovidWeb.Resolvers.Location do
  alias Covid.Database
  alias Covid.Database.Country
  alias Covid.Database.Country.Region

  def list_countries(_parent, _args, _resolution) do
    countries = Database.get_countries()

    {:ok, countries}
  end

  def find_country(_parent, %{name: name}, _resolution) do
    country =
      Database.dump_confirmed()
      |> Enum.map(fn
        %{country: ^name} -> name
        _ -> nil
      end)
      |> Enum.uniq()
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&Country.new/1)
      |> List.first()

    {:ok, country}
  end

  def list_regions(%Country{name: country_name}, _args, _resolution) do
    {:ok,
     Database.dump_confirmed()
     |> Enum.map(fn
       %{country: ^country_name} = e -> e.region
       _ -> nil
     end)
     |> Enum.uniq()
     |> Enum.reject(&is_nil/1)
     |> Enum.reject(fn string -> string == "" end)
     |> Enum.map(&Region.new/1)}
  end

  def list_regions(_parent, _args, _resolution) do
    {:ok,
     Database.dump_confirmed()
     |> Enum.map(fn e -> e.region end)
     |> Enum.uniq()
     |> Enum.map(&Region.new/1)}
  end
end
