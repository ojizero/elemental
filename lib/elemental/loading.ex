defmodule Elemental.Loading do
  use Elemental.Component

  @daisy_loading_components ~w(spinner dots ring ball bars infinity)

  for component <- @daisy_loading_components do
    attr :color,
         :string,
         default: "primary",
         doc: "Choose which color the #{component} will be."

    attr :size,
         :string,
         values: ~w(xs sm md lg xl),
         default: "md",
         doc: "Choose which size the #{component} will be"

    attr :screen_reader_text,
         :string,
         default: "Loading...",
         doc: "Set the hidden text intended for screen readers."

    @doc "A wrapper around DaisyUI's #{component} loader."
    def unquote(:"#{component}")(assigns) do
      assigns = assign(assigns, :_daisy_component, unquote(component))

      ~H"""
      <div role="status" class={"loading loading-#{@_daisy_component} text-#{@color} loading-#{@size}"}>
        <span class="sr-only">{@screen_reader_text}</span>
      </div>
      """
    end
  end
end
