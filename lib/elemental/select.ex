defmodule Elemental.Select do
  @moduledoc """
  > An abstraction on top of DaisyUI's (& plain HTML) select.

  This abstracts native HTML selects providing an API that is compatible
  1-1 with `Elemental.Dropdown` aiming to provide consistency between
  the main/core input components provided by Elemental.

  ## Usage

  Most basic usage is done by simply passing it `options`

      <.select options={["Foo", "Bar"]}/>

  See `select/1` for details on the support properties and their behaviour.
  """

  use Elemental.Component

  attr :options,
       :list,
       required: true,
       doc: """
       The list of values to select between. This is required to either be a list of
       strings, or a list of string tuples.

       ### List item types

       - If given as a list of strings (`[String.t]`) each option will use that value
         as both it's label and value sent to from the dropdown.
       - If give as a list of tuples (`[{String.t, String.t}]`), those tuples are expected
         to be two strings, the first being the label to use, while the second is
         expected to be the value to send from the dropdown.
       - Mixing the two forms is allowed.
       - Nested lists translate to option groups. See `Phoenix.HTML.Form.options_for_select/2`.
       """

  attr :prompt,
       :string,
       default: nil,
       doc: "The prompt to display for the the select."

  attr :name,
       :string,
       required: false,
       doc: "The name of the select, if not given a random value is selected."

  attr :value,
       :string,
       default: nil,
       doc: """
       A value that is selected currently by the component.

       Useful for either preselecting items or to maintaining selected
       items state across rerenders.
       """

  attr :color,
       :string,
       required: false,
       values: daisy_colors(),
       doc: "The select prompt color."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "The select prompt size."

  attr :class,
       :string,
       default: nil,
       doc: "Additional CSS classes to pass to the select."

  attr :rest, :global

  @doc "> The primary select component."
  def select(assigns) do
    assigns =
      assigns
      |> assign(:component, component(assigns))
      |> maybe_randomized_name()

    ~H"""
    <select class={[@component, @class]} name={@name}>
      <option :if={@prompt} value="" disabled selected={prompt_selected?(assigns)}>{@prompt}</option>
      {Phoenix.HTML.Form.options_for_select(@options, @value)}
    </select>
    """
  end

  defp prompt_selected?(%{options: options, value: value}) do
    values =
      Enum.map(options, fn
        {_label, value} -> value
        label -> label
      end)

    value not in values
  end

  @doc false
  def component(%{"elemental-disable-styles": true} = _assigns), do: []
  def component(%{rest: %{"elemental-disable-styles": true}} = _assigns), do: []

  def component(assigns) do
    [
      "select",
      assigns[:color] && "select-#{assigns.color}",
      assigns[:size] && "select-#{assigns.size}"
    ]
  end
end
