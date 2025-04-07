defmodule Elemental.Table do
  @moduledoc "> Tabular data display components."

  use Elemental.Component

  attr :rest, :global

  slot :inner_block, required: true

  def table(assigns) do
    assigns = prepend_class(assigns, "table")

    ~H"""
    <table {@rest}>
      {render_slot(@inner_block)}
    </table>
    """
  end

  attr :rest, :global

  slot :cell, doc: "" do
    attr :id,
         :string,
         doc: "The identifier of this specific cell in the header row."

    attr :class,
         :string,
         doc: "The main CSS classes that will style this specific cell in the header row."
  end

  def header(assigns) do
    ~H"""
    <thead {@rest}>
      <tr>
        <th :for={cell <- @cell} id={cell[:id]} class={cell[:class]}>
          {render_slot(cell)}
        </th>
      </tr>
    </thead>
    """
  end

  attr :data, :any, required: true, doc: ""

  attr :row_id, :any, default: nil, doc: ""

  slot :cell, doc: "" do
    attr :id,
         :string,
         doc: "The identifier of this specific cell in the header row."

    attr :class,
         :string,
         doc: "The main CSS classes that will style this specific cell in the header row."
  end

  def body(assigns) do
    ~H"""
    <tbody>
      <tr :for={row <- @data}>
        <td :for={cell <- @cell}>
          {render_slot(cell, row)}
        </td>
      </tr>
    </tbody>
    """
  end
end
