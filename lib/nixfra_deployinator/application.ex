defmodule NixfraDeployinator.Application do
  use Application

  @impl true
  def start(_, _) do
    configure()

    children = []

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def configure do
    Application.put_env(:libcluster, :topologies,
      tags: [
        strategy: Elixir.ClusterEC2.Strategy.Tags,
        config: [
          ec2_tagname: "nixfra_cluster_id",
          ec2_tagvalue: appname(),
          app_prefix: appname(),
          ip_type: :private,
          polling_interval: 10_000
        ]
      ],
      show_debug: false
    )
  end

  def appname() do
    System.get_env("NXD_APP_NAME")
  end

  def bucket() do
    System.get_env("NXD_BUCKET", "nixfra-infra-tfstate")
  end
end
