defmodule Covid.Database.Day do
  alias Covid.Database
  alias Covid.Database.Day
  alias Covid.Predict.Cache, as: Predict

  @type t :: %Day{
          day: integer(),
          date: Date.t(),
          cases: integer(),
          predicted: float
        }

  defstruct [:day, :date, :cases, :predicted]

  def new_from(entries, prediction_results) do
    predictions_map =
      prediction_results
      |> Map.get(:cases)
      |> Enum.with_index()
      |> Enum.map(fn {prediction, index} -> {index, prediction} end)
      |> Map.new()

    entries
    |> Enum.map(fn entry ->
      %Day{
        day: entry.day,
        date: entry.date,
        cases: entry.cases,
        predicted: Map.get(predictions_map, entry.day)
      }
    end)
  end

  def data() do
    Dataloader.KV.new(&fetch/2)
  end

  def fetch({:for_region, %{}}, regions) do
    regions_map = Database.get_entires_by_region()

    regions
    |> Enum.reduce(%{}, fn %{name: region_name} = arg, acc ->
      entries =
        regions_map
        |> Enum.filter(fn {region, _entries} -> region.name == region_name end)
        |> Enum.flat_map(fn {_region, entries} ->
          entries
        end)

      predictions = Predict.predict_for_region(region_name, :weighted_exponential, 90)

      days = new_from(entries, predictions)

      Map.put(acc, arg, days)
    end)
  end
end
