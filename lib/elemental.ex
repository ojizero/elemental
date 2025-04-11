defmodule Elemental do
  @moduledoc """
  > A Tailwind and DaisyUI based Phoenix components library.

  Provides a set of components built on top of DaisyUI and Tailwind
  for use with Elixir Phoenix.

  Provided components aim to behave as close as possible to plain HTML
  elements and follow to best of my abilities Phoenix' conventions.

  Some functionality requires small set of JavaScript present, this is
  kept to a minimal as possible.

  ## Installation

  Add the Elemental to your application's dependencies in your `mix.exs`

      {:elemental, "~> 0.1.0"}

  Update your `app.js` to add the necessary hooks (required for JavaScript
  based features)

  ```javascript
  // assets/js/app.js

  // ... other imports
  import * as Hooks from "elemental"

  const hooks = { /* the hooks your app uses */ }

  let liveSocket = new LiveSocket("/live", Socket, { hooks, ... })
  ```

  ## Usage

  In your application you can simply `use` `Elemental` in to import
  all the components provided

      defmodule MyAppWeb.Component do
        use MyAppWeb, :html
        use Elemental # now you can use components directly

        def my_component(assigns) do
        ~H\"\"\"
        \<!-- you can now Elemental's components here -->
        \"\"\"
        end
      end

  Alternatively, you can import specific components as needed.
  """

  @doc false
  def __using__(_opts \\ []) do
    quote do
      import Elemental.Breadcrumbs
      import Elemental.Dropdown
      import Elemental.Loading
      import Elemental.Select
      import Elemental.Table
      import Elemental.Tooltip
    end
  end
end
