defmodule Elemental.Storybook.Components.DataInput.Field do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.DataInput.Field.field/1

  def variations do
    [
      %Variation{
        id: :simple_text_with_label,
        attributes: %{placeholder: "Some input"},
        slots: [
          """
          <:label value="Foo" />
          """
        ]
      },
      %Variation{
        id: :text_field_with_overlays,
        attributes: %{type: "search", placeholder: "Search"},
        slots: [
          """
          <:overlay>
            <svg class="h-[1em] opacity-50" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g stroke-linejoin="round" stroke-linecap="round" stroke-width="2.5" fill="none" stroke="currentColor"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.3-4.3"></path></g></svg>
          </:overlay>
          """,
          """
          <:overlay align="end">
            <kbd class="kbd kbd-sm">⌘</kbd>
            <kbd class="kbd kbd-sm">K</kbd>
          </:overlay>
          """
        ]
      },
      %Variation{
        id: :dropdowns,
        attributes: %{type: "dropdown", prompt: "Dropdown", options: ["Foo", "Bar"]},
        slots: [
          """
          <:overlay>
            <svg class="h-[1em] opacity-50" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g stroke-linejoin="round" stroke-linecap="round" stroke-width="2.5" fill="none" stroke="currentColor"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></g></svg>
          </:overlay>
          """,
          """
          <:label value="Users" />
          """
        ]
      }
    ]
  end
end
