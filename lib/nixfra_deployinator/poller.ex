defmodule NixfraDeployinator.Poller do
  @state_dir "/var/run/nxd_deployinator"
  @state_file Path.join(@state_dir, "state.term")

  defmodule State do
    defstruct [:version]
  end

  def run() do
    state = load_state()

    poll_version = load_s3()

    if poll_version != state.version do
      NixfraDeployinator.Deployer.run_upgrade(
        state.version,
        poll_version
      )

      write_state(%State{state | version: poll_version})
    end
  end

  def load_state() do
    if File.exists?(@state_file) do
      @state_file
      |> File.read!()
      |> :erlang.binary_to_term()
    else
      File.mkdir_p!(@state_dir)
      nil
    end
  end

  def write_state(state) do
    state
    |> :erlang.term_to_binary()
    |> then(&File.write!(@state_file, &1))
  end

  def load_s3() do
    {:ok, result} =
      ExAws.S3.get_object(
        NixfraDeployinator.Application.bucket(),
        NixfraDeployinator.Application.appname()
      )
      |> ExAws.request!()

    result
  end
end
