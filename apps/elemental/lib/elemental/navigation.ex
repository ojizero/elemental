defmodule Elemental.Navigation do
  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Navigation.Breadcrumbs
    end
  end
end
