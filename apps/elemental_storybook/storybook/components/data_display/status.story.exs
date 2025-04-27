defmodule Elemental.Storybook.Components.DataDisplay.Status do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.DataDisplay.Status.status/1

  def variations do
    [
      %Variation{id: :default}
    ]
  end
end
