defmodule ExPlayground.Endpoint do
  use Phoenix.Endpoint, otp_app: :ex_playground

  # Serve at "/" the given assets from "priv/static" directory
  plug Plug.Static,
    at: "/", from: :ex_playground,
    only: ~w(css images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ex_playground_key",
    signing_salt: "ZofTHwd4",
    encryption_salt: "pUlSUEkb"

  plug :router, ExPlayground.Router
end
