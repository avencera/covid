defmodule Covid.Database.Country.Region do
  alias Covid.Database
  alias Covid.Database.Country
  alias Covid.Database.Country.Region

  @type t :: %Region{
          name: String.t(),
          country: nil | Country.t(),
          country_name: String.t()
        }

  defstruct [:name, :country, :country_name]

  def new(region, country_name) do
    %{
      name: region,
      country: nil,
      country_name: country_name
    }
  end

  def data() do
    Dataloader.KV.new(&fetch/2)
  end

  def fetch({:regions, %{}}, _args) do
    %{%{} => list_regions_list()}
  end

  def fetch({:region, %{name: region_name}}, _args) do
    %{
      %{} => Enum.find(list_regions_list(), fn region -> region.name == region_name end)
    }
  end

  def fetch({:from_country, %{}}, countries) do
    countries
    |> Enum.reduce(%{}, fn %{name: country_name} = arg, map ->
      regions =
        Database.get_countries_and_regions()
        |> Enum.filter(fn {country, _regions} -> country.name == country_name end)
        |> Enum.flat_map(fn {_country, regions} -> regions end)

      Map.put(map, arg, regions)
    end)
  end

  defp list_regions_list() do
    Database.get_countries_and_regions()
    |> Enum.map(fn {_country, regions} -> regions end)
    |> List.flatten()
  end
end
