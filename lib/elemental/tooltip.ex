defmodule Elemental.Tooltip do
  @moduledoc "> Exposing Daisy tooltips as Phoenix components."

  use Elemental.Component

  attr :tip,
       :string,
       required: true,
       doc: "The text of the tooltip to display."

  attr :position,
       :string,
       values: ["top", "bottom", "left", "right"],
       default: "top",
       doc: "The positioning of the tooltip."

  attr :color,
       :string,
       default: "primary",
       doc: "The color to use for the tooltip."

  attr :open,
       :boolean,
       default: false,
       doc: "Where to have the tooltip open immediately."

  slot :inner_block, required: true

  @doc """
  Provides a Phoenix functional component wrapping the tooltip CSS based component.

  Wrap a given inner slot with a `div` defining the tooltip attribute, and maps
  the given attributes to useful tooltip properties.
  """
  def tooltip(assigns) do
    ~H"""
    <div
      class={[
        "tooltip",
        "tooltip-#{@position} tooltip-#{@color}",
        @open && "tooltip-open"
      ]}
      data-tip={@tip}
    >
      <span role="tooltip" class="sr-only">{@tip}</span>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
