defmodule Elemental.Actions do
  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Actions.Button
    end
  end
end
