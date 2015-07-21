defmodule ExPlayground.CodeController do
  use ExPlayground.Web, :controller

  require Logger

  def run(conn, %{"code" => code}) do
    id = ExPlayground.HexUtils.bin_to_hex(:crypto.hash(:sha, code))
    ExPlayground.CodeServer.put(id, code)
    conn |> text(id)
  end

  def stream(conn, %{"id" => id}) do
    conn =
      conn
      |> put_resp_content_type("text/event-stream")
      |> send_chunked(200)

    code = ExPlayground.CodeServer.get(id)
    ExPlayground.CodeRunner.run(self(), code)
    handle_output(conn)

    # Send signal to close connection
    send_chunk(conn, {"close", "CLOSE"})
  end

  defp handle_output(conn) do
    receive do
      {_pid, :data, :out, data} ->
        prepared_data = data
          |> String.rstrip(?\n)
          |> String.split(~r/\n/)
        Logger.debug("Prepared data: #{prepared_data}")
        Enum.each(prepared_data, fn(line) ->
          send_chunk(conn, {"output", line})
        end)
        handle_output(conn)
      {_pid, :data, :err, data} ->
        Logger.info "Error: #{data}"
        handle_output(conn)
      {_pid, :result, %Porcelain.Result{status: status}} ->
        Logger.debug("Status: #{status}")
        send_chunk(conn, {"output", "Program exited."})
    after
      10_000 ->
        send_chunk(conn, {"timeout", "Timing out after 10 seconds"})
    end
  end

  defp send_chunk(conn, {event, message}) do
    Logger.info("Send chunk: #{event} #{message}")
    {:ok, conn} = conn |> chunk("event: #{event}\n")
    {:ok, conn} = conn |> chunk("data: #{message}\n\n")
    conn
  end
end
