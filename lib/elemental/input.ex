defmodule Elemental.Input do
  @moduledoc """
  > An abstraction on top of HTML's input element.

  This only concerns itself with being a building block core component and
  directly abstracts `input` HTML element. For more sophisticated usage
  you may want to look at `Elemental.Field` which provides a more
  complete complex component for easier to use/build forms.

  ## Usage

      <.input />
      <.input name="some-text" />
      <.input type="checkbox" name="my-checkbox" />

  Additionally shorthand functions are provided for checkbox and radio

      <.radio />
      <.checkbox />
  """

  use Elemental.Component

  require Logger

  attr :type,
       :string,
       default: "text",
       values: ~w(checkbox color date datetime-local email file hidden image month
                  number password radio range search tel text time url week),
       doc: """
       > The input component's type.

       While we support `button`, `reset`, and `submit` types, those are
       more for completeness and are not recommended for use per MDN
       recommendations, prefer the use `Elemental.Button` instead.
       """

  attr :name,
       :string,
       required: false,
       doc: "The name of the input, if not given a random value is selected."

  attr :value,
       :string,
       default: nil,
       doc: "The value of the input."

  attr :color,
       :string,
       required: false,
       values: daisy_colors(),
       doc: "The input's color."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "The input's size."

  attr :class,
       :string,
       default: nil,
       doc: "Additional CSS classes to pass to the input."

  attr :rest,
       :global,
       doc: "Pass arbitrary attributes over to the input"

  @doc """
  > A simple abstraction on top of basic HTML input.

  This is a super simplistic input component intended to be used
  as a building block for other Elemental components to use.

  For complex use-cases with forms and other variants of inputs
  you may want to visit `Elemental.Field.field/1` component
  which provides additional features tailored for forms.

  ## Type related notes

  Types of `button`, `reset`, and `submit` are omitted from supported
  types, for button usages use `Elemental.Button.button/1` instead.

  For live file uploads, see `Phoenix.Component.live_file_input/1`
  instead of the `file` type.
  """
  def input(assigns) do
    assigns =
      assigns
      |> normalize()
      |> maybe_randomize_name()

    ~H"""
    <input type={@type} class={[@component, @class]} name={@name} value={@value} {@rest} />
    """
  end

  attr :name,
       :string,
       required: false,
       doc: "The name of the checkbox, if not given a random value is selected."

  attr :value,
       :string,
       default: nil,
       doc: "The value of the checkbox."

  attr :color,
       :string,
       required: false,
       values: daisy_colors(),
       doc: "The checkbox's color."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "The checkbox's size."

  attr :class,
       :string,
       default: nil,
       doc: "Additional CSS classes to pass to the checkbox."

  attr :rest,
       :global,
       doc: "Pass arbitrary attributes over to the checkbox"

  @doc "Shorthand for `<.input type=\"checkbox\" />`"
  def checkbox(assigns) do
    assigns
    |> assign(:type, "checkbox")
    |> input()
  end

  attr :name,
       :string,
       required: false,
       doc: "The name of the input, if not given a random value is selected."

  attr :value,
       :string,
       default: nil,
       doc: "The value of the checkbox."

  attr :color,
       :string,
       required: false,
       values: daisy_colors(),
       doc: "The checkbox's color."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "The checkbox's size."

  attr :class,
       :string,
       default: nil,
       doc: "Additional CSS classes to pass to the checkbox."

  attr :rest,
       :global,
       doc: "Pass arbitrary attributes over to the checkbox."

  @doc "Shorthand for `<.input type=\"radio\" />`"
  def radio(assigns) do
    assigns
    |> assign(:type, "radio")
    |> input()
  end

  defp normalize(assigns) do
    assign(assigns, :component, component(assigns))
  end

  defp component(%{type: "checkbox"} = assigns),
    do: ["checkbox" | class_modifiers("checkbox", assigns)]

  defp component(%{type: "file"} = assigns),
    do: ["file-input" | class_modifiers("file-input", assigns)]

  # Is it redundant and bad to return the class `hidden` here?
  defp component(%{type: "hidden"} = _assigns),
    do: ["hidden"]

  defp component(%{type: "range"} = assigns),
    do: ["range", class_modifiers("range", assigns)]

  defp component(%{type: "radio"} = assigns),
    do: ["radio" | class_modifiers("radio", assigns)]

  # Left blank as Daisy has no styles for it
  defp component(%{type: type} = _assigns)
       when type in ~w(color image hidden),
       do: []

  defp component(assigns),
    do: ["input" | class_modifiers("input", assigns)]

  defp class_modifiers(class, assigns) do
    [
      assigns[:color] && "#{class}-#{assigns.color}",
      assigns[:size] && "#{class}-#{assigns.size}"
    ]
  end
end
