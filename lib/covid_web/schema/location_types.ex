defmodule CovidWeb.Schema.Location do
  use Absinthe.Schema.Notation
  alias CovidWeb.Resolvers

  @desc "A country"
  object :country do
    field :name, :string
    field :population, :integer

    field :regions, list_of(:region) do
      resolve(&Resolvers.Location.list_regions/3)
    end
  end

  @desc "A region"
  object :region do
    field :name, :string
    field :country, non_null(:country)
  end
end
