defmodule Elemental.Component do
  @moduledoc false

  import Phoenix.Component, only: [assign_new: 3, update: 3]

  @doc false
  defmacro __using__(_opts \\ []) do
    quote do
      use Phoenix.Component, global_prefixes: ~w(elemental-)
      use PhoenixHTMLHelpers

      import Elemental.Component

      @doc false
      def classes(assigns),
        do: Elemental.Component.classes(__MODULE__, assigns)

      @doc false
      def component_classes(assigns), do: []

      defoverridable component_classes: 1
    end
  end

  @doc false
  def classes(_mod, %{"elemental-disable-styles": true} = _assigns),
    do: []

  def classes(_mod, %{rest: %{"elemental-disable-styles": true}} = _assigns),
    do: []

  def classes(mod, assigns),
    do: [mod.component_classes(assigns), class_attr(assigns)]

  defp class_attr(%{class: class}), do: class
  defp class_attr(%{rest: %{class: class}}), do: class

  @doc false
  # We treat "ghost" style as a color
  def daisy_colors,
    do: ~w(ghost neutral primary secondary accent info success warning error)

  @doc false
  def daisy_sizes, do: ~w(xs sm md lg xl)

  @doc false
  def elemental_styles(_assigns) do
    # TODO: given input decide whether to use component's class or nothing
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

  @doc false
  def maybe_randomized_name(assigns),
    do: assign_new(assigns, :name, &random/0)

  @doc false
  def random do
    4
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
  end
end
