defmodule Covid.Database.Day do
  alias Covid.Database
  alias Covid.Database.Day
  alias Covid.Predict.Cache, as: Predict
  alias Covid.Database.Day.Cache

  @type t :: %Day{
          day: integer(),
          date: Date.t(),
          cases: integer(),
          predicted: float
        }

  defstruct [:day, :date, :cases, :predicted]

  def new_from_totals(totals, prediction_results) do
    totals_map =
      totals
      |> Enum.with_index()
      |> Enum.map(fn {{_date, total}, index} ->
        {index, total}
      end)
      |> Map.new()

    prediction_results
    |> Map.get(:cases)
    |> Enum.zip(Map.get(prediction_results, :dates))
    |> Enum.with_index()
    |> Enum.map(fn {{prediction, date}, index} ->
      total = Map.get(totals_map, index, nil)
      %Day{day: index, date: date, cases: total, predicted: prediction}
    end)
  end

  def new_from_entries(entries, prediction_results) do
    entries_map =
      entries
      |> Enum.with_index()
      |> Enum.map(fn {entry, index} ->
        {index, entry.cases}
      end)
      |> Map.new()

    prediction_results
    |> Map.get(:cases)
    |> Enum.zip(Map.get(prediction_results, :dates))
    |> Enum.with_index()
    |> Enum.map(fn {{prediction, date}, index} ->
      total = Map.get(entries_map, index, nil)
      %Day{day: index, date: date, cases: total, predicted: prediction}
    end)
  end

  def data() do
    Dataloader.KV.new(&fetch/2)
  end

  def fetch({:for_region, %{}}, regions) do
    fetcher = fn ->
      regions_map = Database.get_entries_by_region()

      regions
      |> Enum.reduce(%{}, fn %{name: region_name} = arg, acc ->
        entries =
          regions_map
          |> Map.get(region_name)

        predictions = Predict.predict_for_region(region_name, :weighted_exponential, 120)

        days = new_from_entries(entries, predictions)

        Map.put(acc, arg, days)
      end)
    end

    Cache.fetch_for_region(regions, fetcher)
  end

  def fetch({:for_country, %{}}, countries) do
    fetcher = fn ->
      countries_map = Database.get_totals_by_country()

      countries
      |> Enum.reduce(%{}, fn %{name: country_name} = arg, acc ->
        total_tuples =
          countries_map
          |> Map.get(country_name)

        predictions = Predict.predict_for_country(country_name, :weighted_exponential, 120)

        days = new_from_totals(total_tuples, predictions)

        Map.put(acc, arg, days)
      end)
    end

    Cache.fetch_for_country(countries, fetcher)
  end
end
