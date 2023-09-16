defmodule NixfraDeployinator.PollServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(_) do
    send(self(), :poll)
    {:ok, []}
  end

  @impl true
  def handle_info(:poll, state) do
    NixfraDeployinator.Poller.run()
    schedule_poll()
    {:noreply, state}
  end

  def schedule_poll, do: Process.send_after(self(), :poll, 10_000)
end
