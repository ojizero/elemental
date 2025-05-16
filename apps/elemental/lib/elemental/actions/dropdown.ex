# TODO: migrate to popover (with polyfill for styling)
#       also should this instead be called "popover"
#       with dropdown being kept for the select?
defmodule Elemental.Actions.Dropdown do
  @moduledoc """
  A dropdown can open a menu, or anything really, once open.

  Useful for building menus, dropdown selects and more. For a complete example
  of it's usage you can check out `Elemental.DataInput.Select`.

  ## Usage

      <.dropdown>
        <:trigger>Open the dropdown</:trigger>
        The content to show when dropdown is open
      </.dropdown>

  ## Implementation details

  Currently this is implemented using `<details>`/`<summary>` HTML elements
  to ensure maximum compatibility with browsers and minimal overhead.

  This limits the possible content in trigger to only things allowed inside
  the `<summary>` HTML element for it to behave correctly.
  """

  use Elemental.Component

  alias Elemental.Actions.Button

  attr :align,
       :string,
       default: "start",
       values: ~w(start center end),
       doc: "Specify the alignment for the dropdown."

  attr :from,
       :string,
       default: "bottom",
       values: ~w(top bottom left right),
       doc: "Specify where the dropdown will appear from."

  attr :hover,
       :boolean,
       default: false,
       doc: "To enable opening the dropdown on hover."

  attr :open,
       :boolean,
       default: false,
       doc: "To open the dropdown immediately."

  slot :trigger,
    required: true,
    doc: "The trigger used to open the dropdown." do
    attr :class,
         :any,
         required: false,
         doc: "Additional classes to pass to the trigger."
  end

  slot :inner_block,
    required: true,
    doc: "The content dropdown to show once open."

  attr :id, :any, required: false, doc: false

  @doc "> The primary dropdown component."
  def dropdown(assigns) do
    assigns = assign_new(assigns, :id, &random/0)

    ~H"""
    <div>
      <Button.button
        id={@id}
        type="button"
        class="hidden"
        hidden
        elemental-disable-styles
        phx-click={
          JS.toggle_attribute({"open", "true"},
            to: "\##{Phoenix.HTML.css_escape("#{@id}__dropdown")}"
          )
        }
      >
      </Button.button>
      <details
        id={@id <> "__dropdown"}
        class={[
          "dropdown",
          "dropdown-#{@align}",
          "dropdown-#{@from}",
          @hover && "dropdown-hover",
          @open && "dropdown-open"
        ]}
        phx-click-away={JS.remove_attribute("open")}
      >
        <summary
          id={@id <> "__dropdown_trigger"}
          class={[
            "list-none",
            trigger_class(@trigger)
          ]}
        >
          {render_slot(@trigger)}
        </summary>
        <div id={@id <> "__dropdown_content"} class="dropdown-content shadow-sm">
          {render_slot(@inner_block)}
        </div>
      </details>
    </div>
    """
  end

  defp trigger_class([%{class: class}]), do: class
  defp trigger_class([_trigger]), do: nil
end
