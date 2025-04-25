defmodule Elemental.Storybook.Components.Feedback.ToastGroup do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.Feedback.Toast.toast_group/1

  def template do
    """
    <div
      id="container_:variation_id"
      class="space-y-2"
      phx-mounted={JS.toggle_attribute({"hidden", true}, to: "#:variation_id > .alert")}
      psb-code-hidden
    >
      <button
        class="btn"
        id="show-success-:variation_id"
        phx-click={JS.remove_attribute("hidden", to: "#:variation_id > .alert")}
      >
        Show the toast
      </button>
      <div class="mt-2">
        <.psb-variation/>
      </div>
    </div>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          messages: ["Default message."],
          "phoenix-errors": false
        }
      },
      %Variation{
        id: :success,
        attributes: %{
          messages: [{"success", "My successful message!"}],
          "phoenix-errors": false
        }
      },
      %Variation{
        id: :info,
        attributes: %{
          messages: [{"info", "Is this informative?"}],
          "phoenix-errors": false
        }
      },
      %Variation{
        id: :warning,
        attributes: %{
          messages: [{"warning", "Hopefully it's not a bad API!"}],
          "phoenix-errors": false
        }
      },
      %Variation{
        id: :error,
        attributes: %{
          messages: [{"error", "Hoping this isn't a failure!"}],
          "phoenix-errors": false
        }
      },
      %Variation{
        id: :stacked,
        attributes: %{
          messages: [
            "Hey!",
            {"success", "These toasts"},
            {"success", "can actually"},
            {"info", "be arbitrarily"},
            {"warning", "stacked,"},
            {"error", "is that cool?"}
          ],
          "phoenix-errors": false
        }
      },
      %Variation{
        id: :supports_flash,
        attributes: %{
          messages: [],
          flash: %{
            info: "My info flash!",
            error: "My error flash!"
          },
          "phoenix-errors": false
        }
      }
    ]
  end
end
