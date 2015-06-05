defmodule ExPlayground.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    #plug :accepts, ~w(json text-event/stream)
  end

  scope "/", ExPlayground do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ExPlayground do
    pipe_through :api

    post "/run", CodeController, :run
    get "/stream/:id", CodeController, :stream
  end
end
