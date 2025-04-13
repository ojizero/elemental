defmodule Elemental.Field do
  @moduledoc """
  Building on top of `Elemental.Input`, `Elemental.Dropdown`, and
  `Elemental.Select`, provide a wrapped component that easy to
  and decorate as needed.

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

  # TODO: support floating labels ?
  # TODO: ensure error with defined class works, else use `text-error`
  # TODO: cleanup implementation and test it out

  attr :type,
       :string,
       default: "text",
       values: ~w(checkbox color date datetime-local email file hidden image
                 month number password radio range search tel text time url
                 week dropdown select),
       doc: """
       > The form field's type.

       ## Types

       - `dropdown` powered by `Elemental.Dropdown.dropdown/1`.
       - `select` powered by `Elemental.Select.select/1`.
       - Any value supported by `Elemental.Input.input/1`.
       """

  attr :"error-translator",
       {:fun, 1},
       default: &Function.identity/1,
       doc: ""

  slot :overlay,
    doc: """
    """ do
    attr :position,
         :string,
         values: ~w(start end),
         doc: """
         """

    attr :placement,
         :string,
         values: ~w(edge center),
         doc: """
         """
  end

  slot :label,
    doc: """
    """ do
    attr :value,
         :string,
         required: true,
         doc: ""

    attr :position,
         :string,
         values: ~w(start end),
         doc: """
         """

    attr :placement,
         :string,
         values: ~w(edge center),
         doc: """
         """
  end

  def field(%{for: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(for: nil, id: assigns.id || field.id)
    # |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign(:errors, errors)
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> field()
  end

  def field(assigns) do
    assigns = normalize_assigns(assigns) |> IO.inspect(label: :assigns)

    ~H"""
    <div>
      <label class={[component(assigns), "validator"]}>
        <.overlay :for={element <- @start_edge} element={element} />
        <.overlay :for={element <- @start_center} element={element} />
        <.wrapped_component {cleanup_assigns(assigns)} />
        <.overlay :for={element <- @end_center} element={element} />
        <.overlay :for={element <- @end_edge} element={element} />
      </label>
      <span :for={error <- @errors} class="hidden validator-hint">
        {@error_translator.(error)}
      </span>
    </div>
    """
  end

  defp wrapped_component(%{type: "select"} = assigns),
    do: ~H"<Select.select {assigns} elemental-disable-styles />"

  defp wrapped_component(%{type: "dropdown"} = assigns),
    do: ~H"<Dropdown.dropdown {assigns} elemental-disable-styles />"

  defp wrapped_component(%{type: type} = assigns)
       when type in ~w(checkbox color radio range),
       do: ~H"<Input.input {assigns} />"

  defp wrapped_component(assigns),
    do: ~H"<Input.input {assigns} elemental-disable-styles />"

  defp component(%{type: "select"} = assigns), do: Select.component(assigns)
  defp component(%{type: "dropdown"} = assigns), do: Dropdown.component(assigns)

  defp component(%{type: type} = _assigns)
       when type in ~w(checkbox color radio range),
       do: ["input"]

  defp component(assigns), do: Input.component(assigns)

  defp overlay(%{element: %{__slot__: :label}} = assigns),
    do: ~H[<span class="label">{@element.value}</span>]

  defp overlay(%{element: %{__slot__: :overlay}} = assigns),
    do: ~H"{render_slot(@element)}"

  defp overlay(%{element: fun} = assigns) when is_function(fun, 1),
    do: fun.(assigns)

  defp normalize_assigns(assigns) do
    assigns
    |> maybe_randomized_name()
    |> normalize_slots()
    |> assign_new(:errors, fn -> [] end)
    |> assign(:error_translator, assigns[:"error-translator"])
  end

  defp normalize_slots(assigns) do
    assigns
    |> assign_slots_defaults()
    |> assign_overlay_elements(:start_edge, "start", "edge")
    |> assign_overlay_elements(:start_center, "start", "center")
    |> assign_overlay_elements(:end_center, "end", "center")
    |> assign_overlay_elements(:end_edge, "end", "edge")
    |> Map.delete(:label)
    |> Map.delete(:overlay)
  end

  defp assign_slots_defaults(assigns) do
    assigns
    |> overlay_elements()
    # TODO: set default values here
    |> IO.inspect(label: :alloverflow)

    assigns
  end

  defp assign_overlay_elements(assigns, key, position, placement) do
    assigns
    |> overlay_elements()
    |> Enum.filter(fn el ->
      el.position == position and el.placement == placement
    end)
    # |> Enum.map(fn el ->
    #   fn assigns ->
    #     assigns = assign(assigns, :element, el)
    #     ~H"<.overlay element={@element} />"
    #   end
    # end)
    |> then(fn elements ->
      assign(assigns, key, elements)
    end)
  end

  defp overlay_elements(%{label: labels, overlay: overlays}),
    do: Enum.concat(labels, overlays)

  defp cleanup_assigns(assigns) do
    assigns
    |> Map.delete(:start_edge)
    |> Map.delete(:start_center)
    |> Map.delete(:end_center)
    |> Map.delete(:end_edge)
  end
end
