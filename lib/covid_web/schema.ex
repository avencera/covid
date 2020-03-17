defmodule CovidWeb.Schema do
  use Absinthe.Schema
  alias CovidWeb.Resolvers

  import_types(Absinthe.Type.Custom)
  import_types(CovidWeb.Schema.Location)

  @desc "Get all countries"
  query do
    field :countries, list_of(:country) do
      resolve(&Resolvers.Location.list_countries/3)
    end

    field :country, :country do
      arg(:name, :string)
      resolve(&Resolvers.Location.find_country/3)
    end
  end
end
