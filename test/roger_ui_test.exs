defmodule RogerUiTest do
  use ExUnit.Case
  doctest RogerUi

  test "greets the world" do
    assert RogerUi.hello() == :world
  end
end
