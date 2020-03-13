defmodule Covid.Format do
  alias Covid.Tailwind
  alias Covid.Predict.Result

  def for_graph(cases), do: for_graph(cases, Tailwind.random_color_group())

  def for_graph(%Result{} = result, color) do
    result.days
    |> Enum.zip(result.dates)
    |> Enum.zip(result.cases)
    |> Enum.map(fn {{day, date}, cases} ->
      %{day: day, predicted_cases: cases, date: date, color: get_color(color, :"400")}
    end)
  end

  def for_graph(cases, color) do
    cases
    |> Enum.with_index()
    |> Enum.map(fn {{date, cases}, i} ->
      %{day: i, cases: cases, date: date, color: get_color(color, :"600")}
    end)
  end

  def get_color(color, shade) do
    Covid.Tailwind.colors()
    |> Map.get(color)
    |> Map.get(shade)
  end
end
