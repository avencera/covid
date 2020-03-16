defmodule CovidWeb.API.CaseController do
  use CovidWeb, :controller
  alias Covid.Database
  alias Covid.Predict.Cache

  def index(conn, params) do
    countries = params["countries"]
    regions = params["regions"]

    countries =
      if(countries) do
        %{
          cases:
            countries
            |> String.split(",")
            |> Database.total_confirmed_by_countries(),
          predicted:
            countries
            |> String.split(",")
            |> Enum.map(&{&1, Cache.predict_for_country(&1, :weighted_exponential, 200)})
            |> Map.new()
        }
      else
        %{cases: [], predicted: []}
      end

    regions =
      if(regions) do
        %{
          cases:
            regions
            |> String.trim()
            |> String.split(",")
            |> Database.total_confirmed_by_regions(),
          predicted:
            regions
            |> String.trim()
            |> String.split(",")
            |> Enum.map(&{&1, Cache.predict_for_region(&1, :weighted_exponential, 200)})
            |> Map.new()
        }
      else
        %{cases: [], predicted: []}
      end

    render(conn, "cases_countries_and_regions.json",
      countries: countries,
      regions: regions,
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
