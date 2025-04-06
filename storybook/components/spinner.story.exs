defmodule Elemental.Storybook.Components.Spinner do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loader.spinner/1

  def variations do
    [
      %Variation{
        id: :spinner,
        attributes: %{}
      }
    ]
  end
end
