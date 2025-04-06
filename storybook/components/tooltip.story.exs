defmodule Elemental.Storybook.Components.Tooltip do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Tooltip.tooltip/1

  def variations do
    [
      %Variation{
        id: :default_tooltip,
        attributes: %{tip: "The tooltip text..."},
        slots: ["<div>A div with a tooltip</div>"]
      },
      %VariationGroup{
        id: :theming,
        description: "Tooltip theming properties",
        variations: [
          %Variation{
            id: :light_tooltip,
            attributes: %{tip: "The tooltip text...", theme: "light"},
            slots: ["<div>The tooltip in a light theme</div>"]
          },
          %Variation{
            id: :dark_tooltip,
            attributes: %{tip: "The tooltip text...", theme: "dark"},
            slots: ["<div>The tooltip in a dark theme</div>"]
          }
        ]
      },
      %VariationGroup{
        id: :positioning,
        description: "Tooltip positioning properties",
        variations: [
          %Variation{
            id: :positioned_top_tooltip,
            attributes: %{tip: "The tooltip text...", position: "top"},
            slots: ["<div>The tooltip's top position</div>"]
          },
          %Variation{
            id: :positioned_bottom_tooltip,
            attributes: %{tip: "The tooltip text...", position: "bottom"},
            slots: ["<div>The tooltip's bottom position</div>"]
          },
          %Variation{
            id: :positioned_right_tooltip,
            attributes: %{tip: "The tooltip text...", position: "right"},
            slots: ["<div>The tooltips right position</div>"]
          },
          %Variation{
            id: :positioned_left_tooltip,
            attributes: %{tip: "The tooltip text...", position: "left"},
            slots: ["<div>The tooltips left position</div>"]
          }
        ]
      }
    ]
  end
end
