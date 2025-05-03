defmodule Elemental.Navigation.Link do
  @moduledoc "Style Phoenix' `link/1` with Daisy's `link` class."

  use Elemental.Component

  alias Phoenix.Component

  attr :color, :string, values: daisy_colors(), doc: "The color of the link."
  attr :hover, :boolean, default: false, doc: "Enable showing the underline on hover only."
  attr :navigate, :string, doc: "See `Phoenix.Component.link/1`."
  attr :patch, :string, doc: "See `Phoenix.Component.link/1`."
  attr :href, :any, doc: "See `Phoenix.Component.link/1`."
  attr :replace, :boolean, default: false, doc: "See `Phoenix.Component.link/1`."
  attr :method, :string, default: "get", doc: "See `Phoenix.Component.link/1`."
  attr :csrf_token, :any, default: true, doc: "See `Phoenix.Component.link/1`."
  attr :class, :any, doc: false

  attr :rest,
       :global,
       include: ~w(download hreflang referrerpolicy rel target type),
       doc: "See `Phoenix.Component.link/1`."

  slot :inner_block,
    required: true,
    doc: """
    The content rendered inside of the `a` tag.
    """

  @doc """
  A passthrough component to `Phoenix.Component.link/1` that
  sets up the DaisyUI classes needed to style it.

  > By default Tailwind resets the style of links, this restores
  > the underline to links in the system.
  """
  def link(assigns) do
    # TODO: support disabling styles
    ~H"""
    <Component.link
      {assigns}
      class={[
        "link",
        @hover && "link-hover",
        assigns[:color] && "link-#{@color}",
        @class
      ]}
    >
      {render_slot(@inner_block)}
    </Component.link>
    """
  end
end
