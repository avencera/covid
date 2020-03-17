defmodule CovidWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Schema.Notation
  alias Covid.Database.Country
  alias Covid.Database.Country.Region

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  import_types(Absinthe.Type.Custom)

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Countries, Country.data())
      |> Dataloader.add_source(Regions, Region.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    @desc "Get all countries"
    field :countries, list_of(:country) do
      resolve(dataloader(Countries))
    end

    @desc "Get a country"
    field :country, :country do
      arg(:name, :string)
      resolve(dataloader(Countries))
    end

    @desc "Get all regions"
    field :regions, list_of(:region) do
      resolve(dataloader(Regions))
    end

    @desc "Get a region"
    field :region, :region do
      arg(:name, :string)
      resolve(dataloader(Regions))
    end
  end

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

    field :country, non_null(:country) do
      resolve(dataloader(Countries))
    end
  end
end
