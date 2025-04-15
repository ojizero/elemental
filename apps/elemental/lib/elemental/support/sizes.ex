defmodule Elemental.Support.Sizes do
  @moduledoc false

  @daisy_sizes ~w(xs sm md lg xl)

  @status_sizes %{
    "xs" => "status-xs",
    "sm" => "status-sm",
    "md" => "status-md",
    "lg" => "status-lg",
    "xl" => "status-xl"
  }

  @doc false
  def daisy_sizes, do: @daisy_sizes
  @doc false
  def status_size(size), do: @status_sizes[size]
end
