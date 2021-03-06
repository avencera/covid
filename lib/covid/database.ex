defmodule Covid.Database do
  alias Covid.Database.Query
  alias Covid.Database.{Confirmed}
  alias Covid.Database.Country
  alias Covid.Database.Country.{Population, Region}

  def total_confirmed_by_countries(countries) do
    countries
    |> Enum.map(fn country -> {country, total_confirmed_by(country: country)} end)
    |> Map.new()
  end

  def total_confirmed_by_regions(regions) do
    regions
    |> Enum.map(fn region -> {region, total_confirmed_by(region: region)} end)
    |> Map.new()
  end

  def total_recovered_by_countries(countries) do
    countries
    |> Enum.map(fn country -> {country, total_recovered_by(country: country)} end)
    |> Map.new()
  end

  def total_deaths_by_countries(countries) do
    countries
    |> Enum.map(fn country -> {country, total_deaths_by(country: country)} end)
    |> Map.new()
  end

  def get_confirmed(getter), do: Query.get(Confirmed, getter)

  def total_confirmed_by(getter), do: Query.total_by(Confirmed, getter)

  def dump_confirmed(), do: Query.dump(Confirmed)

  def convert_dates_to_days(results) do
    results
    |> Enum.with_index()
    |> Enum.map(fn {{_d, v}, i} -> {i, v} end)
  end

  def total_recovered_by(getter), do: Query.total_by(Recovered, getter)
  def total_deaths_by(getter), do: Query.total_by(Deaths, getter)

  def last_confirmed_date_by_country(country) do
    total_confirmed_by(country: country)
    |> List.last()
    |> elem(0)
  end

  def get_population(country), do: Population.get(country)
  def get_populations(), do: Population.get_all()

  def get_countries_and_regions() do
    dump_confirmed()
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
      country = Country.new(country)

      regions =
        regions
        |> Enum.reject(&is_nil/1)
        |> Enum.map(&Region.new(&1, country.name))

      {country, regions}
    end)
    |> Map.new()
  end

  def get_entries_by_region() do
    dump_confirmed()
    |> Enum.map(fn entry -> {Region.new(entry.region, entry.country), entry} end)
    |> Enum.reject(fn {region, _entries} -> region.name == "" end)
    |> Enum.group_by(
      fn {region, _entries} -> region.name end,
      fn {_region, entries} -> entries end
    )
  end

  def get_totals_by_country() do
    get_countries_and_regions()
    |> Enum.map(fn {country, _regions} ->
      {country.name, total_confirmed_by(country: country.name)}
    end)
    |> Map.new()
  end
end
