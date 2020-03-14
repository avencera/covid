defmodule CovidWeb.API.CaseView do
  alias CovidWeb.API.CaseView
  use CovidWeb, :view

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
end
