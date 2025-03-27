defmodule Elemental.Loader do
  use Elemental.Component

  attr :class,
       :any,
       default: nil,
       doc: "Define additional CSS classes for the spinner, e.g. change size."

  attr :screen_reader_text,
       :string,
       default: "Loading...",
       doc: "Set the hidden text intended for screen readers."

  @doc """
  > A basic spinner-wheel.

  Ref: https://tailwindcss.com/docs/animation#spin
  """
  def spinner(assigns) do
    ~H"""
    <div role="status">
      <svg
        class={["animate-spin -ml-1 mr-3 h-5 w-5", @class]}
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
      >
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
        </circle>
        <path
          class="opacity-75"
          fill="currentColor"
          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
        >
        </path>
      </svg>
      <span class="sr-only">{@screen_reader_text}</span>
    </div>
    """
  end
end
