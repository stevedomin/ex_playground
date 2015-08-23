defmodule ExPlayground.Router do
  use ExPlayground.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    #plug :accepts, ~w(json text-event/stream)
  end

  scope "/", ExPlayground do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/s/:id", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ExPlayground do
    pipe_through :api

    post "/run", CodeController, :run
    post "/share", CodeController, :share
    post "/stream", CodeController, :create_stream
    get "/stream/:id", CodeController, :stream
  end
end
