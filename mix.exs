defmodule Exlam.Mixfile do
  use Mix.Project

  def project do
    [app: app(),
     version: version(),
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  defp version, do: "0.0.2"

  defp app, do: :exlam

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :amqp_client, :partisan, :partisan_amqp_peer_service_manager, :lasp],
     mod: {Exlam,[node]}]
  end

  defp aliases do
    [
      build: [ &build_releases/1],
    ]
  end

  defp build_releases(_) do
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run([])
    Mix.Tasks.Archive.Build.run(["--output=#{app()}.ez"])
    File.rename("#{app()}.ez", "./archives/#{app()}.ez")
    File.rename("#{app()}-#{version()}.ez", "./archives/#{app()}-#{version()}.ez")
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:distillery, "~> 0.10"},
      {:lasp, git: "https://github.com/lasp-lang/lasp"},
      {:partisan_amqp_peer_service_manager, git: "https://github.com/lasp-lang/partisan_amqp_peer_service_manager", branch: "timing"},
      {:partisan, git: "https://github.com/lasp-lang/partisan", override: true, branch: "uuid"},
      {:rabbit_common, "~> 3.7.0-rc.2"},
      {:amqp_client, "3.7.0-rc.2"},
      {:recon, "~> 2.3"},
      {:ex_aws, git: "https://github.com/ex-aws/ex_aws"},
      {:poison, "~> 2.0"}
    ]
  end
end
