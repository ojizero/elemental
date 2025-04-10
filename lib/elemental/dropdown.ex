defmodule Elemental.Dropdown do
  @moduledoc """
  > An abstraction around DaisyUI's dropdown.

  Think of it as a more advanced `Elemental.Select` with support for
  multi-select and searching out of the box.

  This is implement in a manner that works drop in in forms and uses
  only dead/stateless components with minimal JavaScript.

  ## Usage

  Most basic usage is done by simply passing it `options`

     <.dropdown options={["Foo", "Bar"]}/>

  See `dropdown/1` for details on the support properties and their behaviour.
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
       """

  attr :prompt,
       :string,
       default: nil,
       doc: """
       The prompt to display for the the dropdown.

       This value is replaced when a selection is made with the selected item's label
       (requires JavaScript enabled in the browser).
       """

  attr :name,
       :string,
       required: false,
       doc: "The name of the dropdown, if not given a random value is selected."

  attr :value,
       :any,
       default: nil,
       doc: """
       A value that is selected currently by the component.

       Useful for either preselecting items to maintaining selected
       items state across rerenders.

       ### Type

       - The type is required to either be a single string or a list of strings,
         the values of it should correspond to the value (not label) of the
         options (if using a list of strings then it's the same as label).
       - If the type is single select and if the value is a list of more than one
         item this will raise an error.
       """

  attr :multi,
       :boolean,
       default: false,
       doc: "To enable selection of multiple values, passed to consumer as a list."

  attr :align,
       :string,
       values: ~w(start center end),
       default: "start",
       doc: "Specify the alignment for the dropdown."

  attr :from,
       :string,
       values: ~w(top bottom left right),
       default: "bottom",
       doc: "Specify where the dropdown will appear from."

  attr :hover,
       :boolean,
       default: false,
       doc: "To enable opening the dropdown on hover."

  attr :open,
       :boolean,
       default: false,
       doc: "To open the dropdown immediately."

  attr :searchable,
       :boolean,
       default: false,
       doc: """
       To enable searching the options of the dropdown.

       Search is performed by looking through the labels for the given
       input as substring to match on, if it doesn't match the option
       is disabled, deselected, and hidden.

       #### Notes:
       - Search is case-insensitive.
       - This features JavaScript enabled in the browser along with Hooks enabled.
       """

  attr :class,
       :string,
       default: nil,
       doc: "Additional CSS classes to pass to the dropdown container."

  @doc """
  The primary dropdown component.
  """
  def dropdown(assigns) do
    assigns = normalize_assigns(assigns)

    ~H"""
    <div
      id={@name <> "__container"}
      class={[
        "dropdown",
        "dropdown-#{@align}",
        "dropdown-#{@from}",
        @hover && "dropdown-hover",
        @open && "dropdown-open",
        @class
      ]}
    >
      <div id={@name <> "__prompt"} tabindex="0" role="button" class="select m-1">
        {prompt_initial_value(assigns)}
      </div>
      <ul
        id={@name <> "__content"}
        tabindex="0"
        class="dropdown-content menu bg-neutral-content rounded-box z-1 w-52 p-2 shadow-sm"
      >
        <input
          :if={@searchable}
          id={@name <> "__search"}
          name={@name <> "__search"}
          type="search"
          class="input-ghost border-1 m-1"
          placeholder="Search"
          phx-hook="ElementalDropdownSearch"
        />
        <.dropdown_item
          :for={{{label, value}, index} <- Enum.with_index(@options)}
          id={@name <> "__item_#{index}"}
          name={@name}
          label={label}
          value={value}
          multi={@multi}
          selected={value in @value}
          prompt_element_id={@name <> "__prompt"}
          content_element_id={@name <> "__content"}
        />
      </ul>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :multi, :boolean, required: true
  attr :selected, :boolean, required: true
  attr :prompt_element_id, :string, required: true
  attr :content_element_id, :string, required: true

  defp dropdown_item(assigns) do
    ~H"""
    <li elemental-label={@label} elemental-item-id={@id}>
      <label>
        <input
          id={@id}
          name={item_name(assigns)}
          value={@value}
          type={item_type(assigns)}
          class={item_class(assigns)}
          elemental-hook-label={@label}
          elemental-hook-prompt-id={@prompt_element_id}
          elemental-hook-content-id={@content_element_id}
          phx-hook={not @multi && "ElementalDropdownSingleItem"}
          checked={@selected}
        />
        {@label}
      </label>
    </li>
    """
  end

  defp normalize_assigns(assigns) do
    assigns
    |> assign_new(:name, &random/0)
    |> normalize_options()
    |> normalize_value()
  end

  defp random do
    4
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
  end

  defp normalize_options(assigns) do
    update(assigns, :options, fn options ->
      Enum.map(options, fn
        {label, value} -> {label, value}
        label when is_binary(label) -> {label, label}
      end)
    end)
  end

  defp normalize_value(assigns) do
    update(assigns, :value, fn
      nil, _opts -> []
      value, %{multi: false} when is_binary(value) -> [value]
      [value], %{multi: false} when is_binary(value) -> [value]
      values, %{multi: true} when is_list(values) -> values
    end)
  end

  # TODO: currently only supports single select mode since we
  # only support changing prompt in this mode
  defp prompt_initial_value(%{
         multi: false,
         value: [value],
         prompt: prompt,
         options: options
       }) do
    Enum.find_value(options, prompt, fn
      {label, ^value} -> label
      _otherwise -> false
    end)
  end

  defp prompt_initial_value(%{prompt: prompt}), do: prompt

  defp item_name(%{multi: true, name: name}), do: "#{name}[]"
  defp item_name(%{multi: false, name: name}), do: name

  defp item_type(%{multi: true}), do: "checkbox"
  defp item_type(%{multi: false}), do: "radio"

  defp item_class(%{multi: true}), do: "checkbox"
  defp item_class(%{multi: false}), do: "hidden"
end
