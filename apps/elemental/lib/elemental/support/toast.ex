defmodule Elemental.Support.Toast do
  @moduledoc false

  use Elemental.Component

  alias Elemental.Actions.Button
  alias Elemental.Feedback.Alert
  alias Elemental.Feedback.Loading

  attr :id, :string, required: true
  attr :message, :string, required: true
  attr :outline, :boolean, default: false
  attr :dash, :boolean, default: false
  attr :soft, :boolean, default: false
  attr :clear_alert_event, :string, default: nil

  def alert_message(assigns) do
    assigns = normalize_alert_message(assigns)

    ~H"""
    <Alert.alert id={@id} type={@type} outline={@outline} dash={@dash} soft={@dash}>
      <.alert_icon type={@type} />
      <div>
        <h3 :if={@title} class="font-semibold">
          {@title}
        </h3>
        {@content}
      </div>
      <.close_button target_id={@id} type={@type} clear_alert_event={@clear_alert_event} />
    </Alert.alert>
    """
  end

  attr :outline, :boolean, default: false
  attr :dash, :boolean, default: false
  attr :soft, :boolean, default: false

  def phoenix_messages(assigns) do
    ~H"""
    <Alert.alert
      id="client-error"
      type="error"
      outline={@outline}
      dash={@dash}
      soft={@dash}
      phx-disconnected={JS.remove_attribute("hidden", to: ".phx-client-error #client-error")}
      phx-connected={JS.set_attribute({"hidden", true}, to: "#client-error")}
      hidden
    >
      <.alert_icon type="error" />
      <div>
        <h3 class="font-semibold">
          We can't find the internet
        </h3>
        Attempting to reconnect
      </div>
      <Loading.loading type="ring" />
    </Alert.alert>
    <Alert.alert
      id="server-error"
      type="error"
      outline={@outline}
      dash={@dash}
      soft={@dash}
      phx-disconnected={JS.remove_attribute("hidden", to: ".phx-server-error #server-error")}
      phx-connected={JS.set_attribute({"hidden", true}, to: "#server-error")}
      hidden
    >
      <.alert_icon type="error" />
      <div>
        <h3 class="font-semibold">
          Something went wrong!
        </h3>
        Hang in there while we get back on track
      </div>
      <Loading.loading type="spinner" />
    </Alert.alert>
    """
  end

  attr :target_id, :string, required: true
  attr :type, :string, values: [nil, "info", "success", "warning", "error"], default: nil
  attr :clear_alert_event, :string, default: nil

  defp close_button(assigns) do
    ~H"""
    <Button.button
      type="button"
      color="ghost"
      class="hover:btn-neutral"
      shape="circle"
      size="xs"
      phx-click={close_alert(@target_id, @type, @clear_alert_event)}
    >
      <.x_mark />
    </Button.button>
    """
  end

  defp close_alert(js \\ %JS{}, id, type, alert_cleared_event) do
    selector = "##{Phoenix.HTML.css_escape(id)}"

    js
    # The hidden attribute also removes it from screen readers
    # and other assistive technologies.
    |> JS.set_attribute({"hidden", true}, to: "#{selector}")
    |> maybe_push_event(alert_cleared_event, value: %{id: id, kind: type})
  end

  defp maybe_push_event(js, nil, _opts), do: js
  defp maybe_push_event(js, event, opts), do: JS.push(js, event, opts)

  # TODO: how can we allow externals to call us with a component instead of just strings?
  defguardp is_message_content(message) when is_binary(message)

  defp normalize_alert_message(%{message: content} = assigns)
       when is_message_content(content) do
    assigns
    |> assign(type: nil)
    |> assign(:title, nil)
    |> assign(:content, content)
  end

  defp normalize_alert_message(%{message: {level, content}} = assigns)
       when is_binary(level) and is_message_content(content) do
    assigns
    |> assign(type: level)
    |> assign(:title, humanize(level))
    |> assign(:content, content)
  end

  defp normalize_alert_message(%{message: {level, title, content}} = assigns)
       when is_binary(level) and is_binary(title) and is_message_content(content) do
    assigns
    |> assign(type: level)
    |> assign(:title, title)
    |> assign(:content, content)
  end

  defp normalize_alert_message(%{message: {"phx-" <> level, content}} = assigns)
       when is_message_content(content) do
    assigns
    |> assign(type: level)
    |> assign(:title, humanize(level))
    |> assign(:content, content)
    # NOTE: this way flash messages are not controlled by
    #       consumer I think this is okay but is it?
    |> assign(:clear_alert_event, "lv:clear-flash")
  end

  defp normalize_alert_message(%{message: {"phx-" <> level, content}} = assigns)
       when is_message_content(content) do
    assigns
    |> assign(type: level)
    |> assign(:title, humanize(level))
    |> assign(:content, content)
    # NOTE: this way flash messages are not controlled by
    #       consumer I think this is okay but is it?
    |> assign(:clear_alert_event, "lv:clear-flash")
  end

  defp normalize_alert_message(%{message: {"phx-" <> level, title, content}} = assigns)
       when is_binary(title) and is_message_content(content) do
    assigns
    |> assign(type: level)
    |> assign(:title, title)
    |> assign(:content, content)
    # NOTE: this way flash messages are not controlled by
    #       consumer I think this is okay but is it?
    |> assign(:clear_alert_event, "lv:clear-flash")
  end

  # SVGs in place for Heroicons used
  #
  # This omits the need to bundle Heroicons while allowing it's use

  attr :type, :string, values: ~w(info success warning error), required: true

  defp alert_icon(%{type: "success"} = assigns) do
    ~H"""
    <%!-- Heroicon check-circle --%>
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
    """
  end

  defp alert_icon(%{type: "warning"} = assigns) do
    ~H"""
    <%!-- Heroicon exclamation-triangle --%>
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
        d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z"
      />
    </svg>
    """
  end

  defp alert_icon(%{type: "error"} = assigns) do
    ~H"""
    <%!-- Heroicon x-circle --%>
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
        d="m9.75 9.75 4.5 4.5m0-4.5-4.5 4.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
      />
    </svg>
    """
  end

  defp alert_icon(assigns) do
    ~H"""
    <%!-- Heroicon information-circle --%>
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
    """
  end

  defp x_mark(assigns) do
    ~H"""
    <%!-- Heroicon x-mark --%>
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="size-6"
    >
      <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
    </svg>
    """
  end
end
