defmodule Covid.Database.Country.Population do
  alias Covid.Database.Server
  alias Covid.Database.Country.Population

  @type t :: nil | pos_integer()

  def get(country) do
    Map.get(get_all(), country)
  end

  def get_all() do
    Server.get(:populations, Population)
  end

  def seed() do
    Application.app_dir(:covid, "priv/data/population.csv")
    |> File.stream!()
    |> CSV.parse_stream()
    |> Enum.to_list()
    |> Enum.reduce(%{}, fn [country, population | _], acc ->
      Map.put(acc, country, parse_population(population))
    end)
  end

  defp parse_population(nil), do: nil
  defp parse_population(number) when is_number(number), do: number

  defp parse_population(string) when is_binary(string) do
    ~r/\d/
    |> Regex.scan(string)
    |> List.flatten()
    |> Enum.join("")
    |> Integer.parse()
    |> case do
      {population, ""} -> population
      _ -> nil
    end
  end
end
