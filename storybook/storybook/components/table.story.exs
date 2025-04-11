defmodule Elemental.Storybook.Components.Table do
  use PhoenixStorybook.Story, :component

  def imports, do: [{Elemental.Table, header: 1, body: 1}]

  def function, do: &Elemental.Table.table/1

  def variations do
    [
      %Variation{
        id: :sample,
        slots: [
          """
          <.header>
            <:cell>Foo</:cell>
            <:cell>Bar</:cell>
          </.header>
          """,
          """
          <.body data={[
            {"Row 1 foo", "Row 1 bar"},
            {"Row 2 foo", "Row 2 bar"},
          ]}>
            <:cell :let={{foo, _bar}}>{foo}</:cell>
            <:cell :let={{_foo, bar}}>{bar}</:cell>
          </.body>
          """
        ]
      }
    ]
  end
end
