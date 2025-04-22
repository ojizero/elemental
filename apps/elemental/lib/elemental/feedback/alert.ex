defmodule Elemental.Feedback.Alert do
  @moduledoc """

  """

  use Elemental.Component

  attr :type,
       :string,
       values: ~w(info success warning error),
       required: false,
       doc: "The type of this alert."

  attr :outline,
       :boolean,
       default: false,
       doc: "Render the alert in an outline style."

  attr :dash,
       :boolean,
       default: false,
       doc: "Render the alert in dash style."

  attr :soft,
       :boolean,
       default: false,
       doc: "Render the alert in soft style."

  attr :direction, :string,
    values: ~w(vertical horizontal),
    required: false,
    doc: """
    The layout's direction, vertical which is better for mobile and
    horizontal which is better for desktop.
    """

  attr :rest, :global
  slot :inner_block, required: true, doc: ""

  @doc """

  """
  def alert(assigns) do
    ~H"""
    <div
      role="alert"
      class={[
        "alert",
        assigns[:type] && "alert-#{@type}",
        @outline && "alert-outline",
        @dash && "alert-dash",
        @soft && "alert-soft",
        assigns[:direction] && "alert-#{@direction}"
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
