defmodule Elemental.Dropdown do
  @moduledoc """
  > An abstraction around DaisyUI's dropdown.

  Think of it as a more advanced `Elemental.Select` with support for
  multi-select and searching out of the box.

  This is implement in a manner that works drop-in in forms and uses
  only dead/stateless components with minimal JavaScript.

  ## Usage

  Make sure in your application to include the required JavaScript hooks
  required for the main behaviour, found in `dropdown.js`.

  See the [hooks section](#javascript-hooks) for more details.

  Most basic usage is done by simply passing it `options`

      <.dropdown options={["Foo", "Bar"]}/>

  See `dropdown/1` for details on the support properties and their behaviour.

  ## JavaScript hooks

  This implementation requires JavaScript hooks for it's main behaviour,
  utilizes 3 main hooks

  - `ElementalDropdownSearch` implementing filtering/search behaviour when enabled.
  - `ElementalDropdownSingleItem` implementing prompt changes when using single item mode.
  - `ElementalDropdownMultiItem` implementing prompt changes when using multi item mode.

  ## Implementation considerations

  The component is implemented as a dead/stateless component as to simplify it's
  usage and avoid complexities associated with live/stateful components.

  This comes from my dissatisfaction with implementations I found which have behaviours
  that I kept finding to be non-obvious and odd, from how they interact with
  events sent to parent vs themselves, along with how they handle their
  states.

  Additionally the implementation aims to be drop-in compatible with forms in general
  as well as how forms are handled in Phoenix/LiveView without requiring much fuss.

  The behaviour relies heavily on the provided minimal JavaScript hooks, as well as
  relying on native form behaviours with how forms deal with radio buttons and
  checkboxes.
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

       Useful for either preselecting items or to maintaining selected
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

  attr :searchable_inline,
       :boolean,
       default: false,
       doc: "To enable inlining of the search field for the dropdown (experimental/buggy)."

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

  attr :color,
       :string,
       values: ~w(ghost neutral primary secondary accent info success warning error),
       required: false,
       doc: "The dropdown prompt container color."

  attr :size,
       :string,
       values: ~w(xs sm md lg xl),
       required: false,
       doc: "The dropdown prompt container size."

  attr :class,
       :string,
       default: nil,
       doc: """
       Additional CSS classes to pass to the dropdown.

       Those will be applied to the the dropdown prompt container since it's
       the "visible"/"interactive" bit of the dropdown.
       """

  @doc """
  > The primary dropdown component.

  This dropdown attempts to provide a fully featured dropdown/select element
  with native support for searching along with multiple select mode out
  of the box.

  > The API provided here works drop-in with Elemental's select
  > component (see `Elemental.Select`).

  ## Select compatibility

  While this component provides 1-1 API compatibility the the more simpler
  `Elemental.Select.select/1`, augmenting it with additional features
  and interactivity, there's the caveat that it does not yet
  support option groups.
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
        @open && "dropdown-open"
      ]}
    >
      <div
        id={@name <> "__prompt_container"}
        tabindex="0"
        role="button"
        class={[
          "select m-1 overflow-scroll gap-1",
          assigns[:color] && "select-#{@color}",
          assigns[:size] && "select-#{@size}",
          @class
        ]}
      >
        <.dropdown_prompt
          name={@name}
          value={@value}
          multi={@multi}
          prompt={unless @searchable and @searchable_inline, do: @prompt}
          options={@options}
        />
        <.dropdown_search
          :if={@searchable and @searchable_inline}
          id={@name <> "__search"}
          name={@name <> "__search"}
          placeholder={@prompt}
          filterable_content_id={@name <> "__content"}
        />
      </div>
      <ul
        id={@name <> "__content"}
        tabindex="0"
        class="dropdown-content menu bg-neutral-content rounded-box z-1 w-52 p-2 shadow-sm"
      >
        <.dropdown_search
          :if={@searchable and not @searchable_inline}
          id={@name <> "__search"}
          name={@name <> "__search"}
          placeholder="Search"
          filterable_content_id={@name <> "__content"}
        />
        <.dropdown_item
          :for={{{label, value}, index} <- Enum.with_index(@options)}
          id={@name <> "__item_#{index}"}
          name={@name}
          label={label}
          value={value}
          multi={@multi}
          selected={value in @value}
          content_element_id={@name <> "__content"}
          default_prompt_element_id={@name <> "__default_prompt"}
          prompt_container_element_id={@name <> "__prompt_container"}
        />
      </ul>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :value, :list, required: true
  attr :multi, :boolean, required: true
  attr :prompt, :string, default: nil
  attr :options, :list, required: true

  defp dropdown_prompt(assigns) do
    ~H"""
    <span :if={@prompt} id={@name <> "__default_prompt"} class={@value != [] && "hidden"}>
      {@prompt}
    </span>
    <span
      :for={{{label, value}, index} <- Enum.with_index(@options)}
      id={@name <> "__item_#{index}_display"}
      class={[@multi && "badge badge-neutral", value not in @value && "hidden"]}
    >
      {label}
    </span>
    """
  end

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :multi, :boolean, required: true
  attr :selected, :boolean, required: true
  attr :content_element_id, :string, required: true
  attr :default_prompt_element_id, :string, required: true
  attr :prompt_container_element_id, :string, required: true

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
          elemental-hook-content-id={@content_element_id}
          elemental-hook--default-prompt-id={@default_prompt_element_id}
          elemental-hook-prompt-container-id={@prompt_container_element_id}
          phx-hook={phx_hook(assigns)}
          checked={@selected}
        />
        {@label}
      </label>
    </li>
    """
  end

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :placeholder, :string, required: true
  attr :filterable_content_id, :string, required: true

  defp dropdown_search(assigns) do
    ~H"""
    <input
      id={@id}
      name={@name}
      type="search"
      class="input-ghost border-1 m-1"
      placeholder={@placeholder}
      phx-hook="ElementalDropdownSearch"
      elemental-hook-filterable-content-id={@filterable_content_id}
    />
    """
  end

  defp normalize_assigns(assigns) do
    assigns
    |> assign_new(:name, &random/0)
    |> normalize_options()
    |> normalize_value()
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

  defp item_name(%{multi: true, name: name}), do: "#{name}[]"
  defp item_name(%{multi: false, name: name}), do: name

  defp item_type(%{multi: true}), do: "checkbox"
  defp item_type(%{multi: false}), do: "radio"

  defp item_class(%{multi: true}), do: "checkbox"
  defp item_class(%{multi: false}), do: "hidden"

  defp phx_hook(%{multi: true}), do: "ElementalDropdownMultiItem"
  defp phx_hook(%{multi: false}), do: "ElementalDropdownSingleItem"
end
