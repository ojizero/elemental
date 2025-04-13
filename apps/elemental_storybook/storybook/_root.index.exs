defmodule Elemental.Storybook.Root do
  use PhoenixStorybook.Index
  def folder_icon, do: {:fa, "book-open", :solid}
  def folder_name, do: "Storybook"
  def entry("welcome"), do: [name: "Welcome to Elemental", icon: {:fa, "hand-wave", :thin}]
end
