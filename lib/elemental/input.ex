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

  @textual_types_value_documentation """
  - `checkbox` - the data to submit if checked, arbitrary string.
  - `color` - always a string which contains a 7-character string specifying
    an RGB color in hexadecimal format. While you can input the color in
    either upper- or lower-case, it will be stored in lower-case form.
    The value is never in any other form, and is never empty.
  - `email` - the email string;
      1. An empty string ("") indicating that the user did not enter a value
         or that the value was removed.
      1. A single properly-formed email address. This doesn't necessarily mean
         the email address exists, but it is at least formatted correctly.
         This means `username@domain` or `username@domain.tld`.
      1. If `multiple` is enabled the value can be a list of properly-formed
         comma-separated email addresses. Any trailing and leading
         whitespace is removed from each address in the list.

  """

  # Types that support min/max.
  @ordinal_types_value_documentation """
  - `date` - a possible date string in the format `yyyy-mm-dd`.
  - `datetime-local` - a valid datetime string that follows the
    format `YYYY-MM-DDTHH:mm`.
  - `month` - a valid string in `yyyy-MM` format.
  - `number` - a valid number.
  - `range` - a valid number.
  - `time` - a valid time in `HH:mm` format.
  - `week` - a valid week in `YYYY-W<week-number>` format.
  """

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
       doc: """
       The value of the input.

       ## Value per type

       #{@textual_types_value_documentation}
       #{@ordinal_types_value_documentation}
       """

  attr :color,
       :string,
       required: false,
       values: daisy_colors(),
       doc: "The input's color."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "The input's size class to use."

  attr :class,
       :string,
       default: nil,
       doc: "Additional CSS classes to pass to the input."

  attr :rest,
       :global,
       doc: "Pass arbitrary attributes over to the input"

  # Additional attributes for each specific input type
  # ignored for types that don't use it.

  attr :checked,
       :boolean,
       default: nil,
       doc: "The checked flag for checkboxes and radios."

  attr :list,
       :string,
       default: nil,
       doc: """
       The values of the list attribute is the `id` of a `<datalist>`
       element located in the same document.
       """

  attr :max,
       :string,
       default: nil,
       doc: """
       The maximum value allowed for types that support it.

       If both the `max` and `min` attributes are set, this value must
       greater than or equal to the `min` attribute.

       ## Value per type

       #{@ordinal_types_value_documentation}

       > Invalid values imply no `max` value.
       """

  attr :maxlength,
       :string,
       default: nil,
       doc: """
       The maximum string length (measured in UTF-16 code units) that the user can
       enter into the input. This must be an integer value of 0 or higher. If no
       `maxlength` is specified, or an invalid value is specified, the input
       has no maximum length. This value must also be greater than or equal
       to the value of `minlength`.
       """

  attr :min,
       :string,
       default: nil,
       doc: """
       The maximum value allowed for types that support it.

       If both the `max` and `min` attributes are set, this value must
       less than or equal to the `min` attribute.

       ## Value per type

       #{@ordinal_types_value_documentation}

       > Invalid values imply no `min` value.
       """

  attr :minlength,
       :string,
       default: nil,
       doc: """
       The minimum string length (measured in UTF-16 code units) that the user can
       enter into the input. This must be a non-negative integer value smaller
       than or equal to the value specified by `maxlength`. If no `minlength`
       is specified, or an invalid value is specified, the input has no
       minimum length.
       """

  attr :multiple,
       :boolean,
       default: nil,
       doc: """
       A Boolean attribute which, if present, indicates that the user can enter a
       list of multiple values, separated by commas and, optionally, whitespace
       characters.
       """

  attr :pattern,
       :string,
       default: nil,
       doc: """
       A regular expression that the input's value must match for the value to pass
       constraint validation. It must be a valid JavaScript regular expression.
       """

  attr :placeholder,
       :string,
       default: nil,
       doc: """
       A string that provides a brief hint to the user as to what kind of
       information is expected in the field.

       > The text _must_ not include carriage returns or line feeds.
       """

  attr :readonly,
       :boolean,
       default: nil,
       doc: "If present, means this field cannot be edited by the user."

  attr :step,
       :string,
       default: nil,
       doc: """
       The step value which specifies the number for the granularity
       of the step or the special value `any`, allowed for types
       that support it.

       ## Values per type

       - `date` - given in days; and is treated as a number of milliseconds
         equal to 86,400,000 times the `step` value (the underlying numeric
         value is in milliseconds). The default value of `step` is 1,
         indicating 1 day.
       - `datetime-local` - given in seconds, with a scaling factor of 1000
         (since the underlying numeric value is in milliseconds). The
         default value of `step` is 60, indicating 60 seconds (or
         1 minute, or 60,000 milliseconds).
       - `month` - given in months, with a scaling factor of 1 (since the underlying
         numeric value is also in months). The default value of step is 1 month.
       - `number` - a valid number; the default stepping value for number
         inputs is 1, allowing only integers to be entered—_unless_ the
         stepping base is not an integer.
       - `range` - a valid number; the default stepping value for number
         inputs is 1, allowing only integers to be entered—_unless_ the
         stepping base is not an integer.
       - `time` - given in seconds, with a scaling factor of 1000 (since
         the underlying numeric value is in milliseconds). The default
         value of step is 60, indicating 60 seconds (or 1 minute,
         or 60,000 milliseconds).
       - `week` - given in weeks, with a scaling factor of 604,800,000
         (since the underlying numeric value is in milliseconds).
         The default value of step is 1, indicating 1 week.

       > Note: When the data entered by the user doesn't adhere to the stepping configuration, the user agent may round to the nearest valid value, preferring numbers in the positive direction when there are two equally close options.

       ## `any` value

       - A string value of any means that no stepping is implied, and any value
         is allowed (barring other constraints, such as `min` and `max`).
       - Specifying `any` as the value for `step` has the same effect as 1 for
         `date` inputs.
       """

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
      |> maybe_randomized_name()
      |> IO.inspect(label: :assigns)

    ~H"""
    <input
      type={@type}
      class={[@component, @class]}
      name={@name}
      value={@value}
      checked={@checked}
      list={@list}
      max={@max}
      maxlength={@maxlength}
      min={@min}
      minlength={@minlength}
      multiple={@multiple}
      pattern={@pattern}
      placeholder={@placeholder}
      readonly={@readonly}
      step={@step}
      {@rest}
    />
    """
  end

  attr :name,
       :string,
       required: false,
       doc: "The name of the checkbox, if not given a random value is selected."

  attr :value,
       :string,
       default: nil,
       doc: "The value of the checkbox, sent to the form if select."

  attr :checked,
       :boolean,
       default: nil,
       doc: "The checked flag for the checkbox."

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
       doc: "The name of the radio, if not given a random value is selected."

  attr :value,
       :string,
       default: nil,
       doc: "The value of the radio, sent to the form if select."

  attr :checked,
       :boolean,
       default: nil,
       doc: "The checked flag for the radio."

  attr :color,
       :string,
       required: false,
       values: daisy_colors(),
       doc: "The radio's color."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "The radio's size."

  attr :class,
       :string,
       default: nil,
       doc: "Additional CSS classes to pass to the radio."

  attr :rest,
       :global,
       doc: "Pass arbitrary attributes over to the radio."

  @doc "Shorthand for `<.input type=\"radio\" />`"
  def radio(assigns) do
    assigns
    |> assign(:type, "radio")
    |> input()
  end

  defp normalize(assigns) do
    assign(assigns, :component, component(assigns))
  end

  @doc false
  def component(%{"elemental-disable-styles": true} = _assigns),
    # Ref: https://github.com/saadeghi/daisyui/issues/250#issuecomment-1056107620
    do: ["focus:border-primary", "focus:outline-none"]

  def component(%{rest: %{"elemental-disable-styles": true}} = _assigns),
    # Ref: https://github.com/saadeghi/daisyui/issues/250#issuecomment-1056107620
    do: ["focus:border-primary", "focus:outline-none"]

  def component(%{type: "checkbox"} = assigns),
    do: ["checkbox" | class_modifiers("checkbox", assigns)]

  def component(%{type: "file"} = assigns),
    do: ["file-input" | class_modifiers("file-input", assigns)]

  # Is it redundant and bad to return the class `hidden` here?
  def component(%{type: "hidden"} = _assigns),
    do: ["hidden"]

  def component(%{type: "range"} = assigns),
    do: ["range", class_modifiers("range", assigns)]

  def component(%{type: "radio"} = assigns),
    do: ["radio" | class_modifiers("radio", assigns)]

  # Left blank as Daisy has no styles for it
  def component(%{type: type} = _assigns)
      when type in ~w(color image hidden),
      do: []

  def component(assigns),
    do: ["input" | class_modifiers("input", assigns)]

  defp class_modifiers(class, assigns) do
    [
      assigns[:color] && "#{class}-#{assigns.color}",
      assigns[:size] && "#{class}-#{assigns.size}"
    ]
  end
end
