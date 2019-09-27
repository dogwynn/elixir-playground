defmodule PgTest do
  use ExUnit.Case
  doctest Pg

  test "greets the world" do
    assert Pg.hello() == :world
  end
end
