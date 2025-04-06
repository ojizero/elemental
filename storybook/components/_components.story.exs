defmodule Elemental.Storybook.Components do
  use PhoenixStorybook.Index
  def folder_icon, do: {:fa, "toolbox", :thin}
  def folder_open?, do: false
  def entry("spinner"), do: [icon: {:fa, "badge-check", :thin}]
  def entry("tooltip"), do: [icon: {:fa, "badge-check", :thin}]
end
