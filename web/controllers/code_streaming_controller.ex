defmodule ExPlayground.CodeStreamingController do
  use ExPlayground.Web, :controller
  
  require Logger

  def create(conn, %{"code" => code}) do
    id = id_from_code(code)
    ExPlayground.CodeServer.put(id, code)
    conn |> text(id)
  end

  def stream(conn, %{"id" => id}) do
    conn =
      conn
      |> put_resp_header("x-accel-buffering", "no")
      |> put_resp_content_type("text/event-stream")
      |> send_chunked(200)

    timeout = Application.get_env(:ex_playground, :code_runner)[:timeout]
    code = ExPlayground.CodeServer.get(id)
    ExPlayground.CodeRunner.run(self(), code, timeout)
    handle_output(conn, timeout)

    # Send signal to close connection
    send_chunk(conn, {"close", "CLOSE"})
  end

  defp id_from_code(code) do
    :crypto.hash(:sha, code)
    |> Base.encode16(case: :lower)
    |> binary_part(0, 10)
  end

  defp handle_output(conn, timeout) do
    receive do
      {_pid, :data, :out, data} ->
        prepared_data = data
          |> String.rstrip(?\n)
          |> String.split(~r/\n/)
        Logger.debug("Prepared data: #{prepared_data}")
        Enum.each(prepared_data, fn(line) ->
          send_chunk(conn, {"output", line})
        end)
        handle_output(conn, timeout)
      {_pid, :data, :err, data} ->
        Logger.info("Error: #{data}")
        handle_output(conn, timeout)
      {_pid, :timeout} ->
        Logger.info("Timing out after #{timeout} ms.")
        send_chunk(conn, {"timeout", "Program timed out after #{timeout} ms."})
        handle_output(conn, timeout)
      {_pid, :result, %Porcelain.Result{status: status}} ->
        Logger.debug("Status: #{status}")
        statusMessage = if status == 0, do: "successfully", else: "with errors"
        send_chunk(conn, {"result", "Program exited #{statusMessage}."})
    after
       timeout ->
        send_chunk(conn, {"timeout", "Program timed out after #{timeout} ms. No output received."})
    end
  end

  defp send_chunk(conn, {event, message}) do
    Logger.info("Send chunk: #{event} #{message}")
    {:ok, conn} = conn |> chunk("event: #{event}\n")
    {:ok, conn} = conn |> chunk("data: #{message}\n\n")
    conn
  end

end
