defmodule CovidWeb.API.CaseController do
  use CovidWeb, :controller
  alias Covid.Database
  alias Covid.Predict.Cache

  def index(conn, %{"countries" => countries}) do
    confirmed =
      countries
      |> String.split(",")
      |> Database.total_confirmed_by_countries()

    predicted =
      countries
      |> String.split(",")
      |> Enum.map(&{&1, Cache.predict_for_country(&1, :weighted_exponential, 200)})
      |> Map.new()

    render(conn, "cases_countries.json",
      cases: confirmed,
      predicted: predicted,
      prediction_type: :weighted_exponential
    )
  end

  def show(conn, %{"country" => country}) do
    confirmed = Database.total_confirmed_by(country: country)

    predicted = Cache.predict_for_country(country, :weighted_exponential, 200)

    render(conn, "cases.json",
      cases: confirmed,
      predicted: predicted,
      prediction_type: :weighted_exponential,
      country: country
    )
  end
end
