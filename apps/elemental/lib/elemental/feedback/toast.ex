defmodule Elemental.Feedback.Toast do
  @moduledoc """
  An abstraction built on top of Daisy's toast component for building
  toast messages, flash messages, and more.

  Provides a set of dead/stateless components for use to operate displaying
  informative messages, with a simplified API that augments Phoenix'
  flashes.

  ## Usage

  The most bare bones component provided is the `toast/1` component
  which is meant as a building block container for placing toasts
  generally speaking based on Daisy's `toast` component

      <.toast>
        You toast content here
      </.toast>

  For toast message use cases we provide the `toast_group/1` component
  which given a list of messages will display them stacked in a `toast/1`
  component under the `Elemental.Feedback.Alert.alert/1` component.

      <.toast_group messages={["Some message"]} />

  Additionally we provide a compatibility component `flash_group/1`
  as a drop in for Phoenix' generated component

      <.flash_group flash={@flash} />

  ## Live component

  We provide a live/stateful component for toast groups under
  `Elemental.Feedback.Live.ToastGroup`, this can be accessed
  by passing the `live` attribute to `toast_group/1`

      <.toast_group live />

  The live variant allows for sending messages from the server side
  programmatically/dynamically.
  """

  use Elemental.Component

  import Elemental.Support.Toast

  alias Elemental.Feedback.Live.ToastGroup

  attr :id, :string, default: "toast"

  attr :placement,
       :string,
       values: ~w(top-start    top-center    top-end
                  middle-start middle-center middle-end
                  bottom-start bottom-center bottom-end),
       default: "top-end",
       doc: "The positioning of the toast stack."

  slot :inner_block, required: true

  attr :class, :any, default: nil, doc: false
  attr :rest, :global

  @doc """
  The primary toast component, this guarantees a content to be displayed
  in the provided placement on the page.

  This is meant more as a building block for composing more complete/complex
  toast messages/overlays.

  You probably want to use `toast_group/1` if you want to display simple
  messages.

  ## Caveat

  Note that if you place two toasts with the same placement there will
  be no guarantee from the component on which comes on top, probably
  the second to show in the DOM tree will.

  This is by design as it's intended to use one toast per placement
  (or even per page).
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
        "z-100",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :id,
       :string,
       default: "toast-group",
       doc: "The ID used for the toast group component."

  attr :live,
       :boolean,
       default: false,
       doc: """
       Enables the LiveComponent to be rendered in place of the stateless/dead
       component which is the default.

       If enabled you can use `Elemental.Feedback.Live.ToastGroup` module to interact
       dynamically with the toast group and send messages from the server side
       dynamically.

       Enabling this disables support for passing `messages`, `on-clear` and the global
       attributes.
       """

  attr :messages,
       :any,
       doc: """
       The list of messages to display in the group, ignored if `live` is enabled.
       Required otherwise.

       ## Type

       Accepts either a list or a `Phoenix.LiveView.LiveStream`, with each item standing
       for a message and must be one type as one of the following;

       1. `String.t` indicating the message is simply some text context to display. No
          title is displayed for it and it will be shown in the default alert style.
       2. `{String.t, String.t}` indicating a message where the first item is the alert type
          to use, as defined in `Elemental.Feedback.Alert.alert/1`, and the second is
          the message content itself. The alert level/type will be used as title.
       3. `{String.t, String.t, String.t}` indicating a message where the first item is the
          alert type to use, as defined in `Elemental.Feedback.Alert.alert/1`, the second
          is the message's title to display, and the third indicating the message content
          itself.

       Mixing those types is in one list of messages is allowed an will be normalized.

       > This list of messages can also be provided from a LiveView stream, where each item
       > coming from the stream must respect the defined typings for the message items.
       """

  attr :flash,
       :map,
       default: %{},
       doc: """
       In order to provide compatibility with Phoenix' flash subsystem we accept a
       flash attribute as defined by Phoenix and do render it right after the
       messages passed in `Elemental.Feedback.Toast.toast_group/1` style.

       Flash messages will ignore the `on-clear` and `phx-target` and instead emit
       an `lv:clear-flash` event when cleared without a predefined target. This
       is to stay inline with how Phoenix expects those to behave.
       """

  attr :placement,
       :string,
       values: ~w(top-start    top-center    top-end
                  middle-start middle-center middle-end
                  bottom-start bottom-center bottom-end),
       default: "top-end",
       doc: "The positioning of the toast stack."

  attr :"on-clear",
       :string,
       default: nil,
       doc: """
       The event to emit on closing of an alert

       > Ignored if `live` is enabled.
       """

  attr :"phoenix-errors",
       :boolean,
       default: true,
       doc: "Controls showing Phoenix' client and server errors."

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

  attr :"phx-target", :any, default: nil, doc: false
  attr :"phx-update", :any, default: nil, doc: false

  @doc """
  Provides an abstraction on top of `toast/1` for displaying a list alerts
  for the user. Relies on `Elemental.Feedback.Alert.alert/1` for
  rendering the specific messages under the hood.

  > This component is intended for building toast/flash messaging systems.

  This component doesn't respect Phoenix' default flashes API by default,
  however you can pass Phoenix' flash into the `flash` attribute to
  display Phoenix' flashes inlined, immediately after normal
  messages. For a more seamless integration you can use
  the `flash_group/1` component.

  ## Caveats

  Inherent to the `toast/1` component which this component is built of, it
  won't play nice to having another toast group with messages overlapping
  it and the behaviour won't be controlled by Elemental in such cases.

  If you want to have multiple toast groups on the same placement you're
  better off building on top of `toast/1` directly instead.

  ## Phoenix flash system integration

  To allow seamless interoperability with Phoenix' flash system, if passed
  Phoenix' flash messages via the `flash` attribute.

  Any message originating from Phoenix' flash system will ignore the any
  provided value for `on-clear` and instead send the Phoenix event of
  `lv:clear-flash`.

  Also, messages originating from Phoenix' flash subsystem will be rendered immediately
  after the messages formatted via `Elemental.Feedback.Toast.toast_group/1` and in
  an identical styling via the `Elemental.Feedback.Alert.alert/1` component.

  ## Phoenix' client and server errors

  This component will display Phoenix' client and server errors by default, these
  errors are non-closeable and will stay until the client side reconnects
  properly with the server side. This can be controlled by the
  `phoenix-errors` attribute. Note these messages won't
  trigger `on-clear` events when disappearing.
  """
  def toast_group(assigns)

  def toast_group(%{live: true} = assigns),
    do: ~H"<.live_component module={ToastGroup} {assigns} />"

  def toast_group(assigns) do
    assigns = normalize_toast_group(assigns)

    # TODO: auto close alerts
    # TODO: add transition when hiding (possibly go back to JS.hide ?)

    ~H"""
    <.toast id={@id} placement={@placement} phx-update={@phx_update}>
      <.alert_message
        :for={{id, message} <- @messages}
        id={id}
        message={message}
        outline={@outline}
        dash={@dash}
        soft={@soft}
        clear_alert_event={@clear_alert_event}
        phx-target={@phx_target}
      />
      <.alert_message
        :for={{kind, message} <- Map.to_list(@flash)}
        id={"#{random()}-phx-#{kind}"}
        message={{"#{kind}", message}}
        outline={@outline}
        dash={@dash}
        soft={@soft}
        clear_alert_event="lv:clear-flash"
      />
      <.phoenix_messages :if={@phoenix_errors} outline={@outline} dash={@dash} soft={@soft} />
    </.toast>
    """
  end

  attr :id, :string, default: nil
  attr :flash, :map, required: true

  @doc "Drop in for Phoenix' flash group."
  def flash_group(assigns),
    do: ~H"<.toast_group id={@id} messages={[]} flash={@flash} phoenix-errors />"

  defp normalize_toast_group(assigns) do
    assigns
    |> normalize_messages()
    |> assign(:phoenix_errors, assigns[:"phoenix-errors"])
    |> assign(:clear_alert_event, assigns[:"on-clear"])
    |> assign(:phx_target, assigns[:"phx-target"])
    |> assign(:phx_update, assigns[:"phx-update"])
  end

  defp normalize_messages(assigns) do
    update(assigns, :messages, fn
      # Keep streams as is, however if given an Enum we'll add an ID
      # to normalize how we handle both down the line.
      %Phoenix.LiveView.LiveStream{} = messages -> messages
      messages -> Enum.map(messages, &normalize_message/1)
    end)
  end

  defp normalize_message(message), do: {random(), message}
end
