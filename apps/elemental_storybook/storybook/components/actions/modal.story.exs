defmodule Elemental.Storybook.Components.Actions.Modal do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Actions.Modal.modal/1

  def imports do
    [
      {Elemental.Actions.Button, button: 1},
      {Elemental.Actions.Modal, show_modal: 1}
    ]
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{},
        slots: [
          """
          <h3 class="text-lg font-bold">Title</h3>
          <p class="py-4">Press ESC key, click outside, or click on ✕ button to close</p>
          """
        ],
        template: """
        <.button phx-click={show_modal(":variation_id")}>open modal</.button>
        <.psb-variation />
        """
      }
    ]
  end
end
