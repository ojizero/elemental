defmodule Elemental.Storybook.Components.Feedback.Status do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Feedback.Status.status/1

  def variations do
    [
      %Variation{id: :default}
    ]
  end
end
