defmodule Elemental.Feedback.Toast do
  @moduledoc """
  An abstraction built on top of Daisy's toast component for building
  toast messages, flash messages, and more.

  Provides a set of dead/stateless components for use to operate displaying
  informative messages, with a simplified API that augments Phoenix'
  flashes.
  """

  use Elemental.Component

  import Elemental.Support.Toast

  # TODO: close button
  # TODO: integrate with Phoenix flashes
  # TODO: flash & flash groups

  attr :placement,
       :string,
       values: ~w(top-start    top-center    top-end
                  middle-start middle-center middle-end
                  bottom-start bottom-center bottom-end),
       default: "top-end",
       doc: "The positioning of the toast stack."

  attr :id, :string, default: "toast"

  slot :inner_block, required: true

  @doc """
  The primary toast component, this guarantees a content to be displayed
  in the provided placement on the page.

  This is meant more as a building block for composing more complete/complex
  toast messages/overlays.

  You probably want to use `toast_group/1` if you want to display simple messages.
  """
  def toast(assigns) do
    [vertical, horizontal] = String.split(assigns.placement, "-")
    assigns = assign(assigns, vertical: vertical, horizontal: horizontal)

    ~H"""
    <div
      id={@id}
      class={[
        "toast",
        "toast-#{@vertical}",
        "toast-#{@horizontal}",
        "z-100"
      ]}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id, :string, default: "toast-messages"

  attr :messages,
       :list,
       #  default: [],
       required: true,
       doc: "[string|{string, string}]"

  attr :"auto-close",
       :boolean,
       default: true,
       doc: ""

  # attr :"data-duration",
  #      :integer,
  #      default: 2_000,
  #      doc: "MS"

  attr :placement,
       :string,
       values: ~w(top-start    top-center    top-end
                  middle-start middle-center middle-end
                  bottom-start bottom-center bottom-end),
       default: "top-end",
       doc: "The positioning of the toast stack."

  attr :outline,
       :boolean,
       default: false,
       doc: "Render the alert in an outline style."

  attr :dash,
       :boolean,
       default: false,
       doc: "Render the alert in dash style."

  attr :soft,
       :boolean,
       default: false,
       doc: "Render the alert in soft style."

  attr :"phoenix-errors",
       :boolean,
       default: true,
       doc: ""

  @doc """
  Provides an abstraction on top of `toast/1` for displaying a list alerts
  for the user. Relies on `Elemental.Feedback.Alert.alert/1` for
  rendering the specific messages under the hood.

  > This component is intended for building toast/flash messaging systems.

  > This component displays Phoenix' client and server errors by default.

  This component doesn't respect Phoenix' default flashes API, for that use
  instead the `flashes/1` component which provides an adapter layer to
  allow seamless integration with Phoenix' flash system.

  """
  def toast_group(assigns) do
    assigns =
      assigns
      |> update(:messages, fn messages ->
        messages
        |> List.wrap()
        |> Enum.map(fn
          {level, title, message} -> {level, title, message}
          {level, message} -> {level, humanize(level), message}
          message -> {nil, nil, message}
        end)
      end)
      |> assign(:phoenix_errors, fn %{"phoenix-errors": phoenix_errors} -> phoenix_errors end)

    # TODO: make sure it is on top of everything
    # TODO: support streams
    # TODO: live version (is this really needed??)
    # TODO: compatibility with phoenix flashes
    # TODO: auto close alerts

    ~H"""
    <.toast id={@id} placement={@placement}>
      <.alert_message
        :for={{level, title, message} <- @messages}
        type={level}
        title={title}
        message={message}
        outline={@outline}
        dash={@dash}
        soft={@dash}
      />
      <.phoenix_messages :if={@phoenix_errors} outline={@outline} dash={@dash} soft={@dash} />
    </.toast>
    """
  end

  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"
  attr :flash, :map, required: true, doc: "the map of flash messages"

  @doc "Adapts Phoenix' flash message system with `toast_group/1`."
  def flashes(assigns) do
    ~H"""
    <.toast_group id={@id} messages={Map.to_list(@flash)} phoenix-errors />
    """
  end
end
