defmodule Elemental.Component do
  @moduledoc false

  import Phoenix.Component, only: [assign_new: 3, update: 3]

  alias Phoenix.LiveView.JS

  @doc false
  defmacro __using__(which) do
    which = if is_atom(which), do: which, else: :component
    apply(__MODULE__, which, [])
  end

  @doc false
  def component do
    quote do
      use Phoenix.Component, global_prefixes: ~w(elemental-)

      unquote(helpers())
    end
  end

  @doc false
  def live do
    quote do
      use Phoenix.LiveComponent, global_prefixes: ~w(elemental-)

      unquote(helpers())
    end
  end

  defp helpers do
    quote do
      use PhoenixHTMLHelpers

      import Elemental.Component, except: [component: 0, live: 0]

      alias Phoenix.LiveView.JS

      @doc false
      def classes(assigns),
        do: Elemental.Component.classes(__MODULE__, assigns)

      @doc false
      def component_classes(assigns), do: []

      @doc false
      def empty_classes, do: []

      defoverridable component_classes: 1, empty_classes: 0
    end
  end

  @doc false
  # We treat "ghost" style as a color
  # TODO: having ghost here isn't super valid in hind sight
  def daisy_colors, do: ~w(ghost neutral primary secondary accent info success warning error)

  @doc false
  def daisy_content_colors do
    ~w(neutral-content primary-content secondary-content accent-content info-content success-content warning-content error-content)
  end

  @doc false
  def daisy_sizes, do: ~w(xs sm md lg xl)

  @doc false
  def classes(mod, %{"elemental-disable-styles": true} = assigns),
    do: [mod.empty_classes(), class_attr(assigns)]

  def classes(mod, %{rest: %{"elemental-disable-styles": true}} = assigns),
    do: [mod.empty_classes(), class_attr(assigns)]

  def classes(mod, assigns),
    do: [mod.component_classes(assigns), class_attr(assigns)]

  defp class_attr(%{class: class}), do: class
  defp class_attr(%{rest: %{class: class}}), do: class
  defp class_attr(_assigns), do: []

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

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      # Define display as inherit to avoid breaking original
      # styles of components when hiding/showing them.
      display: "inherit",
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end
end
