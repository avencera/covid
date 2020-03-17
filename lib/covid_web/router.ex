defmodule CovidWeb.Router do
  use CovidWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CovidWeb.API do
    pipe_through [:api]
    get "/countries", CountryController, :index

    get "/confirmed/", CaseController, :index
    get "/confirmed/:country", CaseController, :show
  end

  scope "/api" do
    pipe_through [:api]

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: CovidWeb.Schema,
      socket: CovidWeb.UserSocket

    forward "/", Absinthe.Plug, schema: CovidWeb.Schema
  end

  scope "/", CovidWeb do
    pipe_through [:browser]
    get "/", PageController, :confirmed
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
