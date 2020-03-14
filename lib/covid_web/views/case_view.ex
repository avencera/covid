defmodule CovidWeb.API.CaseView do
  use CovidWeb, :view

  def render("cases.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type,
        country: country
      }) do
    %{
      country => %{cases: cases, predictions: predicted.cases},
      prediction_type: prediction_type,
      start: "2020-01-22"
    }
  end
end
