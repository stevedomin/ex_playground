defmodule ExPlayground.CodeChannel do
  use Phoenix.Channel

  alias ExPlayground.CodeStreamer

  def join("code:stream", auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("run", %{"code" => code}, socket) do
    timeout = Application.get_env(:ex_playground, :code_runner)[:timeout]

    socket
    |> CodeStreamer.register_and_link_event_manager
    |> CodeStreamer.run_code(code, timeout)
    |> stream

    {:noreply, socket}
  end

  defp stream(socket) do
    GenEvent.stream(socket.assigns[:event_manager_pid])
    |> Stream.each(&push(socket, "output", &1))
    |> Stream.run
  end
end
