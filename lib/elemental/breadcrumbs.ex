defmodule Elemental.Breadcrumbs do
  @moduledoc "> Exposing Daisy breadcrumbs as Phoenix components."

  use Elemental.Component

  attr :rest, :global

  slot :item, required: true, doc: "Specify the items in the breadcrumb."

  @doc "A wrapper around DaisyUI's breadcrumbs."
  def breadcrumbs(assigns) do
    assigns = prepend_class(assigns, "breadcrumbs")

    ~H"""
    <div {@rest}>
      <ul>
        <li :for={item <- @item}>{render_slot(item)}</li>
      </ul>
    </div>
    """
  end
end
