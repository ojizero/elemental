defmodule Elemental.Storybook.Components.Dots do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loading.dots/1

  def variations do
    [
      %Variation{
        id: :dots,
        attributes: %{}
      }
    ]
  end
end
