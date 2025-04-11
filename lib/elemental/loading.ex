defmodule Elemental.Loading do
  @moduledoc """
  > Exposing Daisy loaders as Phoenix components.

  ## Usage

      <.loading />
  """

  use Elemental.Component

  attr :type,
       :string,
       values: ~w(spinner dots ring ball bars infinity),
       default: "spinner",
       doc: "Specify the type of loader to use."

  attr :color,
       :string,
       default: "primary",
       doc: "Choose which color the loading component will be."

  attr :size,
       :string,
       values: ~w(xs sm md lg xl),
       default: "md",
       doc: "Choose which size the loading component will be"

  attr :screen_reader_text,
       :string,
       default: "Loading...",
       doc: "Set the hidden text intended for screen readers."

  @doc "A wrapper around all DaisyUI's loading components."
  def loading(assigns) do
    ~H"""
    <div
      role="status"
      class={[
        "loading",
        "loading-#{@type}",
        "loading-#{@size}",
        "text-#{@color}"
      ]}
    >
      <span class="sr-only">{@screen_reader_text}</span>
    </div>
    """
  end
end
