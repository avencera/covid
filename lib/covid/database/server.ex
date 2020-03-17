defmodule Covid.Database.Server do
  use GenServer
  @name __MODULE__
  alias Covid.Database.Country.Population

  def child_spec([]) do
    %{
      id: @name,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link() do
    GenServer.start_link(__MODULE__, @name, name: @name)
  end

  @impl true
  def init(name) do
    :ets.new(Population, [:set, :named_table, :public, read_concurrency: true])
    :ets.insert(Population, {:populations, Population.seed()})

    Enum.each(dbs(), fn %{module: module, file: file} ->
      :ets.new(module, [:set, :named_table, :public, read_concurrency: true])
      seed(module, file)
    end)

    {:ok, name}
  end

  defp seed(module, file) do
    file
    |> Covid.Database.Importer.import()
    |> Enum.map(fn {date, entry} -> :ets.insert(module, {date, entry}) end)
  end

  def get(key, db) do
    [{_k, v} | _] = :ets.lookup(db, key)
    v
  end

  def dump(db) do
    :ets.tab2list(db)
  end

  def dbs() do
    [
      %{
        module: Covid.Database.Confirmed,
        file: Application.app_dir(:covid, "priv/data/time_series_confirmed.csv")
      }
    ]
  end
end
