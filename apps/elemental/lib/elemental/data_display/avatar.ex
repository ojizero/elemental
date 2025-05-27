defmodule Elemental.DataDisplay.Avatar do
  @moduledoc """
  A simple avatar component with some quality of life around errors
  in loading images.

  Provides two components `avatar/1` and `avatar_group/1`.

  ## Usage

      <.avatar src="https://some.url/to/image" />

  An avatar of just text can be done via placeholder with no source

      <.avatar placeholder="AB" class="bg-neutral text-neutral-content" />

  If the image fails to load and a placeholder is given the place holder is shown,
  however if the image loads the placeholder is hidden completely

      <.avatar src="https://some.url/to/image" placeholder="AB" class="bg-neutral text-neutral-content" />

  Avatars can be grouped via the `avatar_group/1` component

      <.avatar_group>
        <.avatar src="https://some.url/to/image" />
        <.avatar src="https://some.url/to/image" placeholder="AB" class="bg-neutral text-neutral-content" />
        <.avatar placeholder="AB" class="bg-neutral text-neutral-content" />
      </.avatar_group>
  """

  use Elemental.Component

  attr :src,
       :string,
       default: nil,
       doc: "The source to use for the image within the avatar."

  attr :alt,
       :string,
       default: nil,
       doc: "The alternative text to pass to the `<img>` element."

  attr :placeholder,
       :string,
       default: nil,
       doc:
         "Placeholder text to show if no image is given or if an error happens loading the image."

  attr :presence,
       :string,
       values: ~w(online offline),
       required: false,
       doc: "Optional presence indicator to show on the avatar."

  attr :class,
       :any,
       required: false,
       doc: "Additional classes to wrap the avatar with."

  attr :loading,
       :string,
       values: ~w(lazy eager),
       default: "lazy",
       doc: ""

  attr :id, :string, required: false, doc: false

  @doc "> Primary avatar component."
  def avatar(assigns) do
    assigns = assign_new(assigns, :id, &random/0)

    ~H"""
    <div
      id={@id}
      class={[
        "avatar",
        assigns[:presence] && "avatar-#{@presence}",
        @placeholder != [] && is_nil(@src) && "avatar-placeholder"
      ]}
      phx-hook="ElementalAvatar"
    >
      <div class={@class}>
        <img :if={@src} id={@id <> "__img"} src={@src} alt={@alt} loading={@loading} />
        <span :if={@placeholder != []} id={@id <> "__placeholder"} hidden={not is_nil(@src)}>
          {@placeholder}
        </span>
      </div>
    </div>
    """
  end

  attr :overlap,
       :integer,
       default: 6,
       doc: """
       The overlap of the avatars in the group.

       Passed as a negative space between the avatars in the group.
       """

  slot :inner_block,
    required: true,
    doc: "The list of avatars to group together."

  @doc "Group together a bunch of avatars."
  def avatar_group(assigns) do
    ~H"""
    <div class={["avatar-group", "-space-x-#{@overlap}"]}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
