defmodule Covid.Database.Day.Cache do
  def child_spec(_opts) do
    Supervisor.child_spec(
      {ConCache,
       [
         name: __MODULE__,
         ttl_check_interval: :timer.minutes(30),
         global_ttl: :timer.hours(24)
       ]},
      id: :con_cache_day_cache
    )
  end

  def fetch_for_country(countries, fetcher) do
    ConCache.get_or_store(
      __MODULE__,
      {:fetch, countries},
      fetcher
    )
  end

  def fetch_for_region(regions, fetcher) do
    ConCache.get_or_store(
      __MODULE__,
      {:fetch, regions},
      fetcher
    )
  end
end
