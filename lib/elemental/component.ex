defmodule Elemental.Component do
  @moduledoc false

  import Phoenix.Component, only: [assign_new: 3, update: 3]

  @doc false
  defmacro __using__(_opts \\ []) do
    quote do
      use Phoenix.Component
      use PhoenixHTMLHelpers

      import Elemental.Component
    end
  end

  @doc false
  def prepend_class(assigns, class) do
    assigns
    |> assign_new(:rest, fn -> %{} end)
    |> update(:rest, fn
      %{class: classes} = rest when is_list(classes) -> %{rest | class: [class, classes]}
      %{class: classes} = rest when is_binary(classes) -> %{rest | class: "#{class} #{classes}"}
      rest -> Map.put(rest, :class, class)
    end)
  end
end
