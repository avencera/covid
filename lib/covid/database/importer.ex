defmodule Covid.Database.Importer do
  alias Covid.Database.{Entry, Population}

  NimbleCSV.define(CSV, separator: ",", escape: "\"")

  @spec import(String.t()) :: [Entry.t()]
  def import(file_path) do
    file_path = file_path

    stream =
      file_path
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)

    [_region, _country, _lat, _long | days] =
      stream
      |> Stream.take(1)
      |> Enum.to_list()
      |> List.first()

    days =
      days
      |> Enum.map(&parse_date/1)
      |> Enum.with_index()
      |> Enum.map(fn {date, i} -> {i, date} end)
      |> Map.new()

    stream
    |> Stream.drop(1)
    |> Stream.map(&map(&1, days))
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.group_by(fn entry -> entry.date end)
  end

  def map(list, days) do
    populations = Population.get_all()

    [region, country, lat, long | counts] = list

    counts
    |> Enum.with_index()
    |> Enum.map(fn {count, index} ->
      case count |> String.trim() |> Integer.parse() do
        {cases, ""} ->
          %Entry{
            date: Map.get(days, index),
            cases: cases,
            region: region,
            country: country,
            lat: lat,
            long: long,
            population: Map.get(populations, country)
          }

        _ ->
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_date(date) do
    {:ok, date} =
      date
      |> String.trim()
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)
      |> do_parse_date()

    date
  end

  defp do_parse_date([month, day, year]), do: Date.new(year + 2000, month, day)
end
