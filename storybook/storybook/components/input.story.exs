defmodule Elemental.Storybook.Components.Input do
  use PhoenixStorybook.Story, :component

  @input_types ~w(checkbox color date datetime-local email file hidden image month
                  number password radio range search tel text time url week)

  def function, do: &Elemental.Input.input/1

  def variations do
    [
      %Variation{
        id: :input,
        attributes: %{placeholder: "Simplest input"}
      },
      %VariationGroup{
        id: :defaults,
        description: "All possible input types",
        variations:
          Enum.map(@input_types, fn type ->
            %Variation{
              id: :"#{type}",
              attributes: %{type: type}
            }
          end)
      }
    ]
  end
end
