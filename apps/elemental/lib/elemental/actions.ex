defmodule Elemental.Actions do
  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Actions.Button
      import Elemental.Actions.Swap
    end
  end
end
