defmodule Elemental.Storybook do
  use PhoenixStorybook,
    otp_app: :elemental,
    title: "Elemental Storybook",
    content_path: Path.expand("../", __DIR__),
    css_path: "/elementals/assets/storybook.css",
    js_path: "/elementals/assets/storybook.js",
    themes: [
      default: [name: "Default"],
      colorful: [name: "Colorful", dropdown_class: "psb-text-pink-600"]
    ],
    themes_strategies: [
      body_class: "theme"
    ],
    color_mode: true,
    font_awesome_plan: :pro,
    font_awesome_kit_id: "7a72374eed",
    strip_doc_attributes: false
end
