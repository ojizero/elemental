defmodule Elemental do
  def __using__(_opts \\ []) do
    quote do
      import Elemental.Loader
    end
  end
end
