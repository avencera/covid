defmodule CovidWeb.PageController do
  alias Covid.Database
  use CovidWeb, :controller
  alias Covid.Format

  def current(conn, _params) do
    countries_with_colors = %{
      "Canada" => :red,
      "US" => :blue,
      "Italy" => :purple,
      "Republic of Korea" => :teal
    }

    cases =
      countries_with_colors
      |> Enum.map(fn {country, _color} -> country end)
      |> Database.total_confirmed_by_countries()
      |> Enum.map(fn {country, cases} ->
        {country, Format.for_graph(cases, Map.get(countries_with_colors, country))}
      end)
      |> Map.new()

    render(conn, "current.html", cases: cases)
  end

  def future(conn, _params) do
    countries_with_colors = %{
      "Canada" => :red,
      "US" => :blue,
      "Italy" => :purple,
      "Republic of Korea" => :teal
    }

    cases =
      countries_with_colors
      |> Enum.map(fn {country, _color} -> country end)
      |> Database.total_confirmed_by_countries()
      |> Enum.map(fn {country, cases} ->
        {country, Format.for_graph(cases, Map.get(countries_with_colors, country))}
      end)
      |> Map.new()

    render(conn, "current.html", cases: cases)
  end
end
