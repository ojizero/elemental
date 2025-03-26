defmodule Elemental.Component do
  @moduledoc false

  @doc false
  defmacro __using__(_opts \\ []) do
    quote do
      use Phoenix.Component
      use PhoenixHTMLHelpers
    end
  end
end
