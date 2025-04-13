defmodule ElementalStorybook.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: ElementalStorybook.PubSub},
      ElementalStorybookWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ElementalStorybook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ElementalStorybookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
