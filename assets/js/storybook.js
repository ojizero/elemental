// Load Elemental's custom JavaScript into storybook

import * as Hooks from "./hooks";

(function () {
  window.storybook = { Hooks };
})();
