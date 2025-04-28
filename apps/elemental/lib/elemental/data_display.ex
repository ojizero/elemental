defmodule Elemental.DataDisplay do
  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.DataDisplay.Status
      import Elemental.DataDisplay.Table
    end
  end
end
