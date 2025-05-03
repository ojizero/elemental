defmodule Elemental.Storybook.Components.Navigation.TabbedView do
  use PhoenixStorybook.Story, :example

  import Elemental.Navigation.Tabs

  def doc do
    """
    Example showcasing changing the name of a tabbed view.

    This example shows the expected way to keep the name of tabs inside
    a tabbed view consistent, and the expectation for it to be in
    sync with the name of the tabbed view itself.
    """
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-row gap-2 h-screen">
      <.first_tabbed_view />
      <.second_tabbed_view />
    </div>
    """
  end

  defp first_tabbed_view(assigns) do
    ~H"""
    <.tabs :let={name} name="foo" class="w-full h-full" box border>
      <.tab for={name} selected>
        <:title>
          Lorem
        </:title>
        <p>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        </p>
      </.tab>
      <.tab for={name}>
        <:title>
          Ipsum
        </:title>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
      </.tab>
    </.tabs>
    """
  end

  defp second_tabbed_view(assigns) do
    ~H"""
    <.tabs :let={name} name="bar" class="w-full h-full" box border>
      <.tab for={name} selected>
        <:title>
          Another Lorem
        </:title>
        <p>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        </p>
      </.tab>
      <.tab for={name}>
        <:title>
          Another Ipsum
        </:title>
        <p>
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
      </.tab>
    </.tabs>
    """
  end
end
