defmodule Elemental.Storybook.Components.Loading do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Loading.loading/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{}
      },
      %Variation{
        id: :ball,
        attributes: %{type: "ball"}
      },
      %Variation{
        id: :bars,
        attributes: %{type: "bars"}
      },
      %Variation{
        id: :dots,
        attributes: %{type: "dots"}
      },
      %Variation{
        id: :infinity,
        attributes: %{type: "infinity"}
      },
      %Variation{
        id: :ring,
        attributes: %{type: "ring"}
      },
      %Variation{
        id: :spinner,
        attributes: %{type: "spinner"}
      }
    ]
  end
end
