defmodule CovidWeb.API.CaseView do
  alias CovidWeb.API.CaseView
  use CovidWeb, :view

  def render("cases_countries_and_regions.json", %{
        countries: countries,
        regions: regions,
        prediction_type: prediction_type
      }) do
    countries =
      render(
        CaseView,
        "cases_countries.json",
        %{
          cases: countries.cases,
          predicted: countries.predicted,
          prediction_type: prediction_type
        }
      )

    regions =
      render(
        CaseView,
        "cases_regions.json",
        %{
          cases: regions.cases,
          predicted: regions.predicted,
          prediction_type: prediction_type
        }
      )

    Map.merge(regions, countries)
  end

  def render("cases_countries.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type
      }) do
    %{
      countries:
        cases
        |> Enum.map(fn {country, cases} ->
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
        |> Enum.reduce(%{}, fn elem, acc -> Map.put(acc, elem.country, elem) end)
    }
  end

  def render("cases_regions.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type
      }) do
    %{
      regions:
        cases
        |> Enum.map(fn {region, cases} ->
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
        |> Enum.reduce(%{}, fn elem, acc -> Map.put(acc, elem.region, elem) end)
    }
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
