defmodule Elemental.Actions.Modal do
  @moduledoc """
  Implements a modal component based on `<dialog>` HTML element and Daisy's
  modal component. The component relies on the browser implementation for
  it's main/core implementation and provides JavaScript handlers to
  allow for controlling the modals from Elixir's side.

  The modal can be closed by either pressing escape, by clicking outside of
  the modal, or by clicking on the close button within it.

  Close behaviour implemented relies the browser's imeplementation of the
  `<dialog>` component.

  ## Usage

      <.modal>
        <h3 class="text-lg font-bold">Title</h3>
        <p class="py-4">Press ESC key, click outside, or click on ✕ button to close</p>
      </.modal>

  ## Server side control

  You can send the events `el-show-modal` or `el-hide-modal` to show/hide the
  modal based on the server side logic. This requires JavaScript working
  since it relies on custom event listeners.
  """

  use Elemental.Component

  import Elemental.Support.Icons

  alias Elemental.Actions.Button

  attr :id,
       :string,
       required: false,
       doc: "The ID of the modal. Defaults to a random value."

  attr :open,
       :boolean,
       default: false,
       doc: "If true opens the modal on mount."

  attr :show,
       :boolean,
       required: false,
       doc: "If true enables `open`. For compatibility with Phoenix' implementation."

  attr :class,
       :any,
       default: nil,
       doc: "Additional CSS classes to add to the modal box."

  attr :rest, :global

  @doc "> Primary modal component."
  def modal(assigns) do
    assigns = normalize_assigns(assigns)

    ~H"""
    <dialog
      id={@id}
      class="modal"
      phx-mounted={@open and show_modal(@id)}
      phx-removed={hide_modal(@id)}
    >
      <div class={["modal-box", @class]} {@rest}>
        <form method="dialog">
          <Button.button color="ghost" size="sm" shape="circle" class="right-2 top-2 absolute">
            <.x_mark />
          </Button.button>
        </form>

        {render_slot(@inner_block)}
      </div>

      <form class="modal-backdrop" method="dialog">
        <Button.button elemental-disable-styles>Close</Button.button>
      </form>
    </dialog>
    """
  end

  @doc """
  Show a modal based on it's ID.

  > Requires JavaScript enabled and Elemental's event listeners added.
  """
  def show_modal(js \\ %JS{}, id),
    do: JS.dispatch(js, "el:show-modal", to: "##{id}")

  @doc """
  Hide a modal based on it's ID.

  > Requires JavaScript enabled and Elemental's event listeners added.
  """
  def hide_modal(js \\ %JS{}, id),
    do: JS.dispatch(js, "el:hide-modal", to: "##{id}")

  defp normalize_assigns(assigns) do
    assigns
    |> assign_new(:id, &random/0)
    |> update(:open, fn
      _open, %{show: true} -> true
      open, _assigns -> open
    end)
  end
end
