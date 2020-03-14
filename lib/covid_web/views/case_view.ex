defmodule CovidWeb.API.CaseView do
  use CovidWeb, :view

  def render("cases.json", %{
        cases: cases,
        predicted: predicted,
        prediction_type: prediction_type,
        country: country
      }) do
    cases =
      cases
      |> Enum.with_index()
      |> Enum.map(fn {{date, cases}, day} ->
        %{
          date: date,
          value: cases,
          type: :confirmed,
          day: day,
          country: country
        }
      end)

    predictions =
      predicted.dates
      |> Enum.zip(predicted.cases)
      |> Enum.with_index()
      |> Enum.map(fn {{date, cases}, day} ->
        %{
          date: date,
          prediction: cases,
          day: day,
          type: :prediction,
          prediction_type: prediction_type,
          country: country
        }
      end)

    %{cases: cases, predictions: predictions}
  end
end
