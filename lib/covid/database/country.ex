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

  defp list_countries() do
    Database.dump_confirmed()
    |> Enum.map(fn e -> e.country end)
    |> Enum.uniq()
    |> Enum.map(&Country.new/1)
  end
end
