defmodule Elemental.Storybook.Components.Dropdown do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Dropdown.dropdown/1

  @options ["Foo", "Bar", {"Baz", "Baz Value"}]

  def variations do
    [
      %Variation{
        id: :single_select,
        attributes: %{prompt: "Dropdown", options: @options}
      },
      %Variation{
        id: :multi_select,
        attributes: %{prompt: "Dropdown", options: @options, multi: true}
      }
    ]
  end
end
