defmodule Elemental.Storybook.Components.Feedback.Progress do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Feedback.Progress.progress/1

  def variations do
    [
      %Variation{
        id: :intermediate,
        attributes: %{}
      },
      %Variation{
        id: :some_percent,
        attributes: %{value: "20"}
      },
      %Variation{
        id: :radial,
        attributes: %{value: "20", radial: true}
      },
      %VariationGroup{
        id: :primary_color,
        description: "Supports Daisy UI colors",
        variations: [
          %Variation{
            id: :percent_0,
            attributes: %{color: "primary", value: 0}
          },
          %Variation{
            id: :percent_10,
            attributes: %{color: "primary", value: 10}
          },
          %Variation{
            id: :percent_40,
            attributes: %{color: "primary", value: 40}
          },
          %Variation{
            id: :percent_70,
            attributes: %{color: "primary", value: 70}
          },
          %Variation{
            id: :percent_100,
            attributes: %{color: "primary", value: 100}
          }
        ]
      },
      %Variation{
        id: :supports_styling,
        attributes: %{
          radial: true,
          color: "secondary-content",
          value: 20,
          max: 120,
          class: "bg-secondary border-secondary border-4"
        }
      }
    ]
  end
end
