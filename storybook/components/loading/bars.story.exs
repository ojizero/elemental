defmodule Elemental.Storybook.Components.Bars do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loading.bars/1

  def variations do
    [
      %Variation{
        id: :bars,
        attributes: %{}
      }
    ]
  end
end
