defmodule CovidWeb.API.CaseView do
  alias CovidWeb.API.CaseView
  use CovidWeb, :view

  def render("cases_countries_and_regions.json", %{
        countries: countries,
        regions: regions,
        prediction_type: prediction_type
      }) do
    countries =
      countries.cases
      |> Enum.map(fn {country, cases} ->
        render(
          CaseView,
          "cases.json",
          %{
            cases: cases,
            predicted: Map.get(countries.predicted, country),
            prediction_type: prediction_type,
            country: country
          }
        )
      end)
      |> Enum.group_by(fn x -> x.country end)

    regions =
      regions.cases
      |> Enum.map(fn {region, cases} ->
        render(
          CaseView,
          "cases.json",
          %{
            cases: cases,
            predicted: Map.get(regions.predicted, region),
            prediction_type: prediction_type,
            region: region
          }
        )
      end)
      |> Enum.group_by(fn x -> x.region end)

    %{countries: countries, regions: regions}
  end

  def render("cases_countries.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type
      }) do
    Enum.map(cases, fn {country, cases} ->
      render(
        CaseView,
        "cases.json",
        %{
          cases: cases,
          predicted: Map.get(predicted, country),
          prediction_type: prediction_type,
          country: country
        }
      )
    end)
  end

  def render("cases_regions.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type
      }) do
    Enum.map(cases, fn {region, cases} ->
      render(
        CaseView,
        "cases.json",
        %{
          cases: cases,
          predicted: Map.get(predicted, region),
          prediction_type: prediction_type,
          region: region
        }
      )
    end)
  end

  def render("cases.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type,
        country: country
      }) do
    cases =
      cases
      |> Enum.map(fn {_date, cases} -> cases end)

    %{
      country: country,
      cases: cases,
      predictions: predicted.cases,
      prediction_type: prediction_type,
      start: "2020-01-22"
    }
  end

  def render("cases.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type,
        region: region
      }) do
    cases =
      cases
      |> Enum.map(fn {_date, cases} -> cases end)

    %{
      region: region,
      cases: cases,
      predictions: predicted.cases,
      prediction_type: prediction_type,
      start: "2020-01-22"
    }
  end
end
