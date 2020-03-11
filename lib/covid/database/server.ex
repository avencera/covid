defmodule Covid.Database.Server do
  use GenServer
  @name __MODULE__

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

  def get(date, db) do
    [{_k, v} | _] = :ets.lookup(db, date)
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
      },
      %{
        module: Covid.Database.Recovered,
        file: Application.app_dir(:covid, "priv/data/time_series_recovered.csv")
      },
      %{
        module: Covid.Database.Deaths,
        file: Application.app_dir(:covid, "priv/data/time_series_deaths.csv")
      }
    ]
  end
end
