defmodule Elemental.Storybook.Components.Spinner do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loading.spinner/1

  def variations do
    [
      %Variation{
        id: :spinner,
        attributes: %{}
      }
    ]
  end
end
