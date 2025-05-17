defmodule Elemental.DataDisplay do
  @moduledoc false

  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.DataDisplay.Accordion
      import Elemental.DataDisplay.Avatar
      import Elemental.DataDisplay.Collapse
      import Elemental.DataDisplay.Status
      import Elemental.DataDisplay.Table
    end
  end
end
