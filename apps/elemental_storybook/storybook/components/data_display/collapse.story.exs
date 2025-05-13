defmodule Elemental.Storybook.Components.DataDisplay.Collapse do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.DataDisplay.Collapse.collapse/1

  def variations do
    [
      %Variation{
        id: :with_focus,
        slots: [
          "<:title>How do I create an account?</:title>",
          "Click the \"Sign Up\" button in the top right corner and follow the registration process."
        ]
      },
      %Variation{
        id: :with_plus_icon_click_to_close,
        attributes: %{indicator: "plus", "close-with-click": true},
        slots: [
          "<:title>How do I create an account?</:title>",
          "Click the \"Sign Up\" button in the top right corner and follow the registration process."
        ]
      }
    ]
  end
end
