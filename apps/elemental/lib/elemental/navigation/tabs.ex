defmodule Elemental.Navigation.Tabs do
  @moduledoc """
  Implements a tabbed view navigation built atop Daisy's tab
  component back by radio buttons. Slots are provided
  for consumers to pass their UI elements/pages
  for each tab.

  ## Usage

      <.tabs>
        <.tab>
          <:title>My tab</:title>
          <div>
           <%# whatever the content of the tab is %>
          </div>
        </.tab>
        <.tab>
          <:title>My second tab</:title>
          <div>
           <%# whatever the content of the tab is %>
          </div>
        </.tab>
      </.tabs>

  `tabs/1` is the tabbed view component, which is the container
  that will wrap your content and manage the transitions, and
  `tab/1` is the specific tab component which will take care
  of rendering your tab and handling the internal radio
  buttons used to select the active tab.

  The name used for all `tab/1` components must match for the behaviour
  to work as expected as they're built on top of a radio group.

  The default value of name is set to the same default `name` used for
  `tabs/1`. `tabs/1` will pass it's name as an argument to the inner
  block to simplify changing it

      <.tabs :let={tabs} name="foo-bar">
        <%# tabs is now a variable holding the name passed to `tabs/1` %>
        <.tab for={tabs}>
          <:title>My tab</:title>
          <div>
           <%# whatever the content of the tab is %>
          </div>
        </.tab>
        <.tab for={tabs}>
          <:title>My second tab</:title>
          <div>
           <%# whatever the content of the tab is %>
          </div>
        </.tab>
      </.tabs>
  """

  use Elemental.Component

  alias Elemental.DataInput.Input

  @default_name "tabbed-view"

  attr :name,
       :string,
       default: @default_name,
       doc: "The name of the tabbed view."

  attr :class,
       :any,
       default: nil,
       doc: "Additional CSS classes to add to the tabbed view."

  attr :box,
       :boolean,
       default: false,
       doc: "Style the tabbed view in a box."

  attr :lift,
       :boolean,
       default: false,
       doc: "Style the tabbed view a lift style."

  attr :border,
       :boolean,
       default: false,
       doc: "Style tabs to have a bottom border."

  attr :center,
       :boolean,
       default: false,
       doc: "Center the tabs in the page."

  attr :placement,
       :string,
       default: "top",
       values: ~w(top bottom),
       doc: "Control the placement of the tabs relative to the content."

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "Control the size of the tabs in the tabbed view."

  slot :inner_block,
    required: true,
    doc: """
    The inner content of the tabbed view, this is expected to be made up
    of `tab/1` components one for each tab you want.

    Under the hood the expectation is for a set of radio buttons linked
    together each bound to the content to display, the selected radio
    determines which tab is currently selected and showing.
    """

  @doc """
  > The primary tabbed view component.


  """
  def tabs(assigns) do
    ~H"""
    <div
      role="tablist"
      class={[
        "tabs",
        "tabs-#{@placement}",
        @box && "tabs-box",
        @lift && "tabs-lift",
        @border && "tabs-border",
        assigns[:size] && "tabs-#{@size}",
        @class
      ]}
    >
      <span :if={@center} class="tab"></span>
      {render_slot(IO.inspect(@inner_block, label: :inner), @name)}
      <span :if={@center} class="tab"></span>
    </div>
    """
  end

  attr :for,
       :string,
       default: @default_name,
       doc: """
       The name of the tabbed grouped.

       > This must match for tabs to behave correctly as it is set as
       > the name of the underlying radio group.
       """

  attr :selected,
       :boolean,
       default: false,
       doc: "Whether the current tab is preselected."

  slot :title,
    required: true,
    doc: """
    The title of the tab, this will be wrapped in a `<label>` element
    so be mindful what you set here.
    """ do
    attr :class,
         :any,
         required: false,
         doc: "Additional CSS classes to label wrapping the title."
  end

  slot :inner_block,
    required: true,
    doc: """
    The content of the actual tab, this will be later controlled based
    on which tab is currently selected.
    """

  @doc """
  > The primary component for each specific tab.


  """
  def tab(assigns) do
    ~H"""
    <label role="tab" class={["tab", @title[:class]]}>
      <Input.radio name={@for} checked={@selected} hidden elemental-disable-styles />
      {render_slot(@title)}
    </label>
    <div role="tabpanel" class="tab-content">
      {render_slot(@inner_block)}
    </div>
    """
  end
end
