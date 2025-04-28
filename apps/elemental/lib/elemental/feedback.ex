defmodule Elemental.Feedback do
  defmacro __using__(_opts \\ []) do
    quote do
      import Elemental.Feedback.Alert
      import Elemental.Feedback.Loading
      import Elemental.Feedback.Toast
      import Elemental.Feedback.Tooltip

      alias Elemental.Feedback.Live.ToastGroup
    end
  end
end
