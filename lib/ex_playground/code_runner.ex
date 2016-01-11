defmodule ExPlayground.CodeRunner do
  use GenServer

  require Logger

  @docker_args [
    "run",
    "-i",
    "--rm",
    "-m", "80m",
    "--memory-swap=-1",
    "--net=none",
    "--cap-drop=all",
    "--privileged=false",
    Application.get_env(:ex_playground, :docker)[:image]
  ]

  # Client

  def start_link(event_manager_pid) do
    default = %{
      event_manager_pid: event_manager_pid,
      timeout_timer_ref: nil
    }
    GenServer.start_link(__MODULE__, default)
  end

  def run(pid, code, timeout) do
    GenServer.cast(pid, {:run, code, timeout})
  end

  # Server (callbacks)

  def handle_cast({:run, code, timeout}, state) do
    opts = [
      out: {:send, self()},
      err: {:send, self()},
    ]
    docker_bin = Application.get_env(:ex_playground, :docker)[:bin]

    process = Porcelain.spawn(docker_bin, @docker_args ++ [code], opts)

    timer_ref = :erlang.send_after(timeout, self(), {:timeout, process, timeout})
    new_state = %{state | timeout_timer_ref: timer_ref}
    {:noreply, new_state}
  end
  def handle_cast(request, state) do
    super(request, state)
  end

  def handle_info({_pid, :data, :out, data}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:data, :out, #{inspect(data)}}")
    GenEvent.notify(state[:event_manager_pid], %{type: :out, data: data})
    {:noreply, state}
  end
  def handle_info({_pid, :data, :err, data}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:data, :err, #{inspect(data)}}")
    GenEvent.notify(state[:event_manager_pid], %{type: :err, data: data})
    {:noreply, state}
  end
  def handle_info({_pid, :result, %Porcelain.Result{status: status}}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:result, #{status}}")
    :erlang.cancel_timer(state[:timeout_timer_ref])
    event_manager_pid = state[:event_manager_pid]
    GenEvent.notify(event_manager_pid, %{type: :result, status: status})
    GenEvent.stop(event_manager_pid)
    {:noreply, state}
  end
  def handle_info({:timeout, process, timeout}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:timeout, #{timeout}}")
    if Porcelain.Process.alive?(process) do
      GenEvent.notify(state[:event_manager_pid], %{type: :timeout, timeout: timeout})
      Porcelain.Process.stop(process)
    end
    {:noreply, state}
  end
end

