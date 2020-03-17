defmodule CovidWeb.Schema.Location do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "A country"
  object :country do
    field :name, non_null(:string)
    field :population, :integer

    field :regions, list_of(:region) do
      resolve(dataloader(Regions))
    end
  end

  @desc "A region"
  object :region do
    field :name, :string
    field :country, non_null(:country)
  end
end
