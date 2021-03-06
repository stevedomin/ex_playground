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
    # plug :accepts, ["json", "text"]
  end

  scope "/", ExPlayground do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/s/:id", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/", ExPlayground do
    pipe_through :api

    post "/run", CodeController, :run
    post "/slack", CodeController, :slack
    post "/share", CodeController, :share
  end
end
