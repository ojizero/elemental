defmodule Elemental.Navigation.Dock do
  @moduledoc """
  Implements a dock component, this is most useful for mobile views.

  > `<meta name="viewport" content="viewport-fit=cover"> `is required
  > for responsiveness of the dock in iOS.

  ## Usage

      <%# name is provided by the dock if needed %>
      <.dock :let={_name}>
        <%# id is provided so you can link the proposed button to the label %>
        <.dock_action :let={_id} selected>
          <:label>Home</:label>
          <%# Some action/button to route the user home %>
        </.dock_action>
        <.dock_action>
          <:label :let={_id}>Inbox</:label>
          <%# Some action/button to route the user inbox %>
        </.dock_action>
        <.dock_action :let={_id}>
          <:label>Settings</:label>
          <%# Some action/button to route the user settings %>
        </.dock_action>
      </.dock>
  """

  use Elemental.Component

  @default_name "dock"

  attr :name,
       :string,
       default: @default_name,
       doc: """
       The name of the dock.

       This will be provided as an argument for the inner content
       provided in case it is needed by your action.
       """

  attr :size,
       :string,
       required: false,
       values: daisy_sizes(),
       doc: "Control the size of the dock and it's actions."

  attr :class,
       :any,
       default: nil,
       doc: "Additional CSS classes to add to the dock."

  slot :inner_block,
    required: true,
    doc: """
    The inner content of the dock, this is used to set the actions of the dock
    and is expected to be made up of `dock_action/1` components one for each
    action you are defining.
    """

  @doc """
  > The primary dock component.

  """
  def dock(assigns) do
    ~H"""
    <div class={[
      "dock",
      assigns[:size] && "dock-#{@size}",
      @class
    ]}>
      {render_slot(@inner_block, @name)}
    </div>
    """
  end

  attr :id,
       :any,
       required: false,
       doc: """
       An identifier for the action you're adding.

       > Defaults to a random value, this is used to link up
       > the internal label with the action you provide.
       """

  attr :for,
       :string,
       default: @default_name,
       doc: """
       The name of the dock.

       > You can use this to keep track in case you (for whatever reason)
       > have multiple docks in your page.
       """

  attr :selected,
       :boolean,
       default: false,
       doc: "Whether the current dock action is selected."

  slot :label,
    required: false,
    doc: """
    The label for your dock action, can be anything allowed within
    the `<label>` HTML element. This will be linked to the
    `id` you provide (or the random one generated).

    This will receive the `dock-label` part class.
    """ do
    attr :class,
         :any,
         required: false,
         doc: "Additional CSS classes to label."
  end

  slot :inner_block,
    required: true,
    doc: """
    An arbitrary HTML  content to set as action you provide for the
    dock. You can put anything here but probably it makes more
    sense to set it as a button or a link of some kind.
    """

  @doc """
  > The primary dock action component.


  """
  def dock_action(assigns) do
    assigns = assign_new(assigns, :id, fn -> random() end)

    ~H"""
    <div class={@selected && "dock-active"}>
      {render_slot(@inner_block, @id)}
      <label for={@id} class={["dock-label", @label[:class]]}>
        {render_slot(@label)}
      </label>
    </div>
    """
  end

  # defp item_id(_name, id, _index) when not is_nil(id), do: id
  # defp item_id(name, _id, index), do: "#{name}-#{index}"
  # defp navigation?(%{href: href}) when not is_nil(href), do: true
  # defp navigation?(%{patch: patch}) when not is_nil(patch), do: true
  # defp navigation?(%{navigate: navigate}) when not is_nil(navigate), do: true
  # defp navigation?(_otherwise), do: false
end
