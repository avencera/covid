defmodule Covid.Database.Entry do
  alias Covid.Database.Entry

  defstruct [:date, :region, :country, :lat, :long, :cases, :population, :day]

  @type t :: %Entry{
          day: integer(),
          date: DateTime.t(),
          region: String.t(),
          country: String.t(),
          lat: String.t(),
          long: String.t(),
          cases: integer(),
          population: pos_integer()
        }
end
