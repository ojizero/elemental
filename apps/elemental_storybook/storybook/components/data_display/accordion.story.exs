defmodule Elemental.Storybook.Components.DataDisplay.Accordion do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.DataDisplay.Accordion.accordion/1

  def variations do
    [
      %Variation{
        id: :simple,
        attributes: %{name: "base"},
        slots: [
          """
          <:item title="How do I create an account?">
            Click the "Sign Up" button in the top right corner and follow the registration process.
          </:item>
          """,
          """
          <:item title="I forgot my password. What should I do?">
            Click on "Forgot Password" on the login page and follow the instructions sent to your email.
          </:item>
          """,
          """
          <:item title="How do I update my profile information?">
            Go to "My Account" settings and select "Edit Profile" to make changes.
          </:item>
          """
        ]
      },
      %Variation{
        id: :with_arrow_icon,
        attributes: %{name: "arrow-icon", indicator: "arrow"},
        slots: [
          """
          <:item title="How do I create an account?">
            Click the "Sign Up" button in the top right corner and follow the registration process.
          </:item>
          """,
          """
          <:item title="I forgot my password. What should I do?">
            Click on "Forgot Password" on the login page and follow the instructions sent to your email.
          </:item>
          """,
          """
          <:item title="How do I update my profile information?">
            Go to "My Account" settings and select "Edit Profile" to make changes.
          </:item>
          """
        ]
      }
    ]
  end
end
