defmodule Covid.Entry do
  alias Covid.Entry

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
