defmodule Elemental.Storybook.Components.Infinity do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loading.infinity/1

  def variations do
    [
      %Variation{
        id: :infinity,
        attributes: %{}
      }
    ]
  end
end
