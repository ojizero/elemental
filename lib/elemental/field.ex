defmodule Elemental.Field do
  @moduledoc """
  an input with overlay, consider merging dropdown/select into it

  <.input type="type" /> <- simplest

  If overlay slot if given
    -> wrap it all in label
    -> style goes to label
    -> input has now no style

  <.field type="type">
    <:overlay placement="right|left">
      Allow things on top of the element
      https://daisyui.com/components/input/#text-input-with-text-label-inside
    </:overlay>
    <:overlay placement="right|left">
      Allow things on top of the element
      https://daisyui.com/components/input/#text-input-with-text-label-inside
    </:overlay>
  </.field>

  How to label? Label component ideally should be just that, a label
  however doing the above means it's better be a span inside the
  input, which won't fly as a just label. Check how label
  behaves in isolation to decide.

  See how all this plays with the made select and dropdown and those
  can integrate here (or if they should be just dumped here instead)
  """

  use Elemental.Component

  alias Elemental.Input
  alias Elemental.Select
  alias Elemental.Dropdown

  attr :for,
       Phoenix.HTML.FormField,
       #  required: true,
       doc: ""

  attr :type,
       :string,
       default: "text",
       values: ~w(checkbox color date datetime-local email file hidden image
                  month number password radio range search tel text time url
                  week dropdown select),
       doc: """
       > The form field's type.

       ## Types

       - `dropdown` power by `Elemental.Dropdown.dropdown/1`.
       - `select` power by `Elemental.Select.select/1`.
       - Any value supported by `Elemental.Input.input/1`.
       """

  slot :label,
    doc: "" do
    attr :position,
         :string,
         values: ~w(start end),
         doc: ""

    attr :"relative-to", :string
  end

  slot :overlay do
    attr :position,
         :string,
         values: ~w(start end),
         doc: ""
  end

  def field(%{for: %Phoenix.HTML.FormField{} = field} = assigns) do
    # errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    # |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> field()
  end

  def field(assigns) do
    ~H"""
    <label class={component(assigns)}>
      <.wrapped_component {assigns} />
    </label>
    """
  end

  defp wrapped_component(%{type: "select"} = assigns) do
    ~H"<Select.select {assigns} elemental-disable-styles />"
  end

  defp wrapped_component(%{type: "dropdown"} = assigns) do
    ~H"<Dropdown.dropdown {assigns} elemental-disable-styles />"
  end

  defp wrapped_component(assigns) do
    ~H"<Input.input {assigns} elemental-disable-styles />"
  end

  defp component(%{type: "select"} = assigns), do: Select.component(assigns)
  defp component(%{type: "dropdown"} = assigns), do: Dropdown.component(assigns)
  defp component(assigns), do: Input.component(assigns)
end
