defmodule Elemental.Feedback.Live.ToastGroup do
  @moduledoc """
  A live/stateful toast component, allows for more dynamic toasts granting
  consumers the ability to send server events to display or dismiss
  toasts based on events.

  Renders a live/stateful `Elemental.Feedback.Toast.toast_group/1` and attaches
  multiple handler to allow for dynamic handling of toast messages.

  ## Usage

  In your application where you want to add the toast sub-system simply add

      <.live_component module={Elemental.Feedback.Live.ToastGroup} />

  Additionally, the main `Elemental.Feedback.Toast.toast_group/1` supports the
  `live` attribute allowing it to act as a pass through, this simplifies
  things to doing

      <Elemental.Feedback.Toast.toast_group live>

  The second form can further be simplified if you `use Elemental` to just

      <.toast_group live />

  To send a message you can use the `send_message/2` function or you can
  send a list of messages by using the `send_messages/2` function.

  Those functions abstract away all the details needed and require you
  only optionally pass it an `id` option to the live toast group if
  you have many in your application.

      defmodule MyPage do
        # your normal app setup

        use Elemental
        # or alias Elemental.Feedback.Live.ToastGroup

        # your normal page implementation

        def handle_event("some-event", params, socket) do
          # handle your event normally
          # now you can send the user a toast by calling
          ToastGroup.send_message("Some notice to the user")
          # remainder of your event handler
        end
      end

  ## Phoenix' flash system

  You can also pass the `flash` attribute bound to Phoenix' flash system
  and would carry over the same behaviour as defined in the stateless
  variant, i.e. it should interoperate with it normally without
  any additional work form the consumer side.

  Phoenix' flashes are rendered immediately after any messages passed/sent
  over via the `Elemental.Feedback.Live.ToastGroup` module.
  """

  use Elemental.Component, :live

  import Elemental.Feedback.Toast

  @default_toast_group_id "toast-group"
  @toast_message_clear_event "el:toast-message-clear"

  ## Client/external API

  @type level :: :info | :warning | :success | :error | String.t()
  @type message :: String.t() | {level, String.t()} | {level, String.t(), String.t()}

  @doc """
  Send a message to the associated live toast group.

  Accepts a single message in the format accepted by `Elemental.Feedback.Toast.toast_group/1`.

  See `send_message/4` for details.
  """
  @spec send_message(message, keyword) :: :ok
  def send_message(message, opts \\ [])

  def send_message(message, opts)
      when is_binary(message),
      do: send_message(nil, nil, message, opts)

  def send_message({level, message}, opts)
      when is_binary(message),
      do: send_message(level, nil, message, opts)

  def send_message({level, title, message}, opts)
      when is_binary(message),
      do: send_message(level, title, message, opts)

  @doc """
  Send a list of messages to the associated live toast group.

  Accepts a list of messages in the format accepted by `Elemental.Feedback.Toast.toast_group/1`.

  See `send_message/2` for details.
  """
  @spec send_messages(list(message), keyword) :: :ok
  def send_messages(messages, opts), do: Enum.each(messages, &send_message(&1, opts))

  @doc """
  Send a message to the associated live toast group.

  Defaults to sending the message to a live component identified by the ID
  `#{@default_toast_group_id}`, if you're using a custom ID pass the
  `:id` option.
  """
  @spec send_message(level | nil, String.t() | nil, String.t(), keyword) :: :ok
  def send_message(level, title, message, opts \\ []) when is_binary(message) do
    id = Keyword.get(opts, :id, @default_toast_group_id)
    level = if is_atom(level), do: Atom.to_string(level), else: level
    send_update(__MODULE__, id: id, message: {level, title, message})
  end

  @doc """
  Drop-in for Phoenix' `Phoenix.LiveView.put_flash/3` that instead sends the
  message over via the handles of the live toast group.

  This captures the original behaviour and doesn't set the Phoenix flash
  related assigns instead passing it directly (and as is) to the main
  `Elemental.Feedback.Toast.toast_group/1` component as a message.
  """
  @spec put_flash(Phoenix.LiveView.Socket.t(), String.t() | atom, String.t()) ::
          Phoenix.LiveView.Socket.t()
  def put_flash(socket, kind, message) do
    send_message({kind, message})

    socket
  end

  ## Live component

  attr :id,
       :string,
       default: @default_toast_group_id,
       doc: "The ID used for the toast group component."

  # attr :flash,
  #      :map,
  #      default: %{},
  #      doc: """
  #      In order to provide compatibility with Phoenix' flash subsystem we accept a
  #      flash attribute as defined by Phoenix and do render it right after the
  #      messages passed in `Elemental.Feedback.Toast.toast_group/1` style.
  #
  #      Flash messages will only emit an `lv:clear-flash` event when cleared without
  #      a predefined target. This is to stay inline with how Phoenix expects those
  #      to behave.
  #      """

  attr :placement,
       :string,
       values: ~w(top-start    top-center    top-end
                  middle-start middle-center middle-end
                  bottom-start bottom-center bottom-end),
       default: "top-end",
       doc: "The positioning of the toast stack."

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

  @doc false
  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div id={container_id(@id)}>
      <.toast_group
        id={@id}
        dash={@dash}
        soft={@soft}
        flash={@flash}
        outline={@outline}
        phx-update="stream"
        phx-target={@myself}
        on-clear={@on_clear}
        placement={@placement}
        messages={@streams.messages}
        phoenix-errors={@phoenix_errors}
      />
    </div>
    """
  end

  @doc false
  @impl Phoenix.LiveComponent
  def mount(socket) do
    socket
    |> stream_configure(:messages, dom_id: fn _item -> random() end)
    |> stream(:messages, [])
    |> assign(:on_clear, @toast_message_clear_event)
    |> assign(:phoenix_errors, socket.assigns[:"phoenix-errors"])
    |> then(&{:ok, &1})
  end

  @doc false
  @impl Phoenix.LiveComponent
  def update(assigns, socket)

  def update(%{message: message}, socket) do
    socket
    |> stream_insert(:messages, message)
    |> then(&{:ok, &1})
  end

  def update(assigns, socket),
    do: {:ok, assign(socket, assigns)}

  @doc false
  @impl Phoenix.LiveComponent
  def handle_event(event, params, socket)

  def handle_event(@toast_message_clear_event, %{"id" => id}, socket) do
    socket
    |> stream_delete_by_dom_id(:messages, id)
    |> then(&{:noreply, &1})
  end

  def handle_event(_event, _params, socket), do: {:noreply, socket}

  defp container_id(id), do: "#{id}-component-root"
end
