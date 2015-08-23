defmodule ExPlayground.CodeStreamer do
  alias ExPlayground.CodeRunner

  def register_and_link_event_manager(conn_or_socket) do
    {:ok, pid} = GenEvent.start_link()

    conn_or_socket
    |> conn_or_socket.__struct__.assign(:event_manager_pid, pid)
  end

  def run_code(conn_or_socket, code, timeout) do
    event_manager_pid = conn_or_socket.assigns[:event_manager_pid]
    {:ok, pid} = CodeRunner.start_link(event_manager_pid)
    CodeRunner.run(pid, code, timeout)
    conn_or_socket
  end
end
