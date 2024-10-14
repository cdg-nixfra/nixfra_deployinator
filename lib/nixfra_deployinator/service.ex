defmodule NixfraDeployinator.Service do
  @moduledoc """
  Genserver to keep an eye on a running service. Essentially
  a single-process supervisor for an external erlexec-run
  process.
  """
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def stop() do
    GenServer.call(__MODULE__, :stop)
  end

  def start(path) do
    GenServer.call(__MODULE__, {:start, path})
  end

  ## Server side

  @impl true
  def init(_args) do
    {:ok, []}
  end

  @impl true
  def handle_call(:stop, _from, state) do
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:start, path}, _from, state) do
    {:reply, :ok, state}
  end
end
