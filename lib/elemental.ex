defmodule Elemental do
  def __using__(_opts \\ []) do
    quote do
      import Elemental.Breadcrumbs
      import Elemental.Dropdown
      import Elemental.Loading
      import Elemental.Select
      import Elemental.Table
      import Elemental.Tooltip
    end
  end
end
