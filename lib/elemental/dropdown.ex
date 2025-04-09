defmodule Elemental.Dropdown do
  use Elemental.Component

  attr :options,
       :list,
       required: true,
       doc: """
       The list of values to select between. This is required to either be a list of strings, or a list of string tuples.

       If given as a list of strings each option will use that value as both it's
       label and value sent to from the dropdown.

       If give as a list of tuples, those tuples are expected to be two strings,
       the first being the label to use, while the second is expected to be
       the value to send from the dropdown.
       """

  attr :name,
       :string,
       required: false,
       doc: "The name of the dropdown, if not given a random value is selected."

  attr :multi,
       :boolean,
       default: false,
       doc: "To enable selection of multiple values, passed to consumer as a list."

  attr :align,
       :string,
       values: ~w(start center end),
       default: "start",
       doc: "Specify the alignment for the dropdown."

  attr :from,
       :string,
       values: ~w(top bottom left right),
       default: "bottom",
       doc: "Specify where the dropdown will appear from."

  attr :hover,
       :boolean,
       default: false,
       doc: "To enable opening the dropdown on hover."

  attr :open,
       :boolean,
       default: false,
       doc: "To open the dropdown immediately. "

  attr :class,
       :any,
       default: nil,
       doc: "Additional CSS classes to pass to the dropdown container."

  def dropdown(assigns) do
    assigns = normalize_assigns(assigns)

    ~H"""
    <div class={[
      "dropdown",
      "dropdown-#{@align}",
      "dropdown-#{@from}",
      @hover && "dropdown-hover",
      @open && "dropdown-open",
      @class
    ]}>
      <div tabindex="0" role="button" class="select m-1">{@prompt}</div>
      <ul
        tabindex="0"
        class="dropdown-content menu bg-neutral-content rounded-box z-1 w-52 p-2 shadow-sm"
      >
        <li :for={{label, value} <- @options}>
          <.dropdown_item name={@name} label={label} value={value} multi={@multi} />
        </li>
      </ul>
    </div>
    """
  end

  attr :name,
       :string,
       required: true,
       doc: ""

  attr :multi,
       :boolean,
       default: false,
       doc: ""

  attr :label,
       :string,
       required: true,
       doc: ""

  attr :value,
       :string,
       required: true,
       doc: ""

  defp dropdown_item(%{option: option} = assigns)
       when not is_tuple(option) do
    assigns
    |> assign(:option, {option, option})
    |> dropdown()
  end

  defp dropdown_item(%{multi: false} = assigns) do
    ~H"""
    <label>
      <input name={@name} type="radio" class="checkbox" value={@value} />
      {@label}
    </label>
    """
  end

  defp dropdown_item(%{multi: true} = assigns) do
    ~H"""
    <label>
      <input name={@name <> "[]"} type="checkbox" class="checkbox" value={@value} />
      {@label}
    </label>
    """
  end

  defp random_name do
    4
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
  end

  defp normalize_assigns(assigns) do
    assigns
    |> assign_new(:name, &random_name/0)
    |> update(:options, &normalize_options/1)
  end

  defp normalize_options(options) do
    Enum.map(options, fn
      {label, value} -> {label, value}
      label when is_binary(label) -> {label, label}
    end)
  end
end
