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
    :ets.new(name, [:set, :named_table, :public, read_concurrency: true])

    seed()

    {:ok, name}
  end

  def seed() do
    Enum.map(Covid.Database.Importer.import(), fn {date, entry} ->
      :ets.insert(@name, {date, entry})
    end)
  end

  def get(date) do
    [{_k, v} | _] = :ets.lookup(@name, date)
    v
  end

  def dump() do
    :ets.tab2list(@name)
  end
end
