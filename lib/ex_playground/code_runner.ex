defmodule ExPlayground.CodeRunner do
  use GenEvent

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def run(pid, code) do
    GenServer.cast(__MODULE__, {:run, pid, code})
  end

  # Server (callbacks)

  def handle_cast({:run, pid, code}, _state) do
    args = ["run", "-i", "--rm", "stevedomin/ex_playground"]
    opts = [
      in: code,
      out: {:send, pid},
      err: :out,
    ]
    Porcelain.spawn("/usr/local/bin/docker", args, opts)
    {:noreply, []}
  end
end
