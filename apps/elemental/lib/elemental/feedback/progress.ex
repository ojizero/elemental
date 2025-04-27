defmodule Elemental.Feedback.Progress do
  @moduledoc "> Display progress via Daisy's progress component."

  use Elemental.Component

  attr :value,
       :any,
       default: nil,
       doc: """
       The current value in the progress. Must be an integer, a
       floating number, or a string that can be parsed as an
       integer or a floating number.

       ## Caveats

       - If `radial` attribute is enabled this defaults to zero.
       - If `radial` is disabled this will trigger the intermediate
         state defined for the `<progress>` HTML element.
       """

  attr :max,
       :any,
       default: 100,
       doc: """
       The maximum value to use. Must be an integer, a floating
       number, or a string that can be parsed as an integer
       or a floating number.
       """

  attr :radial,
       :boolean,
       default: false,
       doc: "Enables the radial view of the progress."

  attr :color,
       :string,
       values: daisy_colors() ++ daisy_content_colors(),
       required: false,
       doc: """
       The style to use for the progress.

       ## Caveats

       If `radial` attribute is not enabled then the `-content`
       variants of Daisy' colors are all ignored/ineffective.
       """

  attr :class,
       :any,
       default: nil,
       doc: "Additional CSS classes to pass to the component."

  attr :rest, :global, doc: false

  @doc """
  > The primary progress component.

  Supports both normal `<progress>` HTML element as well as a radially
  designed variant (backed by `<div>`).

  This will display as content of `<progress>` (or shown inside radial)
  the rounded percentage of the progress based on the value and
  the max defined.

  If `value` is not given (or is `nil`) in `radial` mode then it'll be
  defaulted to `0` while in the non-radial mode will trigger the
  intermediate state which shows a progress bar animating.
  """
  def progress(assigns)

  def progress(%{radial: true} = assigns) do
    # We simplify things greatly by just forcing value
    # to be zero as default for radial since we
    # don't support intermediate state here.
    assigns =
      update(assigns, :value, fn
        nil -> 0
        otherwise -> otherwise
      end)

    ~H"""
    <div
      class={[
        "radial-progress",
        assigns[:color] && "text-#{@color}",
        @class
      ]}
      style={"--value:#{@value};"}
      aria-valuemax={@max}
      aria-valuenow={@value}
      role="progressbar"
      {@rest}
    >
      <.percentage max={@max} value={@value} />
    </div>
    """
  end

  def progress(assigns) do
    ~H"""
    <progress
      class={[
        "progress",
        assigns[:color] && "progress-#{@color}",
        @class
      ]}
      max={@max}
      value={@value}
      aria-valuemax={@max}
      aria-valuenow={@value}
      {@rest}
    >
      <.percentage max={@max} value={@value} />
    </progress>
    """
  end

  attr :max, :any, required: true
  attr :value, :any, required: true

  defp percentage(%{value: value} = assigns)
       when is_nil(value),
       do: ~H"0%"

  defp percentage(%{max: max} = assigns)
       when max in [100, 100.0, "100"],
       do: ~H"{@value}%"

  defp percentage(assigns) do
    with {value, ""} <- maybe_parse(assigns.value),
         {max, ""} <- maybe_parse(assigns.max),
         percent = round(value / max * 100),
         assigns = assign(assigns, :percent, percent) do
      ~H"{@percent}%"
    else
      :error -> ~H"0%"
    end
  end

  defp maybe_parse(str) when is_binary(str), do: Float.parse(str)
  defp maybe_parse(num) when is_number(num), do: {num, ""}
  defp maybe_parse(_otherwise), do: :error
end
