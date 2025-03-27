defmodule Elemental.Storybook.Router do
  use Phoenix.Router

  import Phoenix.LiveView.Router
  import PhoenixStorybook.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixPlayground.Layout, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Plug.Static,
      at: "/elementals",
      from: {:elemental, "/priv/static"},
      gzip: false
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", Elemental do
    pipe_through :browser
    live_storybook("/", backend_module: Elemental.Storybook)
  end
end
