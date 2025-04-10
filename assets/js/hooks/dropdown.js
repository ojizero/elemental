// Small helper to wrap a function with debounce behaviour.
function debounce(fun, timeoutMs) {
  let timer

  return (...args) => {
    clearTimeout(timer)
    timer = setTimeout(() => fun.apply(this, args), timeoutMs)
  }
}

/**
 * > Implements client-side text search functionality on dropdowns.
 *
 *
 */
export const ElementalDropdownSearch = {
  mounted() { this.el.oninput = debounce(() => this.filterSibling(), 100) },

  filterSibling() {
    const text = this.el.value.toLowerCase()
    this.listAllSiblings().forEach(el => {
      const label = el.getAttribute("elemental-label").toLowerCase()

      if (label.includes(text)) this.showItem(el)
      else this.hideItem(el)
    })
  },

  listAllSiblings() {
    return Array.from(this.el.parentNode.children).filter(child => child !== this.el)
  },

  showItem(el) {
    const itemId = el.getAttribute("elemental-item-id")
    const selector = CSS.escape(itemId)
    const itemEl = el.querySelector(`#${selector}`)
    itemEl.disabled = false
    el.classList.remove("hidden")
  },

  hideItem(el) {
    const itemId = el.getAttribute("elemental-item-id")
    const selector = CSS.escape(itemId)
    const itemEl = el.querySelector(`#${selector}`)
    itemEl.disabled = true
    el.classList.add("hidden")
  }
}

/**
 * Allows for updating the dropdown prompt with the selected value
 * from the options, additionally closes the dropdown by
 * removing focus. Intended for internal use only.
 */
export const ElementalDropdownSingleItem = {
  mounted() {
    // This is simple but does the trick since it is intended to work
    // with radio buttons, i.e. click implies selection.
    this.el.onclick = () => {
      this.closeDropdown()
      this.updatePrompt()
    }
  },

  updatePrompt() {
    this.hideAllPrompts()
    this.showSelectedPrompt()
  },

  hideAllPrompts() {
    const promptId = this.el.getAttribute("elemental-hook-prompt-container-id")
    const promptEl = document.getElementById(promptId)
    Array.from(promptEl.children).forEach((child) => {
      const classList = child.classList
      if (!classList.contains("hidden")) {
        classList.add("hidden")
      }
    })
  },

  showSelectedPrompt() {
    const displayId = `${this.el.id}_display`
    document.getElementById(displayId).classList.remove("hidden")
  },

  // Close the prompt by removing focus from it, this is based
  // on how the dropdown is implemented.
  closeDropdown() {
    const contentId = this.el.getAttribute("elemental-hook-content-id")
    const contentEl = document.getElementById(contentId)
    contentEl.blur()
  }
}

/**
 * Allows for updating the dropdown prompt with the selected value
 * from the options. Intended for internal use only.
 */
export const ElementalDropdownMultiItem = {
  mounted() {
    this.el.onclick = () => {
      this.hideDefaultPrompt()
      this.toggleSelf()
      this.maybeShowDefaultPrompt()
    }
  },

  hideDefaultPrompt() {
    const promptId = this.el.getAttribute("elemental-hook--default-prompt-id")
    const promptEl = document.getElementById(promptId)
    if (!promptEl.classList.contains("hidden")) {
      promptEl.classList.add("hidden")
    }
  },

  showDefaultPrompt() {
    const promptId = this.el.getAttribute("elemental-hook--default-prompt-id")
    const promptEl = document.getElementById(promptId)
    if (promptEl.classList.contains("hidden")) {
      promptEl.classList.remove("hidden")
    }
  },

  toggleSelf() {
    const displayId = `${this.el.id}_display`
    document.getElementById(displayId).classList.toggle("hidden")
  },

  maybeShowDefaultPrompt() {
    const promptId = this.el.getAttribute("elemental-hook-prompt-container-id")
    const promptEl = document.getElementById(promptId)
    const noPromptShown = Array.from(promptEl.children).every((child) => child.classList.contains("hidden"))
    if (noPromptShown) this.showDefaultPrompt()
  }
}
