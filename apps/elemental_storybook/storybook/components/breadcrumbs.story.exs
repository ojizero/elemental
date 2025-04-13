defmodule Elemental.Storybook.Components.Breadcrumbs do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Breadcrumbs.breadcrumbs/1

  def variations do
    [
      %Variation{
        id: :breadcrumbs,
        slots: [
          "<:item>Foo</:item>",
          "<:item>Bar</:item>",
          "<:item><a href=\"https://kagi.com\">A link</a></:item>"
        ]
      }
    ]
  end
end
