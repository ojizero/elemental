defmodule Elemental.DataDisplay.Collapse do
  @moduledoc """
  A basic component to show or hide content. This is the underlying component
  used to build the `Elemental.DataDisplay.Accordion` component.

  ## Usage

      <.collapse>
        <:title>How do I create an account?</:title>
        Click the "Sign Up" button in the top right corner and follow the registration process.
      </.collapse>
  """

  use Elemental.Component

  alias Elemental.DataInput.Input

  attr :class,
       :any,
       default: nil,
       doc: "Additional classes to pass the collapse component."

  attr :indicator,
       :string,
       default: "none",
       values: ~w(none arrow plus),
       doc: "Specify which indicator to use to showcase the collapse is shown/hidden."

  attr :group,
       :string,
       default: nil,
       doc: """
       If given bounds the collapse to a hidden radio button with the name (i.e. grouped by)
       this value. This is useful if you wanna bind multiple collapses where only one
       is shown, e.g. `Elemental.DataDisplay.Accordion.accordion/1`.
       """

  attr :"click-to-close",
       :boolean,
       default: false,
       doc: """
       Enables closing the collapse by click instead of losing focus.

       Internally adds a hidden checkbox bound to the collapse's state.

       > Ignored if `group` attribute is passed.
       """

  slot :title,
    required: true,
    doc: "The title of the collapse section."

  slot :inner_block,
    required: true,
    doc: "The content to show or hide in the collapse."

  @doc "> The primary collapse component."
  def collapse(assigns) do
    assigns = normalize_assigns(assigns)

    ~H"""
    <div
      tabindex={if not @click_to_close, do: "0"}
      class={[
        "collapse border bg-base-100 border-base-300",
        @indicator != "none" && "collapse-#{@indicator}",
        @class
      ]}
    >
      <Input.radio :if={@group} name={@group} elemental-disable-styles />
      <Input.checkbox :if={@click_to_close} elemental-disable-styles />
      <div class="collapse-title">{render_slot(@title)}</div>
      <div class="collapse-content">{render_slot(@inner_block)}</div>
    </div>
    """
  end

  defp normalize_assigns(assigns) do
    assign_new(assigns, :click_to_close, fn
      %{group: nil, "click-to-close": click_to_close} -> click_to_close
      # If the collapse is placed in a group then it's always gonna close with focus
      _otherwise -> false
    end)
  end
end
