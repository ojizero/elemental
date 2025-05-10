export * as Hooks from "./hooks";

// Workaround to get `<dialog>` element to behave correctly with JS
// commands made for the Modal component.
//
// For some reason toggling the `open` attribute on it seems to break
// the ESC button behaviour for closing the modal.
//
// This itself is optional since the modal itself is implemented using
// form method dialog which is browser native, and is only useful
// if you want to control modals from Elixir side.

window.addEventListener("el:show-modal", (event) =>
  (event.target ?? document.getElementById(event.details.id))?.showModal(),
);

window.addEventListener("el:hide-modal", (event) =>
  (event.target ?? document.getElementById(event.details.id))?.close(),
);
