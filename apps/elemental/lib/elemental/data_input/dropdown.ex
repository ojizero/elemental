# TODO: "dropdowns" are classified as "actions" in Daisy docs
#       however this dropdown is more of a "dropdown-select"
#       should we rename it instead?
defmodule Elemental.DataInput.Dropdown do
  @moduledoc """
  > An abstraction around DaisyUI's dropdown.

  Think of it as a more advanced `Elemental.DataInput.Select` with support for
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
  that I kept finding to be non-obvious and odd, from how they interact with events
  sent to parent vs themselves, along with how they handle their states.

  Additionally the implementation aims to be drop-in compatible with forms in general
  as well as how forms are handled in Phoenix/LiveView without requiring much fuss.

  The behaviour relies heavily on the provided minimal JavaScript hooks, as well as
  relying on native form behaviours with how forms deal with radio buttons and
  checkboxes.
  """

  use Elemental.Component

  alias Elemental.DataInput.Input
  alias Elemental.Actions.Button

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

  attr :multiple,
       :boolean,
       default: false,
       doc: "Only present for compatibility, if true enables `multi`."

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

  attr :"searchable-inline",
       :boolean,
       default: false,
       doc: """
       To enable inlining of the search field for the dropdown.

       > Implies `searchable` if enabled.
       """

  attr :align,
       :string,
       default: "start",
       values: ~w(start center end),
       doc: "Specify the alignment for the dropdown."

  attr :from,
       :string,
       default: "bottom",
       values: ~w(top bottom left right),
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
       required: false,
       values: daisy_colors(),
       doc: "The dropdown prompt container color."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "The dropdown prompt container size."

  attr :class,
       :string,
       default: nil,
       doc: """
       Additional CSS classes to pass to the dropdown.

       Those will be applied to the the dropdown prompt container since it's
       the "visible"/"interactive" bit of the dropdown.
       """

  attr :rest, :global
  # Passed outside of rest to simplify access and defaulting it
  # not documented as it's a "global" attribute and we wanna
  # treat it as such.
  #
  # ID is passed over to a hidden trigger (button) to allow simplified
  # binding + more correct behaviour with labels, ID itself is passed
  # there to also simplify/streamline behaviour when triggering it
  # programmatically if need be (makes it similar to other inputs)
  attr :id, :string, required: false, doc: false

  @doc """
  > The primary dropdown component.

  This dropdown attempts to provide a fully featured dropdown/select element
  with native support for searching along with multiple select mode out
  of the box.

  > The API provided here works drop-in with Elemental's select
  > component (see `Elemental.DataInput.Select`).

  ## Select compatibility

  While this component provides 1-1 API compatibility the the more simpler
  `Elemental.DataInput.Select.select/1`, augmenting it with additional features
  and interactivity, there's the caveat that it does not yet
  support option groups.
  """
  def dropdown(assigns) do
    assigns = normalize_assigns(assigns)

    ~H"""
    <div>
      <Button.button
        id={@id}
        type="button"
        class="hidden"
        elemental-disable-styles
        phx-click={
          JS.toggle_attribute({"open", "true"},
            to: "\##{Phoenix.HTML.css_escape("#{@id}__dropdown")}"
          )
        }
      >
      </Button.button>
      <details
        id={@id <> "__dropdown"}
        class={[
          "dropdown",
          "dropdown-#{@align}",
          "dropdown-#{@from}",
          @hover && "dropdown-hover",
          @open && "dropdown-open"
        ]}
        phx-click-away={JS.remove_attribute("open")}
      >
        <summary id={@id <> "__prompt_container"} class={classes(assigns)}>
          <.dropdown_prompt
            component_id={@id}
            name={@name}
            value={@value}
            multi={@multi}
            prompt={unless @searchable and @inline_search, do: @prompt}
            options={@options}
          />
          <.dropdown_search
            :if={@searchable and @inline_search}
            component_id={@id}
            id={@id <> "__inline_search"}
            name={@name <> "__search"}
            placeholder={@prompt}
          />
        </summary>
        <ul
          id={@id <> "__content"}
          class="dropdown-content menu bg-neutral-content rounded-box z-1 w-52 p-2 shadow-sm"
        >
          <.dropdown_search
            :if={@searchable and not @inline_search}
            component_id={@id}
            id={@id <> "__search"}
            name={@name <> "__search"}
            placeholder="Search"
          />
          <.dropdown_item
            :for={{{label, value}, index} <- Enum.with_index(@options)}
            component_id={@id}
            id={@id <> "__item_#{index}"}
            name={@name}
            label={label}
            value={value}
            multi={@multi}
            selected={value in @value}
          />
        </ul>
      </details>
    </div>
    """
  end

  attr :component_id, :string, required: true
  attr :name, :string, required: true
  attr :value, :list, required: true
  attr :multi, :boolean, required: true
  attr :prompt, :string, default: nil
  attr :options, :list, required: true

  defp dropdown_prompt(assigns) do
    ~H"""
    <span :if={@prompt} id={@component_id <> "__default_prompt"} class={@value != [] && "hidden"}>
      {@prompt}
    </span>
    <span
      :for={{{label, value}, index} <- Enum.with_index(@options)}
      id={@component_id <> "__item_#{index}_display"}
      class={[@multi && "badge badge-neutral", value not in @value && "hidden"]}
    >
      {label}
    </span>
    """
  end

  attr :component_id, :string, required: true
  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :multi, :boolean, required: true
  attr :selected, :boolean, required: true

  defp dropdown_item(assigns) do
    ~H"""
    <li tabindex="0" elemental-label={@label} elemental-item-id={@id}>
      <label>
        <Input.input
          id={@id}
          type={item_type(assigns)}
          name={item_name(assigns)}
          value={@value}
          checked={@selected}
          hidden={not @multi}
          phx-hook={phx_hook(assigns)}
          elemental-component-id={@component_id}
        />
        {@label}
      </label>
    </li>
    """
  end

  attr :id, :string, required: true
  attr :component_id, :string, required: true
  attr :name, :string, required: true
  attr :placeholder, :string, required: true

  defp dropdown_search(assigns) do
    ~H"""
    <Input.input
      id={@id}
      type="search"
      name={@name}
      color="ghost"
      class="border-1 m-1 focus:outline-none"
      placeholder={@placeholder}
      phx-hook="ElementalDropdownSearch"
      elemental-component-id={@component_id}
    />
    """
  end

  defp normalize_assigns(assigns) do
    assigns
    |> maybe_randomized_name()
    |> assign_new(:id, fn %{name: name} -> name end)
    |> normalize_options()
    |> normalize_value()
    |> normalize_search_props()
    |> normalize_multi()
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

  defp normalize_search_props(%{"searchable-inline": inline_search} = assigns) do
    assigns
    # Rename it to snake_case to allow `@` access in HEEx whilst
    # maintaining HTML like kebab-case external API.
    |> assign(:inline_search, inline_search)
    # If inlined search is enabled set enable searchability.
    |> update(:searchable, fn searchable -> inline_search or searchable end)
  end

  defp normalize_multi(%{multiple: true} = assigns), do: assign(assigns, :multi, true)
  defp normalize_multi(assigns), do: assigns

  defp item_name(%{multi: true, name: name}), do: "#{name}[]"
  defp item_name(%{multi: false, name: name}), do: name

  defp item_type(%{multi: true}), do: "checkbox"
  defp item_type(%{multi: false}), do: "radio"

  defp phx_hook(%{multi: true}), do: "ElementalDropdownMultiItem"
  defp phx_hook(%{multi: false}), do: "ElementalDropdownSingleItem"

  @doc false
  def component_classes(assigns) do
    [
      "select overflow-scroll m-1 gap-1",
      assigns[:color] && "select-#{assigns.color}",
      assigns[:size] && "select-#{assigns.size}"
    ]
  end

  @doc false
  def empty_classes, do: "overflow-scroll m-1 gap-1"
end
