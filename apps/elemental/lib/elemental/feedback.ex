defmodule Elemental.Feedback do
  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Feedback.Loading
      import Elemental.Feedback.Tooltip
    end
  end
end
