defmodule CovidWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Schema.Notation
  alias Covid.Database.Day
  alias Covid.Database.Country
  alias Covid.Database.Country.Region

  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]
  import_types(Absinthe.Type.Custom)

  def context(ctx) do
    loader =
      Dataloader.new(timeout: :timer.seconds(15))
      |> Dataloader.add_source(Countries, Country.data())
      |> Dataloader.add_source(Regions, Region.data())
      |> Dataloader.add_source(Days, Day.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  @desc "A country"
  object :country do
    field :name, non_null(:string)
    field :population, :integer

    field :regions, list_of(:region) do
      resolve dataloader(Regions, :from_country, args: %{})
    end

    field :days, list_of(:day) do
      resolve dataloader(Days, :for_country, args: %{})
    end
  end

  @desc "A region"
  object :region do
    field :name, :string

    field :country, non_null(:country) do
      resolve dataloader(Countries, :from_region, args: %{})
    end

    field :days, list_of(:day) do
      resolve dataloader(Days, :for_region, args: %{})
    end
  end

  @desc "A day"
  object :day do
    field :cases, :integer
    field :predicted, :float
    field :date, :date
    field :day, :integer
  end

  query do
    @desc "Get countries"
    field :countries, list_of(:country) do
      arg :names, list_of(:string)
      resolve dataloader(Countries)
    end

    @desc "Get a country"
    field :country, :country do
      arg :name, non_null(:string)
      resolve dataloader(Countries)
    end

    @desc "Get regions"
    field :regions, list_of(:region) do
      arg :names, list_of(:string)
      resolve dataloader(Regions)
    end

    @desc "Get a region"
    field :region, :region do
      arg :name, non_null(:string)
      resolve dataloader(Regions)
    end
  end
end
