defmodule Elemental.Storybook.Components.Dropdown do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Dropdown.dropdown/1

  @options ["Foo", "Bar", {"Baz", "Baz Value"}]

  def variations do
    [
      %Variation{
        id: :single_select,
        attributes: %{prompt: "Dropdown", options: @options}
      },
      %Variation{
        id: :multi_select,
        attributes: %{prompt: "Dropdown", options: @options, multi: true}
      },
      %Variation{
        id: :single_select_with_preselection,
        attributes: %{
          prompt: "Dropdown",
          options: @options,
          multi: false,
          # Can be a single item as well
          value: ["Baz Value"]
        }
      },
      %Variation{
        id: :multi_select_with_preselection,
        attributes: %{
          prompt: "Dropdown",
          options: @options,
          multi: true,
          value: ["Foo", "Baz Value"]
        }
      },
      %Variation{
        id: :single_select_with_search,
        attributes: %{
          prompt: "Dropdown",
          options: @options,
          searchable: true
        }
      },
      %Variation{
        id: :multi_select_with_search_inlined,
        attributes: %{
          prompt: "Dropdown",
          options: @options,
          multi: true,
          searchable: true,
          "searchable-inline": true
        }
      }
    ]
  end
end
