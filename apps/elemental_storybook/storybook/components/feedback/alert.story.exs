defmodule Elemental.Storybook.Components.Feedback.ToastGroup do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Feedback.Alert.alert/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{},
        slots: [
          "Some arbitrary message in default style"
        ]
      },
      %Variation{
        id: :success_with_icon,
        attributes: %{type: "success"},
        slots: [
          """
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="size-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
            />
          </svg>
          """,
          "Icons can be added too!"
        ]
      },
      %Variation{
        id: :arbitrary_content,
        attributes: %{type: "info"},
        slots: [
          """
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="size-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z"
            />
          </svg>
          """,
          """
          <div>
            Content can contain
            <a href="#">any valid HTML</a>
            allowed under a
            <code>&lt;div&gt;</code>
          </div>
          """
        ]
      }
      # %Variation{
      #   id: :info,
      #   attributes: %{
      #     messages: [{"info", "Is this informative?"}],
      #     "phoenix-errors": false
      #   }
      # },
      # %Variation{
      #   id: :warning,
      #   attributes: %{
      #     messages: [{"warning", "Hopefully it's not a bad API!"}],
      #     "phoenix-errors": false
      #   }
      # },
      # %Variation{
      #   id: :error,
      #   attributes: %{
      #     messages: [{"error", "Hoping this isn't a failure!"}],
      #     "phoenix-errors": false
      #   }
      # },
      # %Variation{
      #   id: :stacked,
      #   attributes: %{
      #     messages: [
      #       "Hey!",
      #       {"success", "These toasts"},
      #       {"success", "can actually"},
      #       {"info", "be arbitrarily"},
      #       {"warning", "stacked,"},
      #       {"error", "is that cool?"}
      #     ],
      #     "phoenix-errors": false
      #   }
      # },
      # %Variation{
      #   id: :supports_flash,
      #   attributes: %{
      #     messages: [],
      #     flash: %{
      #       info: "My info flash!",
      #       error: "My error flash!"
      #     },
      #     "phoenix-errors": false
      #   }
      # }
    ]
  end
end
