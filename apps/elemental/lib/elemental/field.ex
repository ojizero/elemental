defmodule Elemental.Field do
  @moduledoc """
  Building on top of `Elemental.Input`, `Elemental.Dropdown`, and
  `Elemental.Select`, provide a wrapped component that easy to
  and decorate as needed.

  ## Usage

      <.field /> # simple text input as a field
      <.field type="dropdown" prompt="My prompt" /> # now it's a prompt

  Fields are mostly intended for use with forms, and they offer  simple
  integration (similar to Phoenix' generated core components);

      <.form for={@form} phx-change="change" phx-submit="submit">
        <.field for={@form[:my_field]} type="dropdown" prompt="My prompt" />
      </.form>

  Labels can be provided to a field as slots configuring them;

      # A text field with a label
      <.field>
        <:label value="My label"/>
      </.field>
      # Labels can be place at the end of the field too
      <.field>
        <:label value="My label" align="end"/>
      </.field>

  More complex patterns are supported using "overlays", an overlay
  is HTML passed externally into the component;

      <.field type="email" placeholder="email@example.org">
        <:overlay>
          <svg class="h-[1em] opacity-50" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g stroke-linejoin="round" stroke-linecap="round" stroke-width="2.5" fill="none" stroke="currentColor"><rect width="20" height="16" x="2" y="4" rx="2"></rect><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path></g></svg>
        </:overlay>
      </.field>

  ## Implementation

  The input itself is rendered within a `<label>` element and wrapped
  with configurable overlays allowing for external customizability.
  Details on overlay documentation and overall field structure
  see `Elemental.Field.field/1`.

  All attributes defined in `Elemental.Input.input/1`, `Elemental.Dropdown.dropdown/1`,
  and `Elemental.Select.select/1` are supported by fields and are just passed
  over to their respective implementation.
  """

  use Elemental.Component

  alias Elemental.Input
  alias Elemental.Select
  alias Elemental.Dropdown

  # TODO: ensure error with defined class works, else use `text-error`
  # TODO: fix select behaviour
  #       -> label doesn't trigger the button (or the button doesn't load the hook)

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

  attr :for,
       Phoenix.HTML.FormField,
       required: false,
       doc: """
       Allows for more seamless integration into Elixir forms.

       Used to determine the `name`, `value`, and `errors` fields when
       building the field.

       > If set the fields `name`, `value`, and `errors` are **ignored**.
       """

  attr :name,
       :string,
       required: false,
       doc: """
       The name of the field, if not given a random value is selected.

       > **Ignored** of `for` attribute is set.
       """

  attr :value,
       :any,
       required: false,
       doc: """
       The value of the field, must either be a string or a list of string.

       > **Ignored** of `for` attribute is set.

       ## Types

       - `dropdown` - as defined in `Element.Dropdown.dropdown/1`
       - `select` - as defined in `Element.Select.select/1`
       - Otherwise as defined in `Element.Input.input/1`
       """

  attr :errors,
       :list,
       default: [],
       doc: """
       A list of errors to render in the field, these values will be passed
       through the `error-translator` attribute.

       > **Ignored** of `for` attribute is set.
       """

  attr :"error-translator",
       {:fun, 1},
       default: &Function.identity/1,
       doc: """
       A function of single arity used to allow errors to be translated
       by consumer. Defaults to `Function.identity/1`.

       Translator must return a string, or other HTML safe values as an outcome
       as the result will be rendered inside a `<span>`.
       """

  attr :"disable-validator",
       :boolean,
       default: false,
       doc: "Disables the validator component on the field."

  ## Shared attributes

  attr :color, :string, required: false, values: daisy_colors(), doc: "The fields's color."
  attr :size, :string, required: false, values: daisy_sizes(), doc: "The fields's size."
  attr :class, :string, default: nil, doc: "Additional CSS classes to pass to the field."

  ## Dropdown only attributes

  attr :multi, :boolean, default: false, doc: "See `Elemental.Dropdown.dropdown/1`."
  attr :searchable, :boolean, default: false, doc: "See `Elemental.Dropdown.dropdown/1`."
  attr :"searchable-inline", :boolean, default: false, doc: "See `Elemental.Dropdown.dropdown/1`."
  attr :hover, :boolean, default: false, doc: "See `Elemental.Dropdown.dropdown/1`."
  attr :open, :boolean, default: false, doc: "See `Elemental.Dropdown.dropdown/1`."

  attr :align, :string,
    default: "start",
    values: ~w(start center end),
    doc: "See `Elemental.Dropdown.dropdown/1`."

  attr :from, :string,
    default: "bottom",
    values: ~w(top bottom left right),
    doc: "See `Elemental.Dropdown.dropdown/1`."

  ## Input only attributes

  attr :checked, :boolean, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :list, :string, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :max, :string, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :maxlength, :string, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :min, :string, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :minlength, :string, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :pattern, :string, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :placeholder, :string, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :readonly, :boolean, default: nil, doc: "See `Elemental.Input.input/1`."
  attr :step, :string, default: nil, doc: "See `Elemental.Input.input/1`."

  ## Dropdown and input shared attributes

  attr :multiple, :boolean,
    required: false,
    doc: "See `Elemental.Dropdown.dropdown/1` and `Elemental.Input.input/1`."

  ## Dropdown and select shared attributes

  attr :options,
       :list,
       required: false,
       doc: "See `Elemental.Dropdown.dropdown/1` and `Elemental.Select.select/1`."

  attr :prompt, :string,
    default: nil,
    doc: "See `Elemental.Dropdown.dropdown/1` and `Elemental.Select.select/1`."

  slot :overlay,
    doc: """
    Allows for inserting inner components that make up the `field`,
    useful for labeling or other customizations around the
    field itself.
    """ do
    attr :align,
         :string,
         values: ~w(start end),
         doc: "Alignment of the label, defaults to `start`."

    attr :from,
         :string,
         values: ~w(edge center),
         doc: """
         The placement of the label relative to other overlays, defaults to `center`.
         """
  end

  slot :label,
    doc: """
    A shorthand for `overlay`s meant for labeling, changes defaults
    and simplifies things by defaulting the label class.

    Effectively a shorthand for;

        <:overlay>
          <span class="label">{@value}</span>
        </:overlay>
    """ do
    attr :value,
         :string,
         required: true,
         doc: "The value to display in the label."

    attr :align,
         :string,
         values: ~w(start end),
         doc: "Alignment of the label, defaults to `start`."

    attr :from,
         :string,
         values: ~w(edge center),
         doc: """
         The placement of the label relative to other overlays, defaults to `edge`.
         """
  end

  # attr :rest, :global, doc: false

  @doc """
  > The primary form field component.

  This component wraps `Elemental.Input`, `Elemental.Dropdown`, and
  `Elemental.Select`  in a label and offers simplified
  customizability and form integration.

  The component can be configured via overlays passed as slots from
  the external consumers of it. Overlays allow for inserting
  HTML element to customize the field.

  ## Structure

  The general structure of the render HTML follows

      <div>
        <label class="component classes">
          <%# Overlays defined as align="start" from="edge" %>
          <%# Overlays defined as align="start" from="center" %>
          <%# The actual field, be it input, dropdown, or select %>
          <%# Overlays defined as align="end" from="center" %>
          <%# Overlays defined as align="end" from="edge" %>
        </label>
        <span :for={error <- @errors} class="hidden validator-hint">{error}</span>
      </div>

  Overlays are rendered in the order they appear in the `align`/`from`
  position configured for them, labels are treated the same as
  overlays are follow the same rules.

  > Labels are nothing more than a shorthand helper for overlays that;
  >
  > 1. They have different defaults for `align` and `from`.
  > 1. They don't allow for arbitrary HTML and always render the given value
  >    in a `<span>` element with appropriate styling.
  """
  def field(assigns)

  def field(%{for: %Phoenix.HTML.FormField{name: name, value: value} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(for: nil, id: assigns.id || field.id)
    |> assign(:errors, errors)
    |> assign(:name, name)
    |> assign(:value, value)
    |> field()
  end

  def field(assigns) do
    assigns = normalize_assigns(assigns)

    # TODO: cleanup validator component
    ~H"""
    <div>
      <label class={classes(assigns)}>
        <.overlay :for={slot <- @start_edge} slot={slot} />
        <.overlay :for={slot <- @start_center} slot={slot} />
        <.wrapped_component {cleanup_assigns(assigns)} />
        <.overlay :for={slot <- @end_center} slot={slot} />
        <.overlay :for={slot <- @end_edge} slot={slot} />
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

  defp wrapped_component(assigns) do
    # Ref: https://github.com/saadeghi/daisyui/issues/250#issuecomment-1056107620
    ~H"""
    <Input.input {assigns} class="focus:border-primary focus:outline-none" elemental-disable-styles />
    """
  end

  @doc false
  def component_classes(assigns) do
    [
      wrapped_component_classes(assigns),
      assigns.validator && "validator"
    ]
  end

  defp wrapped_component_classes(%{type: "select"} = assigns),
    do: Select.component_classes(assigns)

  defp wrapped_component_classes(%{type: "dropdown"} = assigns) do
    # This is specific to dropdown to cleanup it's style and
    # make it usable since the scroll behaviour is for
    # inner badges and not for the field.
    classes_to_remove = Dropdown.empty_classes()

    assigns
    |> Dropdown.component_classes()
    |> Enum.map(fn
      nil -> nil
      classes -> String.replace(classes, classes_to_remove, "")
    end)
  end

  defp wrapped_component_classes(%{type: type} = assigns)
       when type in ~w(checkbox color radio range) do
    assigns
    |> assign(:type, "text")
    |> Input.component_classes()
  end

  defp wrapped_component_classes(assigns), do: Input.component_classes(assigns)

  defp overlay(%{slot: %{__slot__: :label}} = assigns),
    do: ~H[<span class="label">{@slot.value}</span>]

  defp overlay(%{slot: %{__slot__: :overlay}} = assigns),
    do: ~H"{render_slot(@slot)}"

  defp normalize_assigns(assigns) do
    assigns
    |> maybe_randomized_name()
    |> normalize_slots()
    |> assign_new(:errors, fn -> [] end)
    |> assign(:error_translator, assigns[:"error-translator"])
    |> assign_new(:validator, fn %{"disable-validator": disable_validator} ->
      not disable_validator
    end)
  end

  defp normalize_slots(assigns) do
    assigns
    |> assign_slots_defaults()
    |> assign_overlay_elements(:start_edge, "start", "edge")
    |> assign_overlay_elements(:start_center, "start", "center")
    |> assign_overlay_elements(:end_center, "end", "center")
    |> assign_overlay_elements(:end_edge, "end", "edge")
  end

  defp assign_slots_defaults(assigns) do
    assigns
    |> update(:label, fn labels ->
      Enum.map(labels, fn label ->
        label
        |> Map.put_new(:align, "start")
        |> Map.put_new(:from, "edge")
      end)
    end)
    |> update(:overlay, fn overlays ->
      Enum.map(overlays, fn overlay ->
        overlay
        |> Map.put_new(:align, "start")
        |> Map.put_new(:from, "center")
      end)
    end)
  end

  defp assign_overlay_elements(assigns, key, align, from) do
    assigns
    |> overlay_elements()
    |> Enum.filter(fn el -> el.align == align and el.from == from end)
    |> then(fn elements -> assign(assigns, key, elements) end)
  end

  defp overlay_elements(%{label: labels, overlay: overlays}),
    do: Enum.concat(labels, overlays)

  # Slots aren't HTML safe to pass, same with functions, this is
  # the simplest workaround I can think of, while keeping
  # features set and external API simple.
  defp cleanup_assigns(assigns) do
    assigns
    |> Map.delete(:label)
    |> Map.delete(:overlay)
    |> Map.delete(:start_edge)
    |> Map.delete(:start_center)
    |> Map.delete(:end_center)
    |> Map.delete(:end_edge)
    |> Map.delete(:"error-translator")
    |> Map.delete(:error_translator)
  end
end
