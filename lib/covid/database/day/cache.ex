defmodule Covid.Database.Day.Cache do
  def child_spec(_opts) do
    Supervisor.child_spec(
      {ConCache,
       [
         name: __MODULE__,
         ttl_check_interval: :timer.minutes(30),
         global_ttl: :timer.hours(48),
         read_concurrency: true
       ]},
      id: :con_cache_day_cache
    )
  end

  def fetch_for_country(countries, fetcher) do
    get_or_store_long({:fetch, countries}, fetcher)
  end

  def fetch_for_region(regions, fetcher) do
    get_or_store_long({:fetch, regions}, fetcher)
  end

  defp get_or_store_long(key, fun) do
    case ConCache.get(__MODULE__, key) do
      nil ->
        task = Task.Supervisor.async_nolink(Covid.CacheSupervisor.TaskSupervisor, fun)
        results = Task.await(task, :timer.minutes(3))
        ConCache.put(__MODULE__, key, results)
        results

      results ->
        results
    end
  end
end
