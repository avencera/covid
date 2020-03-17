defmodule Covid.Database.Country.Region do
  alias Covid.Database.Country.Region

  @type t :: %Region{
          name: String.t(),
          country: Covid.Database.Country.t()
        }

  defstruct [:name, :country]

  def new(region) do
    %{
      name: region,
      country: %{}
    }
  end
end
