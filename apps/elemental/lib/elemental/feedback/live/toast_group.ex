defmodule Elemental.Feedback.Live.ToastGroup do
  @moduledoc """
  A live/stateful toast component, allows for more dynamic toasts granting
  consumers the ability to send server events to display or dismiss
  toasts based on events.

  Renders a live/stateful `Elemental.Feedback.Toast.toast_group/1` and attaches
  multiple handler to allow for dynamic handling of toast messages.
  """

  use Elemental.Component, :live

  import Elemental.Feedback.Toast

  @default_toast_group_id "live-toast-messages"

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
      when is_binary(title) and is_binary(message),
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
  """
  @spec put_flash(Phoenix.LiveView.Socket.t(), String.t() | atom, String.t()) ::
          Phoenix.LiveView.Socket.t()
  def put_flash(socket, kind, message) do
    send_message({kind, message})

    socket
  end

  ## Live component

  attr :id, :string, default: @default_toast_group_id

  attr :messages,
       :list,
       default: [],
       doc: "[string|{string, string}]"

  attr :"auto-close",
       :boolean,
       default: true,
       doc: ""

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

  @doc false
  @impl Phoenix.LiveComponent
  def render(assigns) do
    # TODO: convert this to use streams // requires support of streams in main toast group component
    ~H"""
    <%!-- TODO: pass everything here --%>
    <%!-- NOTE: may need to redo it to simplify streaming --%>
    <.toast_group messages={@messages} />
    """
  end

  @doc false
  @impl Phoenix.LiveComponent
  def mount(socket), do: {:ok, socket}

  @doc false
  @impl Phoenix.LiveComponent
  def update(_assigns, socket), do: {:ok, socket}

  @doc false
  @impl Phoenix.LiveComponent
  def handle_event(_event, _params, socket), do: {:noreply, socket}
end
