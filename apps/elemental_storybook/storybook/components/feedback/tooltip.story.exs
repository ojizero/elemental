defmodule Elemental.Storybook.Components.Feedback.Tooltip do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Feedback.Tooltip.tooltip/1

  def variations do
    [
      %Variation{
        id: :default_tooltip,
        attributes: %{tip: "The tooltip text..."},
        slots: ["<div>A div with a tooltip</div>"]
      }
    ]
  end
end
