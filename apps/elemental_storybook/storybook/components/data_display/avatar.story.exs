defmodule Elemental.Storybook.Components.DataDisplay.Avatar do
  use PhoenixStorybook.Story, :component

  def function, do: &Elemental.DataDisplay.Avatar.avatar/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          src: "https://img.daisyui.com/images/profile/demo/batperson@192.webp",
          class: "rounded"
        }
      },
      %Variation{
        id: :custom_size,
        attributes: %{
          src: "https://img.daisyui.com/images/profile/demo/superperson@192.webp",
          class: "w-24 rounded-full"
        }
      },
      %Variation{
        id: :with_presence,
        attributes: %{
          src: "https://img.daisyui.com/images/profile/demo/superperson@192.webp",
          class: "w-24 rounded-full",
          presence: "online"
        }
      },
      %Variation{
        id: :placeholder_only,
        attributes: %{
          placeholder: "AA",
          class: "w-24 rounded-full bg-neutral text-neutral-content"
        }
      },
      %Variation{
        id: :placeholder_on_error,
        attributes: %{
          src: "should fail",
          class: "w-24 rounded-full bg-neutral text-neutral-content",
          placeholder: "AA"
        }
      }
    ]
  end
end
