defmodule CovidWeb.ConfirmedLive do
  use Phoenix.LiveView
  alias Covid.{Format, Database, Predict}

  def render(assigns) do
    Phoenix.View.render(CovidWeb.PageView, "confirmed.html", assigns)
  end

  def mount(_params, %{}, socket) do
    countries_with_colors = %{
      "Canada" => :red,
      "US" => :blue,
      "Italy" => :purple,
      "Korea, South" => :teal
    }

    current_cases =
      countries_with_colors
      |> Enum.map(fn {country, _color} -> country end)
      |> Database.total_confirmed_by_countries()
      |> Enum.map(fn {country, cases} ->
        {country, Format.for_graph(cases, Map.get(countries_with_colors, country))}
      end)
      |> Map.new()

    modeled_cases =
      countries_with_colors
      |> Enum.map(fn {country, _map} ->
        {country,
         Format.for_graph(
           Predict.predict_for_country(country, :weighted_exponential, 50),
           Map.get(countries_with_colors, country)
         )}
      end)
      |> Map.new()

    socket =
      socket
      |> assign(:current_cases, current_cases)
      |> assign(:modeled_cases, modeled_cases)

    {:ok, socket}
  end
end
