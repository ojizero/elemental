defmodule Elemental.DataDisplay.Accordion do
  @moduledoc """
  Implements a vertical stacking accordion component, allowing the display of
  content in a stack where only one is showing at a given time.

  This is internally build (inline with Daisy) on top of `Elemental.DataDisplay.Collapse`
  component using the collapse's grouping feature implemented by Elemental.

  ## Usage

      <.accordion>
        <:item title="How do I create an account?">
          Click the "Sign Up" button in the top right corner and follow the registration process.
        </:item>
        <:item title="I forgot my password. What should I do?">
          Click on "Forgot Password" on the login page and follow the instructions sent to your email.
        </:item>
        <:item title="How do I update my profile information?">
          Go to "My Account" settings and select "Edit Profile" to make changes.
        </:item>
      </.accordion>

  ## Notes

  Usage of slots instead of components is intentional to limit flexibility to allow
  for the component to be more streamlined and have a clearer API that doesn't
  do any magic behind the scenes. For more complex use cases you can
  directly use `Elemental.DataDisplay.Collapse`.
  """

  use Elemental.Component

  alias Elemental.DataDisplay.Collapse

  @default_name "accordion"

  attr :name,
       :string,
       default: @default_name,
       doc: """
       The name of the accordion. This must be unique in order to behave correctly
       and internally is passed to `Elemental.DataDisplay.Collapse.collapse/1`
       `group` attribute.
       """

  attr :class,
       :any,
       default: nil,
       doc: "Additional classes to style the wrapper container."

  attr :indicator,
       :string,
       default: "none",
       values: ~w(none arrow plus),
       doc: "Chose the indicator to use to showcase if the section is shown/hidden."

  slot :item,
    required: true,
    doc: """
    The specific items to show in the accordion. Internally these will translate
    to `Elemental.DataDisplay.Collapse.collapse/1` components for each item.

    Title is passed under a `<div>` to the `:title` slot of the collapse component
    whereas the item itself is used as the body of the collapse component.
    """ do
    attr :title,
         :string,
         required: true,
         doc: "The title of the collapsible section."

    attr :title_class,
         :string,
         required: false,
         doc: "Any additional classes to pass title."

    attr :class,
         :any,
         required: false,
         doc: "Additional classes to pass to the internal collapse component."
  end

  @doc "> The primary accordion component."
  def accordion(assigns) do
    ~H"""
    <div class={["flex flex-col gap-2", @class]}>
      <Collapse.collapse
        :for={item <- @item}
        group={@name}
        class={item[:class]}
        indicator={@indicator}
      >
        <:title>
          <div class={item[:title_class]}>
            {item.title}
          </div>
        </:title>
        {render_slot(@item)}
      </Collapse.collapse>
    </div>
    """
  end
end
