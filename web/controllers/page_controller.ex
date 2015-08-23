defmodule ExPlayground.PageController do
  use ExPlayground.Web, :controller

  def index(conn, %{"id" => id}) do
    snippet = ExPlayground.Repo.get(ExPlayground.Snippet, id)
    render conn, "index.html", snippet: snippet
  end

  def index(conn, _params) do
    snippet = %ExPlayground.Snippet{
      id: "",
      content: "defmodule Hello do\n  def world do\n    IO.puts(\"hello, world\")\n  end\nend\n\nHello.world"
    }
    render conn, "index.html", snippet: snippet
  end
end
