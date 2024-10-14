defmodule NixfraDeployinator.Deployer do

  def run_upgrade(from_version, to_version) do
    fetch_code(to_version)
    :global.trans({:nixfra_deployinator_migrate, self()}, fn ->
      run_migration(to_version)
    end)
    :global.trans({:nixfra_deployinator_deploy, self()}, fn ->
      start_masquerading()
      stop_service(from_version)
      start_service(to_version)
      wait_for_healthy()
      stop_masquerading()
    end)
  end

  def fetch_code(to_version) do
    # TODO nix-copy-closure? Or substitute server?
  end

  def run_migration(to_version) do
    migration_script = Path.join(["nix", "store", to_version, "bin", "migrate"])
    run(migration_script)
  end

  def start_masquerading() do
    masquerade("-A")
  end

  def stop_service(from_version) do
    # TODO systemd? new unit? We do supervision?
    # Most likely: we do supervision
  end

  def start_service(to_version) do
  end

  def wait_for_healthy() do
  end

  def stop_masquerading() do
    masquerade("-D")
  end

  defp masquerade(arg) do
    ip = random_other_node_ip()
    run("iptables -t nat #{arg} PREROUTING -p tcp --dport 4000 -j DNAT --to-destination #{ip}:4000")
    run("iptables -t nat #{arg} POSTROUTING -j MASQUERADE")
  end

  defp run(cmd) do
    {_, 0} = System.cmd("bash", ["-c", cmd])
  end

  defp random_other_node_ip do
    {:ok, info} =
      :erlang.nodes()
      |> Enum.random()
      |> :net_kernel.node_info()
    {:net_address, {_, ip}, _, :tcp, :inet} = info[:address]
    :inet.ntoa(ip)
  end
end
