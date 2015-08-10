# ExPlayground

Run Elixir code in your browser.

## Development

Make sure you have Elixir, PostgreSQL and Docker installed on your computer.

Initial steps:

```console
$ mix deps.get
$ npm install
$ bower install
$ mix do ecto.create, ecto.migrate
$ docker pull stevedomin/ex_playground:latest
```

Running it:

```console
$ mix phoenix.server
```

