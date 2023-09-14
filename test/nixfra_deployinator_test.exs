defmodule NixfraDeployinatorTest do
  use ExUnit.Case
  doctest NixfraDeployinator

  test "greets the world" do
    assert NixfraDeployinator.hello() == :world
  end
end
