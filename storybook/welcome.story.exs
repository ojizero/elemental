defmodule Elemental.Storybook.MyPage do
  # See https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Story.html for full story
  # documentation.
  use PhoenixStorybook.Story, :page

  def doc, do: "Your very first steps into using Phoenix Storybook"

  # Declare an optional tab-based navigation in your page:
  def navigation do
    [
      {:welcome, "Welcome", {:fa, "hand-wave", :thin}},
      {:components, "Components", {:fa, "toolbox", :thin}}
      # {:icons, "Icons", {:fa, "icons", :thin}}
    ]
  end

  # This is a dummy fonction that you should replace with your own HEEx content.
  def render(assigns = %{tab: :welcome}) do
    ~H"""
    <div class="psb-welcome-page">
      <p>
        We generated your storybook with an example of a page and a component.
        Feel free to explore the generated <code class="inline">*.story.exs</code>
        files generated into your
        project folder, and start adding yours:
        <strong>just drop new story & index files into your </strong><code class="inline">/storybook</code>
        <strong>folder</strong>
        and refresh your storybook.
      </p>

      <p>
        Here are a few docs you might be interested in:
      </p>

      <.description_list items={[
        {"Stories overview", doc_link("Story")},
        {"Describe components with Variations", doc_link("Stories.Variation")},
        {"And stack them with VariationGroups", doc_link("Stories.VariationGroup")},
        {"Pimp your sidebar with Index files", doc_link("Index")}
      ]} />

      <p>
        This should be enough to get you started but you might also <strong>checkout advanced guides </strong>(tabs in the upper-right corner of this page).
      </p>
    </div>
    """
  end

  def render(assigns = %{tab: guide}) when guide in ~w(components sandboxing icons)a do
    assigns =
      assign(assigns,
        guide: guide,
        guide_content: PhoenixStorybook.Guides.markup("#{guide}.md")
      )

    ~H"""
    <p class="md:psb-text-lg psb-leading-relaxed psb-text-slate-400 psb-w-full psb-text-left psb-mb-4 psb-mt-2 psb-italic">
      <a
        class="hover:text-indigo-700"
        href={"https://hexdocs.pm/phoenix_storybook/#{@guide}.html"}
        target="_blank"
      >
        This guide is also available on Hexdocs among others.
      </a>
    </p>
    <div class="psb-welcome-page psb-border-t psb-border-gray-200 psb-pt-4">
      {Phoenix.HTML.raw(@guide_content)}
    </div>
    """
  end

  defp description_list(assigns) do
    ~H"""
    <div class="psb-w-full md:psb-px-8">
      <div class="md:psb-border-t psb-border-gray-200 psb-px-4 psb-py-5 sm:psb-p-0 md:psb-my-6 psb-w-full">
        <dl class="sm:psb-divide-y sm:psb-divide-gray-200">
          <%= for {dt, link} <- @items do %>
            <div class="psb-py-4 sm:psb-grid sm:psb-grid-cols-3 sm:psb-gap-4 sm:psb-py-5 sm:psb-px-6 psb-max-w-full">
              <dt class="psb-text-base psb-font-medium psb-text-indigo-700">
                {dt}
              </dt>
              <dd class="psb-mt-1 psb-text-base psb-text-slate-400 sm:psb-col-span-2 sm:psb-mt-0 psb-group psb-cursor-pointer psb-max-w-full">
                <a
                  class="group-hover:psb-text-indigo-700 psb-max-w-full psb-inline-block psb-truncate"
                  href={link}
                  target="_blank"
                  %
                >
                  {link}
                </a>
              </dd>
            </div>
          <% end %>
        </dl>
      </div>
    </div>
    """
  end

  defp doc_link(page) do
    "https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.#{page}.html"
  end
end
