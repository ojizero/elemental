defmodule Elemental.Navigation.Breadcrumbs do
  @moduledoc """
  > Exposing Daisy breadcrumbs as Phoenix components.

  ## Usage

      <.breadcrumbs>
        <:item>Foo</:item>
        <:item>Bar</:item>
        <:item><a href="example.org">Baz</a></:item>
      </.breadcrumbs>
  """

  use Elemental.Component

  attr :class, :any, required: false
  attr :rest, :global
  slot :item, required: true, doc: "Specify the items in the breadcrumb."

  @doc "A wrapper around DaisyUI's breadcrumbs."
  def breadcrumbs(assigns) do
    ~H"""
    <div class={classes(assigns)} {@rest}>
      <ul>
        <li :for={item <- @item}>{render_slot(item)}</li>
      </ul>
    </div>
    """
  end

  @doc false
  def component_classes(_assigns), do: "breadcrumbs"
end
