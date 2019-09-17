defmodule ExWatsonTranslatorTest do
  use ExUnit.Case
  doctest ExWatsonTranslator

  test "greets the world" do
    assert ExWatsonTranslator.hello() == :world
  end
end
