defmodule Covid.Database.Entry do
  alias Covid.Database.Entry

  defstruct [:date, :state, :country, :lat, :long, :cases]

  @type t :: %Entry{
          date: DateTime.t(),
          state: String.t(),
          country: String.t(),
          lat: String.t(),
          long: String.t(),
          cases: integer()
        }
end
