defmodule EscriptTestTest do
  use ExUnit.Case
  doctest EscriptTest

  test "greets the world" do
    assert EscriptTest.hello() == :world
  end
end
