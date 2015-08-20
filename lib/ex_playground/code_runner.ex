defmodule ExPlayground.CodeRunner do
  use GenServer

  require Logger

  @docker_args [
    "run",
    "-i",
    "--rm",
    "-c", "2",
    "-m", "80m",
    "--memory-swap=-1",
    "--net=none",
    "--cap-drop=all",
    "--privileged=false",
    "stevedomin/ex_playground"
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
      in: code,
      out: {:send, self()},
      err: {:send, self()},
    ]
    process = Porcelain.spawn("/usr/local/bin/docker", @docker_args, opts)
    timer_ref = :erlang.send_after(timeout, self(), {:timeout, process, timeout})
    new_state = %{state | timeout_timer_ref: timer_ref}
    {:noreply, new_state}
  end
  def handle_cast(request, state) do
    super(request, state)
  end

  def handle_info({_pid, :data, :out, data}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:data, :out, #{inspect(data)}}")
    GenEvent.notify(state[:event_manager_pid], {:out, data})
    {:noreply, state}
  end
  def handle_info({_pid, :data, :err, data}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:data, :err, #{inspect(data)}}")
    GenEvent.notify(state[:event_manager_pid], {:err, data})
    {:noreply, state}
  end
  def handle_info({_pid, :result, %Porcelain.Result{status: status}}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:result, #{status}}")
    :erlang.cancel_timer(state[:timeout_timer_ref])
    GenEvent.notify(state[:event_manager_pid], {:result, status})
    {:noreply, state}
  end
  def handle_info({:timeout, process, timeout}, state) do
    Logger.debug("#{__MODULE__}.handle_info/2 {:timeout, #{timeout}}")
    if Porcelain.Process.alive?(process) do
      GenEvent.notify(state[:event_manager_pid], {:timeout, timeout})
      Porcelain.Process.stop(process)
    end
    {:noreply, state}
  end
end

