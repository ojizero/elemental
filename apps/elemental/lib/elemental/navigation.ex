defmodule Elemental.Navigation do
  @moduledoc false

  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Navigation.Breadcrumbs
      import Elemental.Navigation.Dock
      # TODO: may need to unimport default link
      # import Phoenix.Component, exclude: [link: 1]
      import Elemental.Navigation.Link
      import Elemental.Navigation.Tabs
    end
  end
end
