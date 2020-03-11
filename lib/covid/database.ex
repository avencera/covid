defmodule Covid.Database do
  alias Covid.Database.Query
  alias Covid.Database.Confirmed

  def total_confirmed_by_countries(countries) do
    countries
    |> Enum.map(fn country -> {country, total_confirmed_by(country: country)} end)
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
end
