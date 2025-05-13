defmodule Elemental.Actions do
  @moduledoc false

  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Actions.Button
      import Elemental.Actions.Modal
      import Elemental.Actions.Swap
    end
  end
end
