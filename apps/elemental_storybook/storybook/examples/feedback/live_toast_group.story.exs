defmodule Elemental.Storybook.Components.Feedback.Live.ToastGroup do
  use PhoenixStorybook.Story, :example

  import Elemental.Actions.Button
  import Elemental.Feedback.Toast
  import Elemental.DataInput.Field

  alias Elemental.Feedback.Live.ToastGroup

  def doc do
    """
    Sample implementation using the live toast group.

    Generally speaking the implementation consists of passing the `live`
    attribute the `Elemental.Feedback.Toast.toast_group/1` component
    which converts it to use the live component defined in
    `Elemental.Feedback.Toast`.

    This example essentially boils down to a simple

        <.toast_group live />

    wrapped in a form to allow you to interact with the toast group live
    system and send messages through it.

    For more details on the functionality provided please checkout the
    documentation of `Elemental.Feedback.Toast.toast_group/1`
    component and the `Elemental.Feedback.Live.ToastGroup`
    live component and module function.
    """
  end

  @placements ~w(top-start    top-center    top-end
                 middle-start middle-center middle-end
                 bottom-start bottom-center bottom-end)

  attr :placement, :string, default: "top-end"

  @impl Phoenix.LiveView
  def render(assigns) do
    assigns = assign(assigns, :placements, @placements)

    ~H"""
    <.toast_group live placement={@placement} />

    <div>
      <.form for={%{}} phx-submit="send-toast" phx-change="changed">
        <div class="flex flex-col gap-2 w-fit">
          <.field
            type="dropdown"
            name="placement"
            options={@placements}
            value="top-end"
            disable-validator
          >
            <:label value="Placement" />
          </.field>
          <.field
            type="dropdown"
            name="type"
            value=""
            options={[
              {"Default", ""},
              {"Success", "success"},
              {"Info", "info"},
              {"Warning", "warning"},
              {"Error", "error"}
            ]}
            disable-validator
          >
            <:label value="Type" />
          </.field>
          <.field name="title" placeholder="The message title" disable-validator>
            <:label value="Title" />
          </.field>
          <.field name="notice" placeholder="The message content" disable-validator>
            <:label value="Content" />
          </.field>
          <.button>Send toast</.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event(event, params, socket)

  def handle_event("send-toast", %{"notice" => message, "title" => "", "type" => ""}, socket) do
    ToastGroup.send_message(message)
    {:noreply, socket}
  end

  def handle_event("send-toast", %{"notice" => message, "title" => title, "type" => ""}, socket)
      when title != "" do
    ToastGroup.send_message({nil, title, message})
    {:noreply, socket}
  end

  def handle_event("send-toast", %{"notice" => message, "title" => "", "type" => level}, socket)
      when level != "" do
    ToastGroup.send_message({level, message})
    {:noreply, socket}
  end

  def handle_event(
        "send-toast",
        %{"notice" => message, "title" => title, "type" => level},
        socket
      )
      when title != "" and level != "" do
    ToastGroup.send_message({level, title, message})
    {:noreply, socket}
  end

  def handle_event(
        "changed",
        %{"_target" => ["placement" | _whatever], "placement" => placement},
        socket
      ) do
    {:noreply, assign(socket, :placement, placement)}
  end

  def handle_event(_whatever, _params, socket) do
    {:noreply, socket}
  end
end
