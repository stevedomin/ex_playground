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

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def run(pid, code, timeout) do
    GenServer.cast(__MODULE__, {:run, pid, code, timeout})
  end

  # Server (callbacks)

  def handle_cast({:run, pid, code, timeout}, state) do
    opts = [
      in: code,
      out: {:send, pid},
      err: {:send, pid},
    ]
    process = Porcelain.spawn("/usr/local/bin/docker", @docker_args, opts)
    case :timer.apply_after(timeout, __MODULE__, :stop_process, [process, pid]) do
      {:ok, tref} -> Logger.debug("tref #{inspect tref}")
      {:error, reason} ->
        Logger.error("apply_after failed, stopping Porcelain process now. Reason: #{reason}")
        stop_process(process, pid)
    end
    {:noreply, state}
  end

  def stop_process(process, pid) do
    send(pid, {self(), :timeout})
    Porcelain.Process.stop(process)
  end
end

