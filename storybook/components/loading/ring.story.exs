defmodule Elemental.Storybook.Components.Ring do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loading.ring/1

  def variations do
    [
      %Variation{
        id: :ring,
        attributes: %{}
      }
    ]
  end
end
