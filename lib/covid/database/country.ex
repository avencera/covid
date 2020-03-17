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
end
