defmodule Elemental.Button do
  @moduledoc """
  > A simple button element with support for "links"

  ## Usage

      <.button type="submit">A button</.button>
      <.button href="example.org">A button looking link</.button>
      <.button navigate={~p"/live/navigate"}>A button looking link</.button>
      <.button patch={~p"/live/patch"}>A button looking link</.button>

  ## Caveats

  Underlying implementation from Phoenix doesn't pass role attribute
  so from an accessibility POV it may not be very ideal to use
  links disguised as buttons.
  """

  use Elemental.Component

  attr :color,
       :string,
       required: false,
       values: [
         "neutral",
         "primary",
         "secondary",
         "accent",
         "info",
         "success",
         "warning",
         "error",
         "ghost"
       ],
       doc: ""

  attr :size,
       :string,
       values: ~w(xs sm md lg xl),
       required: false,
       doc: ""

  attr :outline,
       :boolean,
       default: false,
       doc: ""

  attr :dashed,
       :boolean,
       default: false,
       doc: ""

  attr :soft,
       :boolean,
       default: false,
       doc: ""

  attr :wide,
       :boolean,
       default: false,
       doc: ""

  attr :shape,
       :string,
       values: ~w(square circle),
       required: false,
       doc: ""

  attr :rest, :global

  slot :inner_block, required: true

  attr :href,
       :string,
       required: false,
       doc: """
       Create a traditional browser navigation link displayed as a button.

       > Underlying element will use `Phoenix.Component.link/1` if defined.
       """

  attr :navigate,
       :string,
       required: false,
       doc: """
       Create a live navigation link displayed as a button.

       > Underlying element will use `Phoenix.Component.link/1` if defined.
       """

  attr :patch,
       :string,
       required: false,
       doc: """
       Create a live patch link displayed as a button.

       > Underlying element will use `Phoenix.Component.link/1` if defined.
       """

  attr :replace,
       :boolean,
       default: false,
       doc: """
       Only used with `:href`, `:navigate`, or `:patch`.

       > See `Phoenix.Component.link/1` for details.
       """

  attr :method,
       :string,
       default: "get",
       doc: """
       Only used with `:href`, `:navigate`, or `:patch`.

       > See `Phoenix.Component.link/1` for details.
       """

  attr :csrf_token,
       :boolean,
       default: true,
       doc: """
       Only used with `:href`, `:navigate`, or `:patch`.

       > See `Phoenix.Component.link/1` for details.
       """

  @doc """
  > The primary button component.

  This can also be used with links that require to appear as buttons
  by delegating over to `Phoenix.Component.link/1` while retaining
  it's general style.
  """
  def button(assigns)

  def button(%{href: _href} = assigns) do
    ~H"""
    <.link
      class={button_classes(assigns)}
      href={@href}
      replace={@replace}
      method={@method}
      csrf_token={@csrf_token}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  def button(%{navigate: _navigate} = assigns) do
    ~H"""
    <.link
      class={button_classes(assigns)}
      navigate={@navigate}
      replace={@replace}
      method={@method}
      csrf_token={@csrf_token}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  def button(%{patch: _patch} = assigns) do
    ~H"""
    <.link
      class={button_classes(assigns)}
      patch={@patch}
      replace={@replace}
      method={@method}
      csrf_token={@csrf_token}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  def button(assigns) do
    ~H"""
    <button class={button_classes(assigns)} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp button_classes(assigns) do
    [
      "btn",
      assigns[:color] && "btn-#{assigns.color}",
      assigns[:size] && "btn-#{assigns.size}",
      assigns[:outline] && "btn-outline",
      assigns[:dashed] && "btn-dash",
      assigns[:soft] && "btn-soft",
      assigns[:wide] && "btn-wide",
      assigns[:shape] && "btn-#{assigns.shape}"
    ]
  end
end
