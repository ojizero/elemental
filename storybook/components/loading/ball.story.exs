defmodule Elemental.Storybook.Components.Ball do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loading.ball/1

  def variations do
    [
      %Variation{
        id: :ball,
        attributes: %{}
      }
    ]
  end
end
