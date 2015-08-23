defmodule ExPlayground.CodeController do
  use ExPlayground.Web, :controller

  require Logger

  alias ExPlayground.CodeStreamer

  def run(conn, %{"code" => code}) do
    timeout = Application.get_env(:ex_playground, :code_runner)[:timeout]

    conn
    |> CodeStreamer.register_and_link_event_manager
    |> CodeStreamer.run_code(code, timeout)
    |> send_output
  end

  def share(conn, %{"code" => code}) do
    id = id_from_code(code)
    params = %{"id" => id, "content" => code}
    case ExPlayground.Snippet.find_or_create(params) do
      {:ok, _} -> conn |> text(id)
      {:error, _} -> conn |> text("Error while saving snippet")
    end
  end

  defp send_output(conn) do
    output =
      GenEvent.stream(conn.assigns[:event_manager_pid])
      |> Stream.filter(fn %{type: type} -> type in [:out, :err, :timeout] end)
      |> Enum.map(fn %{data: data} -> data end)

    conn
    |> text(output)
  end

  defp id_from_code(code) do
    :crypto.hash(:sha, code)
    |> Base.encode16(case: :lower)
    |> binary_part(0, 10)
  end
end
