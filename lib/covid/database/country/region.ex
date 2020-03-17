defmodule Covid.Database.Country.Region do
  alias Covid.Database
  alias Covid.Database.Country
  alias Covid.Database.Country.Region

  @type t :: %Region{
          name: String.t(),
          country: Country.t()
        }

  defstruct [:name, :country]

  def new(region) do
    %{
      name: region,
      country: %{}
    }
  end

  def data() do
    Dataloader.KV.new(&fetch/2)
  end

  def fetch({:regions, %{}}, _args) do
    list_regions()
  end

  def fetch({:region, %{name: region_name}, _args}) do
    %{
      %{} => Enum.find(list_regions(), fn region -> region.name == region_name end)
    }
  end

  defp list_regions() do
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
      {Country.new(country), regions |> Enum.reject(&is_nil/1) |> Enum.map(&Region.new/1)}
    end)
    |> Enum.reduce(%{}, fn {country, regions}, acc -> Map.put(acc, country, regions) end)
  end
end
