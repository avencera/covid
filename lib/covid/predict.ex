defmodule Covid.Predict do
  alias Covid.Database, as: DB
  alias LearnKit.Regression.Polynomial

  @spec model_for_country(String.t()) :: Polynomial.t()
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
    |> LearnKit.Regression.Polynomial.new(results)
    |> LearnKit.Regression.Polynomial.fit(degree: 4)
  end

  @spec score(Polynomial.t()) :: {:ok, float} | :error
  def score(model), do: Polynomial.score(model)
end
