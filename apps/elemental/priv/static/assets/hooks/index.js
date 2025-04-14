(() => {
  // assets/js/hooks/select.js
  var ElementalSelectLabelAdapter = {
    mounted() {
      console.log("mounted");
      this.el.onclick = () => this.selectMouseDown();
    },
    selectMouseDown() {
      console.log("sending mousdown");
      const selectId = `${this.el.id}__select`;
      const selectEl = document.getElementById(selectId);
      const mousedown = new MouseEvent("mousedown");
      selectEl.dispatchEvent(mousedown);
    }
  };

  // assets/js/hooks/dropdown.js
  function debounce(fun, timeoutMs) {
    let timer;
    return (...args) => {
      clearTimeout(timer);
      timer = setTimeout(() => fun.apply(this, args), timeoutMs);
    };
  }
  var ElementalDropdownSearch = {
    mounted() {
      const contentId = this.el.getAttribute("elemental-hook-filterable-content-id");
      const contentEl = document.getElementById(contentId);
      this.el.oninput = debounce(() => this.filterSibling(contentEl), 100);
      const containerId = this.el.getAttribute("elemental-hook-container-id");
      const containerEl = document.getElementById(containerId);
      this.el.onclick = () => containerEl.setAttribute("open", true);
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
    }
  };
  var ElementalDropdownSingleItem = {
    mounted() {
      this.el.onclick = () => {
        this.closeDropdown();
        this.hideAllPrompts();
        this.showSelectedPrompt();
      };
    },
    hideAllPrompts() {
      const promptId = this.el.getAttribute("elemental-hook-prompt-container-id");
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
      const contentId = this.el.getAttribute("elemental-hook-container-id");
      const contentEl = document.getElementById(contentId);
      contentEl.removeAttribute("open");
    }
  };
  var ElementalDropdownMultiItem = {
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
      const promptId = this.el.getAttribute("elemental-hook-default-prompt-id");
      const promptEl = document.getElementById(promptId);
      if (promptEl.nodeName === "INPUT") this.hidePromptPlaceholder(promptEl);
      else this.hidePromptSpan(promptEl);
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
      console.log("showDefaultPrompt");
      const promptId = this.el.getAttribute("elemental-hook-default-prompt-id");
      const promptEl = document.getElementById(promptId);
      if (promptEl.nodeName === "INPUT") this.showPromptPlaceholder(promptEl);
      else this.showPromptSpan(promptEl);
    },
    showPromptSpan(el) {
      if (el.classList.contains("hidden")) {
        el.classList.remove("hidden");
      }
    },
    showPromptPlaceholder(el) {
      const placeholder = el.getAttribute("elemental-private-placeholder");
      console.log({ placeholder });
      el.setAttribute("placeholder", placeholder);
      el.removeAttribute("elemental-private-placeholder");
    },
    toggleSelf() {
      const displayId = `${this.el.id}_display`;
      document.getElementById(displayId).classList.toggle("hidden");
    },
    maybeShowDefaultPrompt() {
      const promptId = this.el.getAttribute("elemental-hook-prompt-container-id");
      const promptEl = document.getElementById(promptId);
      const noPromptShown = Array.from(promptEl.children).every((child) => {
        const isInput = child.nodeName === "INPUT";
        const isHidden = child.classList.contains("hidden");
        return isInput || isHidden;
      });
      if (noPromptShown) this.showDefaultPrompt();
    }
  };
})();
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsiLi4vLi4vLi4vLi4vYXNzZXRzL2pzL2hvb2tzL3NlbGVjdC5qcyIsICIuLi8uLi8uLi8uLi9hc3NldHMvanMvaG9va3MvZHJvcGRvd24uanMiXSwKICAic291cmNlc0NvbnRlbnQiOiBbIi8qKlxuICogPiBJbXBsZW1lbnRzIGxhYmVsIHN1cHBvcnQgZm9yIGA8c2VsZWN0PmAgZWxlbWVudHMuXG4gKlxuICogQnkgaG9va2luZyB0aGlzIHRvIHBsYWluIG9sJyBoaWRkZW4gYnV0dG9uIChvZiB0eXBlIGJ1dHRvbikgd2UgY2FuXG4gKiBpbXByb3ZlIGludHJhY3RhYmlsaXR5IHdpdGggbGFiZWxzIGJ5IGhhdmluZyB0aGUgbGFiZWwgYmluZCB0b1xuICogdGhlIGhpZGRlbiBidXR0b24sIGFuZCBoYXZpbmcgdGhlIGJ1dHRvbiBvcGVuIHVwIHRoZSBzZWxlY3RcbiAqIG9uIG91ciBiZWhhbGYuXG4gKlxuICogSW1wbGVtZW50YXRpb24gaXMgZG9uZSBieSBzZW5kaW5nIHRoZSBgPHNlbGVjdD5gIGEgYG1vdXNlZG93bmAgZXZlbnRcbiAqIHdoaWNoIHRyaWdnZXJzIHRoZSBzZWxlY3QgdG8gb3BlbiB1cCAoYXMgaWYgY2xpY2tlZCBvbiBieSBtb3VzZSkuXG4gKi9cbmV4cG9ydCBjb25zdCBFbGVtZW50YWxTZWxlY3RMYWJlbEFkYXB0ZXIgPSB7XG4gIG1vdW50ZWQoKSB7XG4gICAgY29uc29sZS5sb2coXCJtb3VudGVkXCIpXG4gICAgdGhpcy5lbC5vbmNsaWNrID0gKCkgPT4gdGhpcy5zZWxlY3RNb3VzZURvd24oKVxuICB9LFxuXG4gIHNlbGVjdE1vdXNlRG93bigpIHtcbiAgICBjb25zb2xlLmxvZyhcInNlbmRpbmcgbW91c2Rvd25cIilcbiAgICBjb25zdCBzZWxlY3RJZCA9IGAke3RoaXMuZWwuaWR9X19zZWxlY3RgXG4gICAgY29uc3Qgc2VsZWN0RWwgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChzZWxlY3RJZClcbiAgICBjb25zdCBtb3VzZWRvd24gPSBuZXcgTW91c2VFdmVudChcIm1vdXNlZG93blwiKVxuICAgIHNlbGVjdEVsLmRpc3BhdGNoRXZlbnQobW91c2Vkb3duKVxuICB9XG59XG4iLCAiLy8gU21hbGwgaGVscGVyIHRvIHdyYXAgYSBmdW5jdGlvbiB3aXRoIGRlYm91bmNlIGJlaGF2aW91ci5cbmZ1bmN0aW9uIGRlYm91bmNlKGZ1biwgdGltZW91dE1zKSB7XG4gIGxldCB0aW1lclxuXG4gIHJldHVybiAoLi4uYXJncykgPT4ge1xuICAgIGNsZWFyVGltZW91dCh0aW1lcilcbiAgICB0aW1lciA9IHNldFRpbWVvdXQoKCkgPT4gZnVuLmFwcGx5KHRoaXMsIGFyZ3MpLCB0aW1lb3V0TXMpXG4gIH1cbn1cblxuLyoqXG4gKiA+IEltcGxlbWVudHMgY2xpZW50LXNpZGUgdGV4dCBzZWFyY2ggZnVuY3Rpb25hbGl0eSBvbiBkcm9wZG93bnMuXG4gKlxuICogUHJvdmlkZSBjbGllbnQgc2lkZSBiZWhhdmlvdXIgZm9yIHRoZSBkcm9wZG93biBzZWFyY2ggZnVuY3Rpb25hbGl0eSxcbiAqIGludHJvZHVjZXMgYW4gYG9uaW5wdXRgIGV2ZW50IGxpc3RlbmVyIHRoYXQgb24gaW5wdXQgY2hhbmdlcyB3aWxsXG4gKiBmaWx0ZXIgdGhlIGRyb3Bkb3duIGl0ZW1zIGJhc2VkIG9uIHRoZSBzZWFyY2ggcmVzdWx0LlxuICpcbiAqIEZpbHRlcmluZyBpcyBwZXJmb3JtZWQgYnkgc2ltcGx5IGRpc2FibGluZyBhbmQgaGlkaW5nIGl0ZW1zIHRoYXQgZG9uJ3RcbiAqIG1hdGNoIHRoZSBzZWFyY2hlZCB0ZXJtLlxuICpcbiAqIE1hdGNoaW5nIGl0c2VsZiBpcyBwZXJmb3JtZWQgYnkgc2ltcGx5IGRvd25jYXNpbmcgYm90aCB0aGUgYGxhYmVsYFxuICogb2YgdGhlIGl0ZW0gYW5kIHRoZSBpbnB1dHRlZCB0ZXh0LCBhbmQgY2hlY2tpbmcgaWYgdGhlIGxhYmVsXG4gKiBjb250YWlucyB0aGUgaW5wdXR0ZWQgdGV4dC5cbiAqL1xuZXhwb3J0IGNvbnN0IEVsZW1lbnRhbERyb3Bkb3duU2VhcmNoID0ge1xuICBtb3VudGVkKCkge1xuICAgIGNvbnN0IGNvbnRlbnRJZCA9IHRoaXMuZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWhvb2stZmlsdGVyYWJsZS1jb250ZW50LWlkXCIpXG4gICAgY29uc3QgY29udGVudEVsID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoY29udGVudElkKVxuICAgIHRoaXMuZWwub25pbnB1dCA9IGRlYm91bmNlKCgpID0+IHRoaXMuZmlsdGVyU2libGluZyhjb250ZW50RWwpLCAxMDApXG5cbiAgICBjb25zdCBjb250YWluZXJJZCA9IHRoaXMuZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWhvb2stY29udGFpbmVyLWlkXCIpXG4gICAgY29uc3QgY29udGFpbmVyRWwgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChjb250YWluZXJJZClcbiAgICB0aGlzLmVsLm9uY2xpY2sgPSAoKSA9PiBjb250YWluZXJFbC5zZXRBdHRyaWJ1dGUoXCJvcGVuXCIsIHRydWUpXG4gIH0sXG5cbiAgZmlsdGVyU2libGluZyhjb250ZW50RWwpIHtcbiAgICBjb25zdCB0ZXh0ID0gdGhpcy5lbC52YWx1ZS50b0xvd2VyQ2FzZSgpXG4gICAgdGhpcy5saXN0QWxsSXRlbXMoY29udGVudEVsKS5mb3JFYWNoKGVsID0+IHtcbiAgICAgIGNvbnN0IGxhYmVsID0gZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWxhYmVsXCIpLnRvTG93ZXJDYXNlKClcbiAgICAgIGlmIChsYWJlbC5pbmNsdWRlcyh0ZXh0KSkgdGhpcy5zaG93SXRlbShlbClcbiAgICAgIGVsc2UgdGhpcy5oaWRlSXRlbShlbClcbiAgICB9KVxuICB9LFxuXG4gIGxpc3RBbGxJdGVtcyhjb250ZW50RWwpIHtcbiAgICByZXR1cm4gQXJyYXkuZnJvbShjb250ZW50RWwuY2hpbGRyZW4pLmZpbHRlcihjaGlsZCA9PiBjaGlsZCAhPT0gdGhpcy5lbClcbiAgfSxcblxuICBzaG93SXRlbShlbCkge1xuICAgIGNvbnN0IGl0ZW1JZCA9IGVsLmdldEF0dHJpYnV0ZShcImVsZW1lbnRhbC1pdGVtLWlkXCIpXG4gICAgY29uc3Qgc2VsZWN0b3IgPSBDU1MuZXNjYXBlKGl0ZW1JZClcbiAgICBjb25zdCBpdGVtRWwgPSBlbC5xdWVyeVNlbGVjdG9yKGAjJHtzZWxlY3Rvcn1gKVxuICAgIGl0ZW1FbC5kaXNhYmxlZCA9IGZhbHNlXG4gICAgZWwuY2xhc3NMaXN0LnJlbW92ZShcImhpZGRlblwiKVxuICB9LFxuXG4gIGhpZGVJdGVtKGVsKSB7XG4gICAgY29uc3QgaXRlbUlkID0gZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWl0ZW0taWRcIilcbiAgICBjb25zdCBzZWxlY3RvciA9IENTUy5lc2NhcGUoaXRlbUlkKVxuICAgIGNvbnN0IGl0ZW1FbCA9IGVsLnF1ZXJ5U2VsZWN0b3IoYCMke3NlbGVjdG9yfWApXG4gICAgaXRlbUVsLmRpc2FibGVkID0gdHJ1ZVxuICAgIGVsLmNsYXNzTGlzdC5hZGQoXCJoaWRkZW5cIilcbiAgfVxufVxuXG4vKipcbiAqIEFsbG93cyBmb3IgdXBkYXRpbmcgdGhlIGRyb3Bkb3duIHByb21wdCB3aXRoIHRoZSBzZWxlY3RlZCB2YWx1ZVxuICogZnJvbSB0aGUgb3B0aW9ucywgYWRkaXRpb25hbGx5IGNsb3NlcyB0aGUgZHJvcGRvd24gYnlcbiAqIHJlbW92aW5nIGZvY3VzLiBJbnRlbmRlZCBmb3IgaW50ZXJuYWwgdXNlIG9ubHkuXG4gKi9cbmV4cG9ydCBjb25zdCBFbGVtZW50YWxEcm9wZG93blNpbmdsZUl0ZW0gPSB7XG4gIG1vdW50ZWQoKSB7XG4gICAgLy8gVGhpcyBpcyBzaW1wbGUgYnV0IGRvZXMgdGhlIHRyaWNrIHNpbmNlIGl0IGlzIGludGVuZGVkIHRvIHdvcmtcbiAgICAvLyB3aXRoIHJhZGlvIGJ1dHRvbnMsIGkuZS4gY2xpY2sgaW1wbGllcyBzZWxlY3Rpb24uXG4gICAgdGhpcy5lbC5vbmNsaWNrID0gKCkgPT4ge1xuICAgICAgdGhpcy5jbG9zZURyb3Bkb3duKClcbiAgICAgIHRoaXMuaGlkZUFsbFByb21wdHMoKVxuICAgICAgdGhpcy5zaG93U2VsZWN0ZWRQcm9tcHQoKVxuICAgIH1cbiAgfSxcblxuXG4gIGhpZGVBbGxQcm9tcHRzKCkge1xuICAgIGNvbnN0IHByb21wdElkID0gdGhpcy5lbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaG9vay1wcm9tcHQtY29udGFpbmVyLWlkXCIpXG4gICAgY29uc3QgcHJvbXB0RWwgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChwcm9tcHRJZClcbiAgICBBcnJheS5mcm9tKHByb21wdEVsLmNoaWxkcmVuKS5mb3JFYWNoKChjaGlsZCkgPT4ge1xuICAgICAgY29uc3QgaXNTcGFuID0gY2hpbGQubm9kZU5hbWUgPT09IFwiU1BBTlwiXG4gICAgICBjb25zdCBjbGFzc0xpc3QgPSBjaGlsZC5jbGFzc0xpc3RcbiAgICAgIGlmIChpc1NwYW4gJiYgIWNsYXNzTGlzdC5jb250YWlucyhcImhpZGRlblwiKSkge1xuICAgICAgICBjbGFzc0xpc3QuYWRkKFwiaGlkZGVuXCIpXG4gICAgICB9IGVsc2UgaWYgKCFpc1NwYW4pIHtcbiAgICAgICAgY2hpbGQuc2V0QXR0cmlidXRlKFwicGxhY2Vob2xkZXJcIiwgXCIuLi5cIilcbiAgICAgIH1cbiAgICB9KVxuICB9LFxuXG4gIHNob3dTZWxlY3RlZFByb21wdCgpIHtcbiAgICBjb25zdCBkaXNwbGF5SWQgPSBgJHt0aGlzLmVsLmlkfV9kaXNwbGF5YFxuICAgIGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKGRpc3BsYXlJZCkuY2xhc3NMaXN0LnJlbW92ZShcImhpZGRlblwiKVxuICB9LFxuXG4gIGNsb3NlRHJvcGRvd24oKSB7XG4gICAgY29uc3QgY29udGVudElkID0gdGhpcy5lbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaG9vay1jb250YWluZXItaWRcIilcbiAgICBjb25zdCBjb250ZW50RWwgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChjb250ZW50SWQpXG4gICAgY29udGVudEVsLnJlbW92ZUF0dHJpYnV0ZShcIm9wZW5cIilcbiAgfVxufVxuXG4vKipcbiAqIEFsbG93cyBmb3IgdXBkYXRpbmcgdGhlIGRyb3Bkb3duIHByb21wdCB3aXRoIHRoZSBzZWxlY3RlZCB2YWx1ZVxuICogZnJvbSB0aGUgb3B0aW9ucy4gSW50ZW5kZWQgZm9yIGludGVybmFsIHVzZSBvbmx5LlxuICovXG5leHBvcnQgY29uc3QgRWxlbWVudGFsRHJvcGRvd25NdWx0aUl0ZW0gPSB7XG4gIG1vdW50ZWQoKSB7XG4gICAgdGhpcy5lbC5vbmNsaWNrID0gKCkgPT4ge1xuICAgICAgdGhpcy5oaWRlRGVmYXVsdFByb21wdCgpXG4gICAgICB0aGlzLnRvZ2dsZVNlbGYoKVxuICAgICAgdGhpcy5tYXliZVNob3dEZWZhdWx0UHJvbXB0KClcbiAgICB9XG4gIH0sXG5cbiAgaXNQcm9tcHRJbmxpbmVkKCkge1xuICAgIHJldHVybiB0aGlzLmVsLmdldEF0dHJpYnV0ZShcImVsZW1lbnRhbC1ob29rLXVzZXMtaW5saW5lZC1zZWFyY2hcIikgIT0gbnVsbFxuICB9LFxuXG4gIGhpZGVEZWZhdWx0UHJvbXB0KCkge1xuICAgIGNvbnN0IHByb21wdElkID0gdGhpcy5lbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaG9vay1kZWZhdWx0LXByb21wdC1pZFwiKVxuICAgIGNvbnN0IHByb21wdEVsID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQocHJvbXB0SWQpXG4gICAgaWYgKHByb21wdEVsLm5vZGVOYW1lID09PSBcIklOUFVUXCIpIHRoaXMuaGlkZVByb21wdFBsYWNlaG9sZGVyKHByb21wdEVsKVxuICAgIGVsc2UgdGhpcy5oaWRlUHJvbXB0U3Bhbihwcm9tcHRFbClcbiAgfSxcblxuICBoaWRlUHJvbXB0U3BhbihlbCkge1xuICAgIGlmICghZWwuY2xhc3NMaXN0LmNvbnRhaW5zKFwiaGlkZGVuXCIpKSB7XG4gICAgICBlbC5jbGFzc0xpc3QuYWRkKFwiaGlkZGVuXCIpXG4gICAgfVxuICB9LFxuXG4gIGhpZGVQcm9tcHRQbGFjZWhvbGRlcihlbCkge1xuICAgIGNvbnN0IHBsYWNlaG9sZGVyID0gZWwuZ2V0QXR0cmlidXRlKFwicGxhY2Vob2xkZXJcIilcbiAgICBjb25zdCBzYXZlZFBsYWNlaG9sZGVyID0gZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLXByaXZhdGUtcGxhY2Vob2xkZXJcIilcbiAgICBpZiAoc2F2ZWRQbGFjZWhvbGRlciA9PSBudWxsKSB7XG4gICAgICBlbC5zZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtcHJpdmF0ZS1wbGFjZWhvbGRlclwiLCBwbGFjZWhvbGRlcilcbiAgICAgIGVsLnNldEF0dHJpYnV0ZShcInBsYWNlaG9sZGVyXCIsIFwiLi4uXCIpXG4gICAgfVxuICB9LFxuXG4gIHNob3dEZWZhdWx0UHJvbXB0KCkge1xuICAgIGNvbnNvbGUubG9nKFwic2hvd0RlZmF1bHRQcm9tcHRcIilcbiAgICBjb25zdCBwcm9tcHRJZCA9IHRoaXMuZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWhvb2stZGVmYXVsdC1wcm9tcHQtaWRcIilcbiAgICBjb25zdCBwcm9tcHRFbCA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKHByb21wdElkKVxuICAgIGlmIChwcm9tcHRFbC5ub2RlTmFtZSA9PT0gXCJJTlBVVFwiKSB0aGlzLnNob3dQcm9tcHRQbGFjZWhvbGRlcihwcm9tcHRFbClcbiAgICBlbHNlIHRoaXMuc2hvd1Byb21wdFNwYW4ocHJvbXB0RWwpXG4gIH0sXG5cbiAgc2hvd1Byb21wdFNwYW4oZWwpIHtcbiAgICBpZiAoZWwuY2xhc3NMaXN0LmNvbnRhaW5zKFwiaGlkZGVuXCIpKSB7XG4gICAgICBlbC5jbGFzc0xpc3QucmVtb3ZlKFwiaGlkZGVuXCIpXG4gICAgfVxuICB9LFxuXG4gIHNob3dQcm9tcHRQbGFjZWhvbGRlcihlbCkge1xuICAgIGNvbnN0IHBsYWNlaG9sZGVyID0gZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLXByaXZhdGUtcGxhY2Vob2xkZXJcIilcbiAgICBjb25zb2xlLmxvZyh7IHBsYWNlaG9sZGVyIH0pXG4gICAgZWwuc2V0QXR0cmlidXRlKFwicGxhY2Vob2xkZXJcIiwgcGxhY2Vob2xkZXIpXG4gICAgZWwucmVtb3ZlQXR0cmlidXRlKFwiZWxlbWVudGFsLXByaXZhdGUtcGxhY2Vob2xkZXJcIilcbiAgfSxcblxuICB0b2dnbGVTZWxmKCkge1xuICAgIGNvbnN0IGRpc3BsYXlJZCA9IGAke3RoaXMuZWwuaWR9X2Rpc3BsYXlgXG4gICAgZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoZGlzcGxheUlkKS5jbGFzc0xpc3QudG9nZ2xlKFwiaGlkZGVuXCIpXG4gIH0sXG5cbiAgbWF5YmVTaG93RGVmYXVsdFByb21wdCgpIHtcbiAgICBjb25zdCBwcm9tcHRJZCA9IHRoaXMuZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWhvb2stcHJvbXB0LWNvbnRhaW5lci1pZFwiKVxuICAgIGNvbnN0IHByb21wdEVsID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQocHJvbXB0SWQpXG4gICAgY29uc3Qgbm9Qcm9tcHRTaG93biA9IEFycmF5LmZyb20ocHJvbXB0RWwuY2hpbGRyZW4pLmV2ZXJ5KChjaGlsZCkgPT4ge1xuICAgICAgY29uc3QgaXNJbnB1dCA9IGNoaWxkLm5vZGVOYW1lID09PSBcIklOUFVUXCJcbiAgICAgIGNvbnN0IGlzSGlkZGVuID0gY2hpbGQuY2xhc3NMaXN0LmNvbnRhaW5zKFwiaGlkZGVuXCIpXG4gICAgICAvLyBUaGlzIGlzIHRvIGhhbmRsZSBpbmxpbmVkIHNlYXJjaCBwcm9tcHQgY2FzZVxuICAgICAgcmV0dXJuIGlzSW5wdXQgfHwgaXNIaWRkZW5cbiAgICB9KVxuICAgIGlmIChub1Byb21wdFNob3duKSB0aGlzLnNob3dEZWZhdWx0UHJvbXB0KClcbiAgfVxufVxuIl0sCiAgIm1hcHBpbmdzIjogIjs7QUFXTyxNQUFNLDhCQUE4QjtBQUFBLElBQ3pDLFVBQVU7QUFDUixjQUFRLElB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
