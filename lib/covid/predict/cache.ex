defmodule Covid.Predict.Cache do
  alias Covid.Predict

  def child_spec(_opts) do
    Supervisor.child_spec(
      {ConCache,
       [
         name: __MODULE__,
         ttl_check_interval: :timer.minutes(30),
         global_ttl: :timer.hours(12)
       ]},
      id: :con_cache_itunes_fast_cache
    )
  end

  def predict_for_country(country, type, days) do
    ConCache.get_or_store(
      __MODULE__,
      "#{country}-#{type}",
      fn -> Predict.predict_for_country(country, type, days) end
    )
  end
end
