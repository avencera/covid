defmodule CovidWeb.API.CaseController do
  use CovidWeb, :controller
  alias Covid.Database
  alias Covid.Predict.Cache

  def index(conn, %{"country" => country}) do
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
