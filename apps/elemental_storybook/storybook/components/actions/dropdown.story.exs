defmodule Elemental.Storybook.Components.Actions.Dropdown do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Actions.Dropdown.dropdown/1

  def variations do
    [
      %Variation{
        id: :basic_dropdown_menu,
        attributes: %{},
        slots: [
          """
          <:trigger class="btn">Open the dropdown</:trigger>
          """,
          """
          <ul class="menu dropdown-content bg-neutral-content rounded-box z-1 w-52 p-2 shadow-sm">
            <li><a>Item 1</a></li>
            <li><a>Item 2</a></li>
          </ul>
          """
        ]
      }
    ]
  end
end
