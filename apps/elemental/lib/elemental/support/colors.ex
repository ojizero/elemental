defmodule Elemental.Support.Colors do
  @moduledoc false

  # We treat "ghost" style as a color
  @daisy_colors ~w(ghost neutral primary secondary accent info success warning error)

  @status_colors %{
    "ghost" => "status-ghost",
    "neutral" => "status-neutral",
    "primary" => "status-primary",
    "secondary" => "status-secondary",
    "accent" => "status-accent",
    "info" => "status-info",
    "success" => "status-success",
    "warning" => "status-warning",
    "error" => "status-error"
  }

  @doc false
  def daisy_colors, do: @daisy_colors
  @doc false
  def status_color(color), do: @status_colors[color]
end
