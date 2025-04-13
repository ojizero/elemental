defmodule Elemental.Storybook.Components.Button do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Button.button/1

  def variations do
    [
      %Variation{
        id: :button,
        attributes: %{},
        slots: ["Click me"]
      },
      %VariationGroup{
        id: :links,
        description: "Links that appear as buttons",
        variations: [
          %Variation{
            id: :href,
            attributes: %{href: "https://github.com/ojizero/elemental", target: "_blank"},
            slots: ["Traditional navigation"]
          },
          %Variation{
            id: :navigate,
            attributes: %{navigate: "/components/button"},
            slots: ["Live navigation"]
          },
          %Variation{
            id: :patch,
            attributes: %{patch: "/components/button"},
            slots: ["Live patch"]
          }
        ]
      }
    ]
  end
end
