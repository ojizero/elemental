defmodule Elemental.Navigation do
  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Navigation.Breadcrumbs
      # TODO: may need to unimport default link
      # import Phoenix.Component, exclude: [link: 1]
      import Elemental.Navigation.Link
    end
  end
end
