defmodule Elemental.Storybook.Components.Navigation.Tabs do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Navigation.Tabs.tabs/1

  def imports do
    [
      {Elemental.Navigation.Tabs, tab: 1},
      {Elemental.Actions.Button, button: 1},
      {Elemental.Actions.Swap, swap: 1},
      {Elemental.Feedback.Loading, loading: 1}
    ]
  end

  def variations do
    [
      %Variation{
        id: :tabbed_view,
        attributes: %{class: "w-full"},
        slots: [
          """
          <.tab selected>
            <:title>Tab 1</:title>
            Content 1
          </.tab>
          """,
          """
          <.tab>
            <:title>Tab 2</:title>
            Inner content can be any valid HTML including
            <.button type="button">buttons</.button>
            or swaps
            <.swap>
              <:on>ON</:on>
              <:off><.loading /></:off>
            </.swap>!
          </.tab>
          """,
          """
          <.tab>
            <:title>Tab 3</:title>
            Anything allowed under a <code>&lt;div&gt;</code> goes!
          </.tab>
          """
        ]
      }
    ]
  end
end
