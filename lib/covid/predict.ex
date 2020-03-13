defmodule Covid.Predict do
  alias Covid.Database, as: DB
  alias Covid.Predict.Exponential

  defmodule Result do
    @enforce_keys [:days, :cases]
    defstruct [:days, :cases]

    def new({days, cases}) do
      %Result{days: days, cases: cases}
    end
  end

  def predict_for_country(country, days \\ 100) do
    model = model_for_country(country)

    last_day = List.last(model.factors)

    days =
      1..days
      |> Enum.map(fn x -> last_day + x end)

    cases = Enum.map(days, fn day -> Exponential.predict(model, day) end)

    Result.new({days, cases})
  end

  @spec model_for_country(String.t()) :: Covid.Predict.Exponential.Model.t()
  def model_for_country(country) do
    factors_and_results =
      DB.total_confirmed_by(country: country)
      |> DB.convert_dates_to_days()

    factors =
      factors_and_results
      |> Enum.map(&elem(&1, 0))

    results =
      factors_and_results
      |> Enum.map(&elem(&1, 1))

    factors
    |> remove_zeros(results)
    |> Exponential.fit()
  end

  def remove_zeros(factors, results) do
    mapper =
      results
      |> Enum.with_index()
      |> Enum.map(fn
        {n, i} when n <= 0 -> {i, :remove}
        {_n, i} -> {i, :keep}
      end)
      |> Map.new()

    factors =
      factors
      |> Enum.with_index()
      |> Enum.filter(fn {_x, i} -> Map.get(mapper, i) == :keep end)
      |> Enum.map(&elem(&1, 0))

    results =
      results
      |> Enum.with_index()
      |> Enum.filter(fn {_x, i} -> Map.get(mapper, i) == :keep end)
      |> Enum.map(&elem(&1, 0))

    {factors, results}
  end
end
