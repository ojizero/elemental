defmodule Elemental do
  def __using__(_opts \\ []) do
    quote do
      import Elemental.Loader
      import Elemental.Tooltip
    end
  end
end
