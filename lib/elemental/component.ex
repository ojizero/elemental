defmodule Elemental.Component do
  @moduledoc false

  import Phoenix.Component, only: [assign_new: 3, update: 3]

  @doc false
  defmacro __using__(_opts \\ []) do
    quote do
      use Phoenix.Component
      use PhoenixHTMLHelpers

      import Elemental.Component
    end
  end

  @doc false
  # We treat "ghost" style as a color
  def daisy_colors,
    do: ~w(ghost neutral primary secondary accent info success warning error)

  @doc false
  def daisy_sizes, do: ~w(xs sm md lg xl)

  @doc false
  def elemental_styles(_assigns) do
    # TODO: given input decide whether to use component's class or nothing
  end

  @doc false
  def prepend_class(assigns, class) do
    assigns
    |> assign_new(:rest, fn -> %{} end)
    |> update(:rest, fn
      %{class: classes} = rest when is_list(classes) -> %{rest | class: [class, classes]}
      %{class: classes} = rest when is_binary(classes) -> %{rest | class: "#{class} #{classes}"}
      rest -> Map.put(rest, :class, class)
    end)
  end

  @doc false
  def maybe_randomize_name(assigns),
    do: assign_new(assigns, :name, &random/0)

  @doc false
  def random do
    4
    |> :crypto.strong_rand_bytes()
    |> Base.encode16()
  end
end
