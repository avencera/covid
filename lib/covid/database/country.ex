defmodule Covid.Database.Country do
  alias Covid.Database
  alias Covid.Database.{Country}
  alias Covid.Database.Country.{Region, Population}

  @type t :: %Country{
          name: String.t(),
          regions: [Region.t()],
          population: Population.t()
        }

  defstruct [:name, :regions, :population]

  def new(country), do: new(country, Database.get_populations())

  def new(country, populations) do
    %Country{
      name: country,
      regions: [],
      population: Map.get(populations, country)
    }
  end

  def data() do
    Dataloader.KV.new(&fetch/2)
  end

  def fetch({:countries, %{names: names}}, _args) do
    countries =
      list_countries()
      |> Enum.filter(fn country -> country.name in names end)

    %{%{} => countries}
  end

  def fetch({:countries, %{}}, _args) do
    %{
      %{} => list_countries()
    }
  end

  def fetch({:country, %{name: country_name}}, _args) do
    %{
      %{} => Enum.find(list_countries(), fn country -> country.name == country_name end)
    }
  end

  def fetch({:from_region, %{}}, regions) do
    countries = Database.get_countries_and_regions()

    regions
    |> Enum.reduce(%{}, fn region, acc ->
      country =
        countries
        |> Enum.filter(fn {country, _regions} -> country.name == region.country_name end)
        |> Enum.map(fn {country, _region} -> country end)
        |> List.first()

      Map.put(acc, region, country)
    end)
  end

  defp list_countries() do
    Database.get_countries_and_regions()
    |> Enum.map(fn {country, _regions} -> country end)
  end
end
