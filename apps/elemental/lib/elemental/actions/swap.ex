defmodule Elemental.Actions.Swap do
  @moduledoc """
  > A simple swap component.

  Allows for alternative between two HTML elements (or subtrees)
  when clicked. Comprised of an underlying checkbox to control
  the state of the which element to show.

  ## Usage

      <.swap>
        <:on>ON</:on>
        <:off>OFF</:off>
      </.swap>
  """

  use Elemental.Component

  alias Elemental.DataInput.Input

  attr :animate,
       :string,
       default: "default",
       values: ~w(default rotate flip),
       doc: "Control the animation to use when doing the swap."

  slot :on,
    required: true,
    doc: "The required `on` state content."

  slot :off,
    required: true,
    doc: """
    The required `off` state content.

    If `indeterminate` slot is not given this will be the default
    state the component starts in.
    """

  slot :indeterminate,
    required: false,
    doc: """
    An optional `indeterminate` state content.

    If given the inner checkbox be immediately set to `indeterminate`
    once it first mounts.
    """

  attr :id, :any, doc: false
  attr :rest, :global, doc: false

  @doc "> The primary swap component."
  def swap(assigns) do
    assigns =
      update(assigns, :animate, fn
        "default" -> nil
        otherwise -> otherwise
      end)

    ~H"""
    <label
      id={"#{@id}-label"}
      class={[
        "swap",
        assigns[:animate] && "swap-#{@animate}"
      ]}
    >
      <Input.checkbox
        id={@id}
        hidden
        phx-hook={
          if @indeterminate != [],
            do: "ElementalIndeterminateCheckbox"
        }
        {@rest}
      />
      <div class="swap-on">
        {render_slot(@on)}
      </div>
      <div class="swap-off">
        {render_slot(@off)}
      </div>
      <div :if={@indeterminate != []} class="swap-indeterminate">
        {render_slot(@indeterminate)}
      </div>
    </label>
    """
  end
end
