defmodule Elemental.Support.Toast do
  @moduledoc false

  use Elemental.Component

  import Elemental.Support.Icons

  alias Elemental.Actions.Button
  alias Elemental.Feedback.Alert
  alias Elemental.Feedback.Loading

  attr :id, :string, required: true
  attr :message, :string, required: true
  attr :outline, :boolean, default: false
  attr :dash, :boolean, default: false
  attr :soft, :boolean, default: false
  attr :clear_alert_event, :string, default: nil
  attr :"phx-target", :any, default: nil

  def alert_message(assigns) do
    assigns =
      assigns
      |> assign(:phx_target, assigns[:"phx-target"])
      |> normalize_alert_message()

    ~H"""
    <Alert.alert id={@id} type={@type} outline={@outline} dash={@dash} soft={@dash}>
      <.alert_icon type={@type} />
      <div>
        <h3 :if={@title} class="font-semibold">
          {@title}
        </h3>
        {@content}
      </div>
      <.close_button
        type={@type}
        target_id={@id}
        phx_target={@phx_target}
        clear_alert_event={@clear_alert_event}
      />
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

  attr :type, :string, values: [nil, "info", "success", "warning", "error"], default: nil
  attr :target_id, :string, required: true
  attr :phx_target, :any, default: nil
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
      phx-target={@phx_target}
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
       when is_message_content(content) do
    assigns
    |> assign(type: level)
    |> assign(:title, humanize(level))
    |> assign(:content, content)
  end

  defp normalize_alert_message(%{message: {level, title, content}} = assigns)
       when is_message_content(content) do
    assigns
    |> assign(type: level)
    |> assign(:title, title)
    |> assign(:content, content)
  end
end
