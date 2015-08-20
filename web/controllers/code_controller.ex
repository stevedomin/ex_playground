defmodule ExPlayground.CodeController do
  use ExPlayground.Web, :controller

  require Logger

  def run(conn, %{"code" => code}) do
    id = id_from_code(code)
    ExPlayground.CodeServer.put(id, code)
    conn |> text(id)
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
    |> listen

    # Send signal to close connection
    conn
    |> chunk(format_chunk("close", "CLOSE"))
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

  defp listen(conn) do
    GenEvent.stream(conn.assigns[:event_manager_pid])
    |> Stream.each(&chunk(conn, format(&1)))
    |> Stream.run
  end

  defp format({:out, data}) do
    Logger.debug "#{__MODULE__}.format {:out, #{inspect(data)}}"
    format_chunk("output", data)
  end
  defp format({:result, 0}) do
    Logger.debug "#{__MODULE__}.format {:result, 0}}"
    format_chunk("result", "Program exited succesfully.")
  end
  defp format({:result, status}) do
    Logger.debug "#{__MODULE__}.format {:result, #{inspect(status)}}"
    format_chunk("result", "Program exited with errors.")
  end
  defp format({:timeout, timeout}) do
    Logger.debug "#{__MODULE__}.format {:timeout, #{inspect(timeout)}}"
    format_chunk("timeout", "Program timed out. Execution time is limited to #{timeout} ms.")
  end

  defp format_chunk(event, data) do
    "event: #{event}\n" <> "data: #{data}\n\n"
  end

  defp id_from_code(code) do
    :crypto.hash(:sha, code)
    |> Base.encode16(case: :lower)
    |> binary_part(0, 10)
  end
end
