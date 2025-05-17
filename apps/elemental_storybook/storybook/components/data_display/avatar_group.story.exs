defmodule Elemental.Storybook.Components.DataDisplay.AvatarGroup do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.DataDisplay.Avatar.avatar_group/1

  def imports do
    [{Elemental.DataDisplay.Avatar, avatar: 1}]
  end

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{},
        slots: [
          """
          <.avatar src="https://img.daisyui.com/images/profile/demo/batperson@192.webp" class="w-12" />
          """,
          """
          <.avatar src="https://img.daisyui.com/images/profile/demo/spiderperson@192.webp" class="w-12" />
          """,
          """
          <.avatar src="https://img.daisyui.com/images/profile/demo/averagebulk@192.webp" class="w-12" />
          """,
          """
          <.avatar class="w-12 bg-neutral text-neutral-content" placeholder="+99" />
          """
        ]
      }
    ]
  end
end
