defmodule Elemental.Select do
  use Elemental.Component

  attr :prompt,
       :string,
       default: nil,
       doc: "An optional prompt to display for the select field."

  attr :rest, :global

  slot :option, doc: "The options available for the select." do
    attr :value, :any
  end

  def select(assigns) do
    assigns = prepend_class(assigns, "select")

    ~H"""
    <select {@rest}>
      <option :if={@prompt} value="" disabled selected>{@prompt}</option>
      <option :for={option <- @option} value={option[:value]}>{render_slot(option)}</option>
    </select>
    """
  end
end
