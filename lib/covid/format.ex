defmodule Covid.Format do
  alias Covid.Tailwind

  def for_graph(cases), do: for_graph(cases, Tailwind.random_color_group())

  def for_graph(cases, color) do
    color =
      Covid.Tailwind.colors()
      |> Map.get(color)
      |> Map.get(:"600")

    cases
    |> Enum.with_index()
    |> Enum.map(fn {{date, cases}, i} -> %{x: i, y: cases, date: date, color: color} end)
  end
end
