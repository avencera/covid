defmodule Covid.Format do
  alias Covid.Tailwind
  alias Covid.Predict.Result

  def for_graph(%Result{} = result) do
    result.days
    |> Enum.zip(result.cases)
    |> Enum.map(fn {day, cases} ->
      %{day: day, predicted_cases: cases}
    end)
  end

  def for_graph(cases) do
    cases
    |> Enum.with_index()
    |> Enum.map(fn {{_date, cases}, i} ->
      %{day: i, cases: cases}
    end)
  end

  def get_color(color, shade) do
    Tailwind.colors()
    |> Map.get(color)
    |> Map.get(shade)
  end
end
