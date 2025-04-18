defmodule Elemental.Feedback.Status do
  use Elemental.Component

  attr :size, :string, required: false, values: daisy_sizes(), doc: ""
  attr :color, :string, required: false, values: daisy_colors(), doc: ""
  attr :animate, :string, required: false, values: ~w(ping pulse), doc: ""

  def status(%{animate: "ping"} = assigns) do
    ~H"""
    <div class="inline-grid *:[grid-area:1/1]">
      <.status_span color={assigns[:color]} size={assigns[:size]} animate="ping" />
      <.status_span color={assigns[:color]} size={assigns[:size]} />
    </div>
    """
  end

  def status(assigns) do
    ~H"""
    <.status_span color={assigns[:color]} size={assigns[:size]} animate={assigns[:animate]} />
    """
  end

  attr :size, :string, values: daisy_sizes(), required: false
  attr :color, :string, values: daisy_colors(), required: false
  attr :animate, :string, values: ~w(ping pulse), required: false

  defp status_span(assigns) do
    ~H"""
    <span class={[
      "status",
      assigns[:size] && "status-#{@size}",
      assigns[:color] && "status-#{@color}",
      assigns[:animate] && "status-#{@animate}"
    ]}>
    </span>
    """
  end
end
