defmodule Covid.Database.Query do
  alias Covid.Database.Server

  def get(db, date: date) do
    Server.get(date, db)
  end

  def get(db, country: country) do
    db
    |> dump()
    |> Enum.filter(fn entry -> entry.country == country end)
  end

  def get(db, region: region) do
    db
    |> dump()
    |> Enum.filter(fn entry -> entry.region == region end)
  end

  def total_by(db, region: region) do
    db
    |> get(region: region)
    |> group_and_sort()
  end

  def total_by(db, country: country) do
    db
    |> get(country: country)
    |> group_and_sort()
  end

  defp group_and_sort(cases) do
    cases
    |> Enum.group_by(fn entry -> entry.date end)
    |> Enum.map(fn {date, cases} ->
      total_cases =
        cases
        |> Enum.map(fn entry -> entry.cases end)
        |> Enum.sum()

      {date, total_cases}
    end)
    |> Enum.sort_by(fn {d, _v} -> {d.year, d.month, d.day} end)
  end

  def dump(db) do
    Server.dump(db)
    |> Enum.map(fn {_day, values} -> values end)
    |> List.flatten()
  end
end
