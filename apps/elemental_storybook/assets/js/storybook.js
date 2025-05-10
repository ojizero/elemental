// Load Elemental's custom JavaScript into storybook

// Due to Mix not placing path dependencies under `deps` we
// manually pass it the full path to the JS package.
import { Hooks } from "elemental";

(function () {
  window.storybook = { Hooks };
})();
