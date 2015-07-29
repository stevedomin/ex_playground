defmodule ExPlayground.CodeController do
  use ExPlayground.Web, :controller

  require Logger

  def run(conn, %{"code" => code}) do
    id = ExPlayground.HexUtils.bin_to_hex(:crypto.hash(:sha, code))
    ExPlayground.CodeServer.put(id, code)
    conn |> text(id)
  end

  def share(conn, %{"code" => code}) do
    id = ExPlayground.HexUtils.bin_to_hex(:crypto.hash(:sha, code))

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
        send_chunk(conn, {"output", "Timing out after #{timeout} ms."})
        handle_output(conn, timeout)
      {_pid, :result, %Porcelain.Result{status: status}} ->
        Logger.debug("Status: #{status}")
        send_chunk(conn, {"output", "Program exited."})
    after
       timeout ->
        send_chunk(conn, {"timeout", "No output received after #{timeout} ms."})
    end
  end

  defp send_chunk(conn, {event, message}) do
    Logger.info("Send chunk: #{event} #{message}")
    {:ok, conn} = conn |> chunk("event: #{event}\n")
    {:ok, conn} = conn |> chunk("data: #{message}\n\n")
    conn
  end
end
