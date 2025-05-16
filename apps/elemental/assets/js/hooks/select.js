// Small helper to wrap a function with debounce behaviour.
function debounce(fun, timeoutMs) {
  let timer;

  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fun.apply(this, args), timeoutMs);
  };
}

/**
 * > Implements label support for `<select>` elements.
 *
 * By hooking this to plain ol' hidden button (of type button) we can
 * improve intractability with labels by having the label bind to
 * the hidden button, and having the button open up the select
 * on our behalf.
 *
 * Implementation is done by sending the `<select>` a `mousedown` event
 * which triggers the select to open up (as if clicked on by mouse).
 */
export const ElementalNativeSelectLabelAdapter = {
  mounted() {
    this.el.onclick = () => this.selectMouseDown();
  },

  selectMouseDown() {
    const selectId = `${this.el.id}__select`;
    const selectEl = document.getElementById(selectId);
    const mousedown = new MouseEvent("mousedown");
    selectEl.dispatchEvent(mousedown);
  },
};

/**
 * > Implements client-side text search functionality on dropdowns.
 *
 * Provide client side behaviour for the dropdown search functionality,
 * introduces an `oninput` event listener that on input changes will
 * filter the dropdown items based on the search result.
 *
 * Filtering is performed by simply disabling and hiding items that don't
 * match the searched term.
 *
 * Matching itself is performed by simply downcasing both the `label`
 * of the item and the inputted text, and checking if the label
 * contains the inputted text.
 */
export const ElementalSelectDropdownSearch = {
  mounted() {
    const componentId = this.el.getAttribute("elemental-component-id");

    const contentId = `${componentId}__content`;
    const contentEl = document.getElementById(contentId);
    this.el.oninput = debounce(() => this.filterSibling(contentEl), 100);

    const dropdownId = `${componentId}__dropdown`;
    const dropdownEl = document.getElementById(dropdownId);
    this.el.onclick = () => dropdownEl.setAttribute("open", true);
  },

  filterSibling(contentEl) {
    const text = this.el.value.toLowerCase();
    this.listAllItems(contentEl).forEach((el) => {
      const label = el.getAttribute("elemental-label").toLowerCase();
      if (label.includes(text)) this.showItem(el);
      else this.hideItem(el);
    });
  },

  listAllItems(contentEl) {
    return Array.from(contentEl.children).filter((child) => child !== this.el);
  },

  showItem(el) {
    const itemId = el.getAttribute("elemental-item-id");
    const selector = CSS.escape(itemId);
    const itemEl = el.querySelector(`#${selector}`);
    itemEl.disabled = false;
    el.classList.remove("hidden");
  },

  hideItem(el) {
    const itemId = el.getAttribute("elemental-item-id");
    const selector = CSS.escape(itemId);
    const itemEl = el.querySelector(`#${selector}`);
    itemEl.disabled = true;
    el.classList.add("hidden");
  },
};

/**
 * Allows for updating the dropdown prompt with the selected value
 * from the options, additionally closes the dropdown by
 * removing focus. Intended for internal use only.
 */
export const ElementalSelectSingleItem = {
  mounted() {
    // This is simple but does the trick since it is intended to work
    // with radio buttons, i.e. click implies selection.
    this.el.onclick = () => {
      this.closeDropdown();
      this.hideAllPrompts();
      this.showSelectedPrompt();
    };
  },

  hideAllPrompts() {
    const componentId = this.el.getAttribute("elemental-component-id");
    const promptId = `${componentId}__dropdown_trigger`;
    const promptEl = document.getElementById(promptId);
    Array.from(promptEl.children).forEach((child) => {
      const isSpan = child.nodeName === "SPAN";
      const classList = child.classList;
      if (isSpan && !classList.contains("hidden")) {
        classList.add("hidden");
      } else if (!isSpan) {
        child.setAttribute("placeholder", "...");
      }
    });
  },

  showSelectedPrompt() {
    const displayId = `${this.el.id}_display`;
    document.getElementById(displayId).classList.remove("hidden");
  },

  closeDropdown() {
    const componentId = this.el.getAttribute("elemental-component-id");
    const dropdownId = `${componentId}__dropdown`;
    const dropdownEl = document.getElementById(dropdownId);
    dropdownEl.removeAttribute("open");
  },
};

/**
 * Allows for updating the dropdown prompt with the selected value
 * from the options. Intended for internal use only.
 */
export const ElementalSelectMultiItem = {
  mounted() {
    this.el.onclick = () => {
      this.hideDefaultPrompt();
      this.toggleSelf();
      this.maybeShowDefaultPrompt();
    };
  },

  isPromptInlined() {
    return this.el.getAttribute("elemental-hook-uses-inlined-search") != null;
  },

  hideDefaultPrompt() {
    const componentId = this.el.getAttribute("elemental-component-id");

    const promptId = `${componentId}__default_prompt`;
    const promptEl = document.getElementById(promptId);
    if (promptEl) this.hidePromptSpan(promptEl);

    const inlineSearchId = `${componentId}__inline_search`;
    const inlineSearchEl = document.getElementById(inlineSearchId);
    if (inlineSearchEl) this.hidePromptPlaceholder(inlineSearchEl);
  },

  hidePromptSpan(el) {
    if (!el.classList.contains("hidden")) {
      el.classList.add("hidden");
    }
  },

  hidePromptPlaceholder(el) {
    const placeholder = el.getAttribute("placeholder");
    const savedPlaceholder = el.getAttribute("elemental-private-placeholder");
    if (savedPlaceholder == null) {
      el.setAttribute("elemental-private-placeholder", placeholder);
      el.setAttribute("placeholder", "...");
    }
  },

  showDefaultPrompt() {
    const componentId = this.el.getAttribute("elemental-component-id");

    const promptId = `${componentId}__default_prompt`;
    const promptEl = document.getElementById(promptId);
    if (promptEl) this.showPromptSpan(promptEl);

    const inlineSearchId = `${componentId}__default_prompt`;
    const inlineSearchEl = document.getElementById(inlineSearchId);
    if (inlineSearchEl) this.showPromptPlaceholder(inlineSearchEl);
  },

  showPromptSpan(el) {
    if (el.classList.contains("hidden")) {
      el.classList.remove("hidden");
    }
  },

  showPromptPlaceholder(el) {
    const placeholder = el.getAttribute("elemental-private-placeholder");
    el.setAttribute("placeholder", placeholder);
    el.removeAttribute("elemental-private-placeholder");
  },

  toggleSelf() {
    const displayId = `${this.el.id}_display`;
    document.getElementById(displayId).classList.toggle("hidden");
  },

  maybeShowDefaultPrompt() {
    const componentId = this.el.getAttribute("elemental-component-id");
    const promptId = `${componentId}__dropdown_trigger`;
    const promptEl = document.getElementById(promptId);
    const noPromptShown = Array.from(promptEl.children).every((child) => {
      const isInput = child.nodeName === "INPUT";
      const isHidden = child.classList.contains("hidden");
      // This is to handle inlined search prompt case
      return isInput || isHidden;
    });
    if (noPromptShown) this.showDefaultPrompt();
  },
};
