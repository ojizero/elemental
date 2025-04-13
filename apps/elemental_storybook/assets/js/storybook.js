// Load Elemental's custom JavaScript into storybook

// Due to Mix not placing path dependencies under `deps` we
// manually pass it the full path to the JS package.
import * as Hooks from "../../../elemental/assets/js/hooks";

(function () {
  window.storybook = { Hooks };
})();
