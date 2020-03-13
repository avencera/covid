defmodule CovidWeb.ConfirmedLive do
  use Phoenix.LiveView
  alias Covid.{Format, Database}
  alias Covid.Predict.Cache, as: Predict

  def render(assigns) do
    Phoenix.View.render(CovidWeb.PageView, "confirmed.html", assigns)
  end

  def mount(_params, %{}, socket) do
    current_cases =
      countries_with_colors()
      |> Enum.map(fn {country, _color} -> country end)
      |> Database.total_confirmed_by_countries()
      |> Enum.map(fn {country, cases} ->
        {country, Format.for_graph(cases, Map.get(countries_with_colors(), country))}
      end)
      |> Map.new()

    modeled_cases =
      countries_with_colors()
      |> Enum.map(fn {country, _map} ->
        {country,
         Format.for_graph(
           Predict.predict_for_country(country, :weighted_exponential, 50),
           Map.get(countries_with_colors(), country)
         )}
      end)
      |> Map.new()

    socket =
      socket
      |> assign(:current_cases, current_cases)
      |> assign(:modeled_cases, modeled_cases)
      |> assign(:model_type, :weighted_exponential)

    {:ok, socket}
  end

  def handle_event("exponential", _arg, socket) do
    modeled_cases =
      countries_with_colors()
      |> Enum.map(fn {country, _map} ->
        {country,
         Format.for_graph(
           Predict.predict_for_country(country, :exponential, 50),
           Map.get(countries_with_colors(), country)
         )}
      end)
      |> Map.new()

    socket =
      socket
      |> assign(:modeled_cases, modeled_cases)
      |> assign(:model_type, :exponential)

    {:noreply, socket}
  end

  def handle_event("weighted_exponential", _arg, socket) do
    modeled_cases =
      countries_with_colors()
      |> Enum.map(fn {country, _map} ->
        {country,
         Format.for_graph(
           Predict.predict_for_country(country, :weighted_exponential, 50),
           Map.get(countries_with_colors(), country)
         )}
      end)
      |> Map.new()

    socket =
      socket
      |> assign(:modeled_cases, modeled_cases)
      |> assign(:model_type, :weighted_exponential)

    {:noreply, socket}
  end

  def handle_event("polynomial", _arg, socket) do
    modeled_cases =
      countries_with_colors()
      |> Enum.map(fn {country, _map} ->
        {country,
         Format.for_graph(
           Predict.predict_for_country(country, :polynomial, 50),
           Map.get(countries_with_colors(), country)
         )}
      end)
      |> Map.new()

    socket =
      socket
      |> assign(:modeled_cases, modeled_cases)
      |> assign(:model_type, :polynomial)

    {:noreply, socket}
  end

  def handle_event("none", _arg, socket) do
    socket =
      socket
      |> assign(:modeled_cases, nil)
      |> assign(:model_type, :none)

    {:noreply, socket}
  end

  def countries_with_colors() do
    %{"Canada" => :red, "US" => :blue, "Italy" => :purple, "Korea, South" => :teal}
  end
end
