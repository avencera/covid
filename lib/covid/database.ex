defmodule Covid.Database do
  alias Covid.Database.Query
  alias Covid.Database.Confirmed

  def get_confirmed(getter), do: Query.get(Confirmed, getter)

  def total_confirmed_by(getter), do: Query.total_by(Confirmed, getter)

  def dump_confirmed(), do: Query.dump(Confirmed)
end
