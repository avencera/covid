defmodule Covid.Database do
  alias Covid.Database.Server

  def get(date: date) do
    Server.get(date)
  end

  def get(country: country) do
    dump()
    |> Enum.filter(fn entry -> entry.country == country end)
  end

  def total_by(country: country) do
    get(country: country)
    |> Enum.group_by(fn entry -> entry.date end)
    |> Enum.map(fn {date, cases} ->
      total_cases =
        cases
        |> Enum.map(fn entry -> entry.cases end)
        |> Enum.sum()

      {date, total_cases}
    end)
    |> Map.new()
  end

  def dump() do
    Server.dump()
    |> Enum.map(fn {_day, values} -> values end)
    |> List.flatten()
  end
end
