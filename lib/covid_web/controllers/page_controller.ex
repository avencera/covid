defmodule CovidWeb.PageController do
  alias Covid.Database
  use CovidWeb, :controller
  alias Covid.Format
  alias CovidWeb.ConfirmedLive

  def confirmed(conn, _params) do
    live_render(conn, ConfirmedLive, session: %{})
  end

  def recovered(conn, _params) do
    countries_with_colors = %{
      "Canada" => :red,
      "US" => :blue,
      "Italy" => :purple,
      "Republic of Korea" => :teal
    }

    cases =
      countries_with_colors
      |> Enum.map(fn {country, _color} -> country end)
      |> Database.total_recovered_by_countries()
      |> Enum.map(fn {country, cases} ->
        {country, Format.for_graph(cases, Map.get(countries_with_colors, country))}
      end)
      |> Map.new()

    render(conn, "recovered.html", cases: cases)
  end

  def deaths(conn, _params) do
    countries_with_colors = %{
      "Canada" => :red,
      "US" => :blue,
      "Italy" => :purple,
      "Republic of Korea" => :teal
    }

    cases =
      countries_with_colors
      |> Enum.map(fn {country, _color} -> country end)
      |> Database.total_deaths_by_countries()
      |> Enum.map(fn {country, cases} ->
        {country, Format.for_graph(cases, Map.get(countries_with_colors, country))}
      end)
      |> Map.new()

    render(conn, "deaths.html", cases: cases)
  end
end
