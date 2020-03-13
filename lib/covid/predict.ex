defmodule Covid.Predict do
  alias Covid.Database, as: DB
  alias Covid.Predict.Exponential
  alias Covid.Database
  alias LearnKit.Regression.Polynomial

  @type(type :: :exponential, :polynomial, :weighted_exponential)

  defmodule Result do
    @enforce_keys [:days, :cases, :country, :dates]
    defstruct [:days, :cases, :country, :dates]

    def new(country, days, cases) do
      starting_date = Database.last_confirmed_date_by_country(country)

      dates =
        1..Enum.count(days)
        |> Enum.map(fn x -> Date.add(starting_date, x) end)

      %Result{days: days, cases: cases, country: country, dates: dates}
    end
  end

  def predict_for_country(country, type, days \\ 90) do
    model = model_for_country(country, type)

    last_day = List.last(model.factors)

    days = 1..(last_day + days)

    cases =
      days
      |> Enum.map(fn day -> predict(model, day, type) end)
      |> Enum.map(fn
        x when x < 0 ->
          0

        x ->
          case {country, x} do
            {"Italy", x} when x > 60_000_000 -> 60_000_000
            {"US", x} when x > 300_000_000 -> 300_000_000
            {"Korea, South", x} when x > 51_000_000 -> 51_000_000
            {"Canada", x} when x > 40_000 -> 40_0000
            _ -> x
          end
      end)
      |> Enum.reject(&is_nil/1)

    Result.new(country, days, cases)
  end

  @spec model_for_country(String.t(), type) :: Polynomial.t() | Exponential.Model.t()
  def model_for_country(country, type) do
    factors_and_results =
      DB.total_confirmed_by(country: country)
      |> DB.convert_dates_to_days()

    factors =
      factors_and_results
      |> Enum.map(&elem(&1, 0))

    results =
      factors_and_results
      |> Enum.map(&elem(&1, 1))

    model_for_x_and_ys(factors, results, type)
  end

  @spec model_for_x_and_ys([number()], [number()], :exponential) :: Exponential.Model.t()
  def model_for_x_and_ys(factors, results, :exponential) do
    factors
    |> remove_zeros(results)
    |> Exponential.fit(:exponential)
  end

  @spec model_for_x_and_ys([number()], [number()], :weighted_exponential) :: Exponential.Model.t()
  def model_for_x_and_ys(factors, results, :weighted_exponential) do
    factors
    |> remove_zeros(results)
    |> Exponential.fit(:weighted_exponential)
  end

  @spec model_for_x_and_ys([number()], [number()], :polynomial) :: Polynomial.t()
  def model_for_x_and_ys(factors, results, :polynomial) do
    factors
    |> LearnKit.Regression.Polynomial.new(results)
    |> LearnKit.Regression.Polynomial.fit(degree: 4)
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

  def predict(model, day, type) when type in [:exponential, :weighted_exponential] do
    Exponential.predict(model, day)
  end

  def predict(model, day, :polynomial) do
    case Polynomial.predict(model, day) do
      {:ok, prediction} -> prediction
      _ -> nil
    end
  end
end
