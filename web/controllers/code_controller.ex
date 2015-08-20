defmodule ExPlayground.CodeController do
  use ExPlayground.Web, :controller

  require Logger

  def run(conn, %{"code" => code}) do
    timeout = Application.get_env(:ex_playground, :code_runner)[:timeout]

    conn
    |> register_and_link_event_manager
    |> run_code(code, timeout)
    |> send_output
  end

  def share(conn, %{"code" => code}) do
    id = id_from_code(code)
    params = %{
      "id" => id,
      "content" => code
    }
    case ExPlayground.Snippet.find_or_create(params) do
      {:ok, _} -> conn |> text(id)
      {:error, _} -> conn |> text("Error while saving snippet")
    end
  end

  def create_stream(conn, %{"code" => code}) do
    id = id_from_code(code)
    ExPlayground.CodeServer.put(id, code)
    conn |> text(id)
  end

  def stream(conn, %{"id" => id}) do
    code = ExPlayground.CodeServer.get(id)
    timeout = Application.get_env(:ex_playground, :code_runner)[:timeout]

    conn
    |> put_resp_header("x-accel-buffering", "no")
    |> put_resp_content_type("text/event-stream")
    |> send_chunked(200)
    |> register_and_link_event_manager
    |> run_code(code, timeout)
    |> stream
    |> close
  end

  defp register_and_link_event_manager(conn) do
    {:ok, pid} = GenEvent.start_link()

    conn
    |> assign(:event_manager_pid, pid)
  end

  defp run_code(conn, code, timeout) do
    {:ok, pid} = ExPlayground.CodeRunner.start_link(conn.assigns[:event_manager_pid])
    ExPlayground.CodeRunner.run(pid, code, timeout)
    conn
  end

  defp stream(conn) do
    GenEvent.stream(conn.assigns[:event_manager_pid])
    |> Stream.map(&format(&1))
    |> Stream.map(&to_chunk(&1))
    |> Stream.each(&chunk(conn, &1))
    |> Stream.run

    conn
  end

  def close(conn) do
    {:ok, conn} = conn |> chunk(to_chunk({:close, "CLOSE"}))
    conn
  end

  defp send_output(conn) do
    output =
      GenEvent.stream(conn.assigns[:event_manager_pid])
      |> Stream.map(&format(&1))
      |> Enum.map(fn({_type, data}) -> data end)

    conn
    |> text(output)
  end

  defp format({:out, data}), do: {:output, data}
  defp format({:result, 0}), do: {:result, "Program exited succesfully."}
  defp format({:result, status}), do: {:result, "Program exited with errors."}
  defp format({:timeout, timeout}), do: {:timeout, "Program timed out. Execution time is limited to #{timeout} ms."}

  defp to_chunk({event, data}) do
    "event: #{to_string(event)}\n" <> "data: #{data}\n\n"
  end

  defp id_from_code(code) do
    :crypto.hash(:sha, code)
    |> Base.encode16(case: :lower)
    |> binary_part(0, 10)
  end
end
