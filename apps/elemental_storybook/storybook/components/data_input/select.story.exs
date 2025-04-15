defmodule Elemental.Storybook.Components.DataInput.Select do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.DataInput.Select.select/1

  def variations do
    [
      %Variation{
        id: :select,
        attributes: %{prompt: "Select", options: ["Foo", {"Bar", "Baz"}]}
      }
    ]
  end
end
