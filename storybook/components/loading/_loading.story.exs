defmodule Elemental.Storybook.Components.Loading do
  use PhoenixStorybook.Index
  def folder_icon, do: {:fa, "loader", :thin}
  def folder_open?, do: false
end
