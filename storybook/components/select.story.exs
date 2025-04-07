defmodule Elemental.Storybook.Components.Select do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Select.select/1

  def variations do
    [
      %Variation{
        id: :select,
        attributes: %{prompt: "Select"},
        slots: [
          "<:option>Foo</:option>",
          "<:option>Bar</:option>"
        ]
      }
    ]
  end
end
