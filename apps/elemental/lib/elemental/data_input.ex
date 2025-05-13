defmodule Elemental.DataInput do
  @moduledoc false

  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.DataInput.Field
      import Elemental.DataInput.Input
      import Elemental.DataInput.Select
      import Elemental.DataInput.Dropdown
    end
  end
end
