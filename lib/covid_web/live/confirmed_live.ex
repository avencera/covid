defmodule CovidWeb.ConfirmedLive do
  use Phoenix.LiveView
  alias Covid.{Format, Database}
  alias Covid.Predict.Cache, as: Predict
  alias Covid.Format

  def render(assigns) do
    Phoenix.View.render(CovidWeb.PageView, "confirmed.html", assigns)
  end

  def mount(_params, %{}, socket) do
    current_cases =
      countries()
      |> Database.total_confirmed_by_countries()
      |> Enum.map(fn {country, cases} ->
        {country, Format.for_graph(cases)}
      end)
      |> Map.new()

    modeled_cases =
      countries()
      |> Enum.map(fn country ->
        {country,
         country
         |> Predict.predict_for_country(:weighted_exponential, days_to_model())
         |> Format.for_graph()}
      end)
      |> Map.new()

    countries_with_colors =
      %{"Canada" => :red, "US" => :blue, "Italy" => :purple, "Korea, South" => :teal}
      |> Enum.map(fn {country, color} ->
        {country,
         %{cases: Format.get_color(color, :"600"), predictions: Format.get_color(color, :"400")}}
      end)
      |> Map.new()

    last_day =
      current_cases
      |> Map.get("Canada")
      |> List.last()
      |> Map.get(:day)

    dates =
      0..(last_day + days_to_model())
      |> Enum.map(fn day -> {day, Date.add(start_date(), day)} end)
      |> Map.new()

    socket =
      socket
      |> assign(:current_cases, current_cases)
      |> assign(:countries_with_colors, countries_with_colors)
      |> assign(:modeled_cases, modeled_cases)
      |> assign(:dates, dates)
      |> assign(:model_type, :weighted_exponential)

    {:ok, socket}
  end

  def handle_event("exponential", _arg, socket) do
    modeled_cases =
      countries()
      |> Enum.map(fn country ->
        {country,
         country
         |> Predict.predict_for_country(:exponential, days_to_model())
         |> Format.for_graph()}
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
      countries()
      |> Enum.map(fn country ->
        {country,
         country
         |> Predict.predict_for_country(:weighted_exponential, days_to_model())
         |> Format.for_graph()}
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
      countries()
      |> Enum.map(fn country ->
        {country,
         country
         |> Predict.predict_for_country(:polynomial, days_to_model())
         |> Format.for_graph()}
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

  def countries() do
    ["Canada", "US", "Italy", "Korea, South"]
  end

  defp start_date() do
    {:ok, date} = Date.new(2020, 1, 22)
    date
  end

  defp days_to_model(), do: 50
end
