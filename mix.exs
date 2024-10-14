defmodule NixfraDeployinator.MixProject do
  use Mix.Project

  def project do
    [
      app: :nixfra_deployinator,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {NixfraDeployinator.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:erlexec, "~> 2.0"},
      {:ex_aws, "~> 2.5"},
      {:ex_aws_s3, "~> 2.4"},
      {:hackney, "~> 1.18"},
      {:libcluster, "~> 3.3"},
      {:libcluster_ec2, "~> 0.7.0"},
      {:poison, "~> 5.0"}
    ]
  end
end
