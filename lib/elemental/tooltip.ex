defmodule Elemental.Tooltip do
  @moduledoc """
  Provides a CSS only tooltip implementation, this does not require
  JavaScript on any additional libraries beyond simply loading
  Elemental's CSS properly.

  ## Usage

  The simplest form to use the tooltip is adding a `tooltip` attribute
  to any plain HTML element, this will enable a tooltip on hover on
  the assigned attribute.

      <div tooltip="Some informational message">
        Some text
      </div>

  The tooltip can be configured by passing the `tooltip-props` attribute
  with available options passed in it.

  Available options control the positioning and the theme of the tooltip.

  ### Positioning

  Allowed positions are `top`, `bottom`, `left`, and `right`. If not passed
  the tooltip will be placed in the bottom.

      <div tooltip="Some tip shown on the top of the element" tooltip-props="top">
        Some text
      </div>

  ### Theming

  By default the tooltip will respect the user theme, however it can be specified with
  values of `light` or `dark`.

      <div tooltip="Some tip in light mode" tooltip-props="light">
        Some text
      </div>

      <div tooltip="Some tip in dark mode" tooltip-props="dark">
        Some text
      </div>

  ## Phoenix Component

  An alternative to this would be the usage of the `tooltip/1` component,
  which exposes a Phoenix functional component API for working with
  tooltips.

  Ideally you should prefer using the functional component since in addition
  to providing an Elixir friendly API it also sets ARIA role and handles
  screen readers as part of its implementation.
  """

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

  attr :theme,
       :string,
       values: ["user-theme", "light", "dark"],
       default: "user-theme",
       doc: "The theme to use for the tooltip."

  slot :inner_block, required: true

  @doc """
  Provides a Phoenix functional component wrapping the tooltip CSS based component.

  Wrap a given inner slot with a `div` defining the tooltip attribute, and maps
  the given attributes to useful tooltip properties.
  """
  def tooltip(assigns) do
    ~H"""
    <div tooltip={@tip} tooltip-props={"#{@position} #{@theme}"}>
      <span role="tooltip" class="sr-only">{@tip}</span>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
