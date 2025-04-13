(() => {
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
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsiLi4vLi4vLi4vLi4vYXNzZXRzL2pzL2hvb2tzL2Ryb3Bkb3duLmpzIl0sCiAgInNvdXJjZXNDb250ZW50IjogWyIvLyBTbWFsbCBoZWxwZXIgdG8gd3JhcCBhIGZ1bmN0aW9uIHdpdGggZGVib3VuY2UgYmVoYXZpb3VyLlxuZnVuY3Rpb24gZGVib3VuY2UoZnVuLCB0aW1lb3V0TXMpIHtcbiAgbGV0IHRpbWVyXG5cbiAgcmV0dXJuICguLi5hcmdzKSA9PiB7XG4gICAgY2xlYXJUaW1lb3V0KHRpbWVyKVxuICAgIHRpbWVyID0gc2V0VGltZW91dCgoKSA9PiBmdW4uYXBwbHkodGhpcywgYXJncyksIHRpbWVvdXRNcylcbiAgfVxufVxuXG4vKipcbiAqID4gSW1wbGVtZW50cyBjbGllbnQtc2lkZSB0ZXh0IHNlYXJjaCBmdW5jdGlvbmFsaXR5IG9uIGRyb3Bkb3ducy5cbiAqXG4gKiBQcm92aWRlIGNsaWVudCBzaWRlIGJlaGF2aW91ciBmb3IgdGhlIGRyb3Bkb3duIHNlYXJjaCBmdW5jdGlvbmFsaXR5LFxuICogaW50cm9kdWNlcyBhbiBgb25pbnB1dGAgZXZlbnQgbGlzdGVuZXIgdGhhdCBvbiBpbnB1dCBjaGFuZ2VzIHdpbGxcbiAqIGZpbHRlciB0aGUgZHJvcGRvd24gaXRlbXMgYmFzZWQgb24gdGhlIHNlYXJjaCByZXN1bHQuXG4gKlxuICogRmlsdGVyaW5nIGlzIHBlcmZvcm1lZCBieSBzaW1wbHkgZGlzYWJsaW5nIGFuZCBoaWRpbmcgaXRlbXMgdGhhdCBkb24ndFxuICogbWF0Y2ggdGhlIHNlYXJjaGVkIHRlcm0uXG4gKlxuICogTWF0Y2hpbmcgaXRzZWxmIGlzIHBlcmZvcm1lZCBieSBzaW1wbHkgZG93bmNhc2luZyBib3RoIHRoZSBgbGFiZWxgXG4gKiBvZiB0aGUgaXRlbSBhbmQgdGhlIGlucHV0dGVkIHRleHQsIGFuZCBjaGVja2luZyBpZiB0aGUgbGFiZWxcbiAqIGNvbnRhaW5zIHRoZSBpbnB1dHRlZCB0ZXh0LlxuICovXG5leHBvcnQgY29uc3QgRWxlbWVudGFsRHJvcGRvd25TZWFyY2ggPSB7XG4gIG1vdW50ZWQoKSB7XG4gICAgY29uc3QgY29udGVudElkID0gdGhpcy5lbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaG9vay1maWx0ZXJhYmxlLWNvbnRlbnQtaWRcIilcbiAgICBjb25zdCBjb250ZW50RWwgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChjb250ZW50SWQpXG4gICAgdGhpcy5lbC5vbmlucHV0ID0gZGVib3VuY2UoKCkgPT4gdGhpcy5maWx0ZXJTaWJsaW5nKGNvbnRlbnRFbCksIDEwMClcblxuICAgIGNvbnN0IGNvbnRhaW5lcklkID0gdGhpcy5lbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaG9vay1jb250YWluZXItaWRcIilcbiAgICBjb25zdCBjb250YWluZXJFbCA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKGNvbnRhaW5lcklkKVxuICAgIHRoaXMuZWwub25jbGljayA9ICgpID0+IGNvbnRhaW5lckVsLnNldEF0dHJpYnV0ZShcIm9wZW5cIiwgdHJ1ZSlcbiAgfSxcblxuICBmaWx0ZXJTaWJsaW5nKGNvbnRlbnRFbCkge1xuICAgIGNvbnN0IHRleHQgPSB0aGlzLmVsLnZhbHVlLnRvTG93ZXJDYXNlKClcbiAgICB0aGlzLmxpc3RBbGxJdGVtcyhjb250ZW50RWwpLmZvckVhY2goZWwgPT4ge1xuICAgICAgY29uc3QgbGFiZWwgPSBlbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtbGFiZWxcIikudG9Mb3dlckNhc2UoKVxuICAgICAgaWYgKGxhYmVsLmluY2x1ZGVzKHRleHQpKSB0aGlzLnNob3dJdGVtKGVsKVxuICAgICAgZWxzZSB0aGlzLmhpZGVJdGVtKGVsKVxuICAgIH0pXG4gIH0sXG5cbiAgbGlzdEFsbEl0ZW1zKGNvbnRlbnRFbCkge1xuICAgIHJldHVybiBBcnJheS5mcm9tKGNvbnRlbnRFbC5jaGlsZHJlbikuZmlsdGVyKGNoaWxkID0+IGNoaWxkICE9PSB0aGlzLmVsKVxuICB9LFxuXG4gIHNob3dJdGVtKGVsKSB7XG4gICAgY29uc3QgaXRlbUlkID0gZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWl0ZW0taWRcIilcbiAgICBjb25zdCBzZWxlY3RvciA9IENTUy5lc2NhcGUoaXRlbUlkKVxuICAgIGNvbnN0IGl0ZW1FbCA9IGVsLnF1ZXJ5U2VsZWN0b3IoYCMke3NlbGVjdG9yfWApXG4gICAgaXRlbUVsLmRpc2FibGVkID0gZmFsc2VcbiAgICBlbC5jbGFzc0xpc3QucmVtb3ZlKFwiaGlkZGVuXCIpXG4gIH0sXG5cbiAgaGlkZUl0ZW0oZWwpIHtcbiAgICBjb25zdCBpdGVtSWQgPSBlbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaXRlbS1pZFwiKVxuICAgIGNvbnN0IHNlbGVjdG9yID0gQ1NTLmVzY2FwZShpdGVtSWQpXG4gICAgY29uc3QgaXRlbUVsID0gZWwucXVlcnlTZWxlY3RvcihgIyR7c2VsZWN0b3J9YClcbiAgICBpdGVtRWwuZGlzYWJsZWQgPSB0cnVlXG4gICAgZWwuY2xhc3NMaXN0LmFkZChcImhpZGRlblwiKVxuICB9XG59XG5cbi8qKlxuICogQWxsb3dzIGZvciB1cGRhdGluZyB0aGUgZHJvcGRvd24gcHJvbXB0IHdpdGggdGhlIHNlbGVjdGVkIHZhbHVlXG4gKiBmcm9tIHRoZSBvcHRpb25zLCBhZGRpdGlvbmFsbHkgY2xvc2VzIHRoZSBkcm9wZG93biBieVxuICogcmVtb3ZpbmcgZm9jdXMuIEludGVuZGVkIGZvciBpbnRlcm5hbCB1c2Ugb25seS5cbiAqL1xuZXhwb3J0IGNvbnN0IEVsZW1lbnRhbERyb3Bkb3duU2luZ2xlSXRlbSA9IHtcbiAgbW91bnRlZCgpIHtcbiAgICAvLyBUaGlzIGlzIHNpbXBsZSBidXQgZG9lcyB0aGUgdHJpY2sgc2luY2UgaXQgaXMgaW50ZW5kZWQgdG8gd29ya1xuICAgIC8vIHdpdGggcmFkaW8gYnV0dG9ucywgaS5lLiBjbGljayBpbXBsaWVzIHNlbGVjdGlvbi5cbiAgICB0aGlzLmVsLm9uY2xpY2sgPSAoKSA9PiB7XG4gICAgICB0aGlzLmNsb3NlRHJvcGRvd24oKVxuICAgICAgdGhpcy5oaWRlQWxsUHJvbXB0cygpXG4gICAgICB0aGlzLnNob3dTZWxlY3RlZFByb21wdCgpXG4gICAgfVxuICB9LFxuXG5cbiAgaGlkZUFsbFByb21wdHMoKSB7XG4gICAgY29uc3QgcHJvbXB0SWQgPSB0aGlzLmVsLmdldEF0dHJpYnV0ZShcImVsZW1lbnRhbC1ob29rLXByb21wdC1jb250YWluZXItaWRcIilcbiAgICBjb25zdCBwcm9tcHRFbCA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKHByb21wdElkKVxuICAgIEFycmF5LmZyb20ocHJvbXB0RWwuY2hpbGRyZW4pLmZvckVhY2goKGNoaWxkKSA9PiB7XG4gICAgICBjb25zdCBpc1NwYW4gPSBjaGlsZC5ub2RlTmFtZSA9PT0gXCJTUEFOXCJcbiAgICAgIGNvbnN0IGNsYXNzTGlzdCA9IGNoaWxkLmNsYXNzTGlzdFxuICAgICAgaWYgKGlzU3BhbiAmJiAhY2xhc3NMaXN0LmNvbnRhaW5zKFwiaGlkZGVuXCIpKSB7XG4gICAgICAgIGNsYXNzTGlzdC5hZGQoXCJoaWRkZW5cIilcbiAgICAgIH0gZWxzZSBpZiAoIWlzU3Bhbikge1xuICAgICAgICBjaGlsZC5zZXRBdHRyaWJ1dGUoXCJwbGFjZWhvbGRlclwiLCBcIi4uLlwiKVxuICAgICAgfVxuICAgIH0pXG4gIH0sXG5cbiAgc2hvd1NlbGVjdGVkUHJvbXB0KCkge1xuICAgIGNvbnN0IGRpc3BsYXlJZCA9IGAke3RoaXMuZWwuaWR9X2Rpc3BsYXlgXG4gICAgZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQoZGlzcGxheUlkKS5jbGFzc0xpc3QucmVtb3ZlKFwiaGlkZGVuXCIpXG4gIH0sXG5cbiAgY2xvc2VEcm9wZG93bigpIHtcbiAgICBjb25zdCBjb250ZW50SWQgPSB0aGlzLmVsLmdldEF0dHJpYnV0ZShcImVsZW1lbnRhbC1ob29rLWNvbnRhaW5lci1pZFwiKVxuICAgIGNvbnN0IGNvbnRlbnRFbCA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKGNvbnRlbnRJZClcbiAgICBjb250ZW50RWwucmVtb3ZlQXR0cmlidXRlKFwib3BlblwiKVxuICB9XG59XG5cbi8qKlxuICogQWxsb3dzIGZvciB1cGRhdGluZyB0aGUgZHJvcGRvd24gcHJvbXB0IHdpdGggdGhlIHNlbGVjdGVkIHZhbHVlXG4gKiBmcm9tIHRoZSBvcHRpb25zLiBJbnRlbmRlZCBmb3IgaW50ZXJuYWwgdXNlIG9ubHkuXG4gKi9cbmV4cG9ydCBjb25zdCBFbGVtZW50YWxEcm9wZG93bk11bHRpSXRlbSA9IHtcbiAgbW91bnRlZCgpIHtcbiAgICB0aGlzLmVsLm9uY2xpY2sgPSAoKSA9PiB7XG4gICAgICB0aGlzLmhpZGVEZWZhdWx0UHJvbXB0KClcbiAgICAgIHRoaXMudG9nZ2xlU2VsZigpXG4gICAgICB0aGlzLm1heWJlU2hvd0RlZmF1bHRQcm9tcHQoKVxuICAgIH1cbiAgfSxcblxuICBpc1Byb21wdElubGluZWQoKSB7XG4gICAgcmV0dXJuIHRoaXMuZWwuZ2V0QXR0cmlidXRlKFwiZWxlbWVudGFsLWhvb2stdXNlcy1pbmxpbmVkLXNlYXJjaFwiKSAhPSBudWxsXG4gIH0sXG5cbiAgaGlkZURlZmF1bHRQcm9tcHQoKSB7XG4gICAgY29uc3QgcHJvbXB0SWQgPSB0aGlzLmVsLmdldEF0dHJpYnV0ZShcImVsZW1lbnRhbC1ob29rLWRlZmF1bHQtcHJvbXB0LWlkXCIpXG4gICAgY29uc3QgcHJvbXB0RWwgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChwcm9tcHRJZClcbiAgICBpZiAocHJvbXB0RWwubm9kZU5hbWUgPT09IFwiSU5QVVRcIikgdGhpcy5oaWRlUHJvbXB0UGxhY2Vob2xkZXIocHJvbXB0RWwpXG4gICAgZWxzZSB0aGlzLmhpZGVQcm9tcHRTcGFuKHByb21wdEVsKVxuICB9LFxuXG4gIGhpZGVQcm9tcHRTcGFuKGVsKSB7XG4gICAgaWYgKCFlbC5jbGFzc0xpc3QuY29udGFpbnMoXCJoaWRkZW5cIikpIHtcbiAgICAgIGVsLmNsYXNzTGlzdC5hZGQoXCJoaWRkZW5cIilcbiAgICB9XG4gIH0sXG5cbiAgaGlkZVByb21wdFBsYWNlaG9sZGVyKGVsKSB7XG4gICAgY29uc3QgcGxhY2Vob2xkZXIgPSBlbC5nZXRBdHRyaWJ1dGUoXCJwbGFjZWhvbGRlclwiKVxuICAgIGNvbnN0IHNhdmVkUGxhY2Vob2xkZXIgPSBlbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtcHJpdmF0ZS1wbGFjZWhvbGRlclwiKVxuICAgIGlmIChzYXZlZFBsYWNlaG9sZGVyID09IG51bGwpIHtcbiAgICAgIGVsLnNldEF0dHJpYnV0ZShcImVsZW1lbnRhbC1wcml2YXRlLXBsYWNlaG9sZGVyXCIsIHBsYWNlaG9sZGVyKVxuICAgICAgZWwuc2V0QXR0cmlidXRlKFwicGxhY2Vob2xkZXJcIiwgXCIuLi5cIilcbiAgICB9XG4gIH0sXG5cbiAgc2hvd0RlZmF1bHRQcm9tcHQoKSB7XG4gICAgY29uc29sZS5sb2coXCJzaG93RGVmYXVsdFByb21wdFwiKVxuICAgIGNvbnN0IHByb21wdElkID0gdGhpcy5lbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaG9vay1kZWZhdWx0LXByb21wdC1pZFwiKVxuICAgIGNvbnN0IHByb21wdEVsID0gZG9jdW1lbnQuZ2V0RWxlbWVudEJ5SWQocHJvbXB0SWQpXG4gICAgaWYgKHByb21wdEVsLm5vZGVOYW1lID09PSBcIklOUFVUXCIpIHRoaXMuc2hvd1Byb21wdFBsYWNlaG9sZGVyKHByb21wdEVsKVxuICAgIGVsc2UgdGhpcy5zaG93UHJvbXB0U3Bhbihwcm9tcHRFbClcbiAgfSxcblxuICBzaG93UHJvbXB0U3BhbihlbCkge1xuICAgIGlmIChlbC5jbGFzc0xpc3QuY29udGFpbnMoXCJoaWRkZW5cIikpIHtcbiAgICAgIGVsLmNsYXNzTGlzdC5yZW1vdmUoXCJoaWRkZW5cIilcbiAgICB9XG4gIH0sXG5cbiAgc2hvd1Byb21wdFBsYWNlaG9sZGVyKGVsKSB7XG4gICAgY29uc3QgcGxhY2Vob2xkZXIgPSBlbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtcHJpdmF0ZS1wbGFjZWhvbGRlclwiKVxuICAgIGNvbnNvbGUubG9nKHsgcGxhY2Vob2xkZXIgfSlcbiAgICBlbC5zZXRBdHRyaWJ1dGUoXCJwbGFjZWhvbGRlclwiLCBwbGFjZWhvbGRlcilcbiAgICBlbC5yZW1vdmVBdHRyaWJ1dGUoXCJlbGVtZW50YWwtcHJpdmF0ZS1wbGFjZWhvbGRlclwiKVxuICB9LFxuXG4gIHRvZ2dsZVNlbGYoKSB7XG4gICAgY29uc3QgZGlzcGxheUlkID0gYCR7dGhpcy5lbC5pZH1fZGlzcGxheWBcbiAgICBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChkaXNwbGF5SWQpLmNsYXNzTGlzdC50b2dnbGUoXCJoaWRkZW5cIilcbiAgfSxcblxuICBtYXliZVNob3dEZWZhdWx0UHJvbXB0KCkge1xuICAgIGNvbnN0IHByb21wdElkID0gdGhpcy5lbC5nZXRBdHRyaWJ1dGUoXCJlbGVtZW50YWwtaG9vay1wcm9tcHQtY29udGFpbmVyLWlkXCIpXG4gICAgY29uc3QgcHJvbXB0RWwgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZChwcm9tcHRJZClcbiAgICBjb25zdCBub1Byb21wdFNob3duID0gQXJyYXkuZnJvbShwcm9tcHRFbC5jaGlsZHJlbikuZXZlcnkoKGNoaWxkKSA9PiB7XG4gICAgICBjb25zdCBpc0lucHV0ID0gY2hpbGQubm9kZU5hbWUgPT09IFwiSU5QVVRcIlxuICAgICAgY29uc3QgaXNIaWRkZW4gPSBjaGlsZC5jbGFzc0xpc3QuY29udGFpbnMoXCJoaWRkZW5cIilcbiAgICAgIC8vIFRoaXMgaXMgdG8gaGFuZGxlIGlubGluZWQgc2VhcmNoIHByb21wdCBjYXNlXG4gICAgICByZXR1cm4gaXNJbnB1dCB8fCBpc0hpZGRlblxuICAgIH0pXG4gICAgaWYgKG5vUHJvbXB0U2hvd24pIHRoaXMuc2hvd0RlZmF1bHRQcm9tcHQoKVxuICB9XG59XG4iXSwKICAibWFwcGluZ3MiOiAiOztBQUNBLFdBQVMsU0FBUyxLQUFLLFdBQVc7QUFDaEMsUUFBSTtBQUVKLFdBQU8sSUFBSSxTQUFTO0FBQ2xCLG1CQUFhLEtBQUs7QUFDbEIsY0FBUSxXQUFXLE1BQU0sSUFBSSxNQUFNLE1BQU0sSUFBSSxHQUFHLFNBQVM7QUFBQSxJQUMzRDtBQUFBLEVBQ0Y7QUFnQk8sTUFBTSwwQkFBMEI7QUFBQSxJQUNyQyxVQUFVO0FBQ1IsWUFBTSxZQUFZLEtBQUssR0FBRyxhQUFhLHNDQUFzQztBQUM3RSxZQUFNLFlBQVksU0FBUyxlQUFlLFNBQVM7QUFDbkQsV0FBSyxHQUFHLFVBQVUsU0FBUyxNQUFNLEtBQUssY0FBYyxTQUFTLEdBQUcsR0FBRztBQUVuRSxZQUFNLGNBQWMsS0FBSyxHQUFHLGFBQWEsNkJBQTZCO0FBQ3RFLFlBQU0sY0FBYyxTQUFTLGVBQWUsV0FBVztBQUN2RCxXQUFLLEdBQUcsVUFBVSxNQUFNLFlBQVksYUFBYSxRQUFRLElBQUk7QUFBQSxJQUMvRDtBQUFBLElBRUEsY0FBYyxXQUFXO0FBQ3ZCLFlBQU0sT0FBTyxLQUFLLEdBQUcsTUFBTSxZQUFZO0FBQ3ZDLFdBQUssYUFBYSxTQUFTLEVBQUUsUUFBUSxRQUFNO0FBQ3pDLGNBQU0sUUFBUSxHQUFHLGFBQWEsaUJBQWlCLEVBQUUsWUFBWTtBQUM3RCxZQUFJLE1BQU0sU0FBUyxJQUFJLEVBQUcsTUFBSyxTQUFTLEVBQUU7QUFBQSxZQUNyQyxNQUFLLFNBQVMsRUFBRTtBQUFBLE1BQ3ZCLENBQUM7QUFBQSxJQUNIO0FBQUEsSUFFQSxhQUFhLFdBQVc7QUFDdEIsYUFBTyxNQUFNLEtBQUssVUFBVSxRQUFRLEVBQUUsT0FBTyxXQUFTLFVBQVUsS0FBSyxFQUFFO0FBQUEsSUFDekU7QUFBQSxJQUVBLFNBQVMsSUFBSTtBQUNYLFlBQU0sU0FBUyxHQUFHLGFBQWEsbUJBQW1CO0FBQ2xELFlBQU0sV0FBVyxJQUFJLE9BQU8sTUFBTTtBQUNsQyxZQUFNLFNBQVMsR0FBRyxjQUFjLElBQUksUUFBUSxFQUFFO0FBQzlDLGFBQU8sV0FBVztBQUNsQixTQUFHLFVBQVUsT0FBTyxRQUFRO0FBQUEsSUFDOUI7QUFBQSxJQUVBLFNBQVMsSUFBSTtBQUNYLFlBQU0sU0FBUyxHQUFHLGFBQWEsbUJBQW1CO0FBQ2xELFlBQU0sV0FBVyxJQUFJLE9BQU8sTUFBTTtBQUNsQyxZQUFNLFNBQVMsR0FBRyxjQUFjLElBQUksUUFBUSxFQUFFO0FBQzlDLGFBQU8sV0FBVztBQUNsQixTQUFHLFVBQVUsSUFBSSxRQUFRO0FBQUEsSUFDM0I7QUFBQSxFQUNGO0FBT08sTUFBTSw4QkFBOEI7QUFBQSxJQUN6QyxVQUFVO0FBR1IsV0FBSyxHQUFHLFVBQVUsTUFBTTtBQUN0QixhQUFLLGNBQWM7QUFDbkIsYUFBSyxlQUFlO0FBQ3BCLGFBQUssbUJBQW1CO0FBQUEsTUFDMUI7QUFBQSxJQUNGO0FBQUEsSUFHQSxpQkFBaUI7QUFDZixZQUFNLFdBQVcsS0FBSyxHQUFHLGFBQWEsb0NBQW9DO0FBQzFFLFlBQU0sV0FBVyxTQUFTLGVBQWUsUUFBUTtBQUNqRCxZQUFNLEtBQUssU0FBUyxRQUFRLEVBQUUsUUFBUSxDQUFDLFVBQVU7QUFDL0MsY0FBTSxTQUFTLE1BQU0sYUFBYTtBQUNsQyxjQUFNLFlBQVksTUFBTTtBQUN4QixZQUFJLFVBQVUsQ0FBQyxVQUFVLFNBQVMsUUFBUSxHQUFHO0FBQzNDLG9CQUFVLElBQUksUUFBUTtBQUFBLFFBQ3hCLFdBQVcsQ0FBQyxRQUFRO0FBQ2xCLGdCQUFNLGFBQWEsZUFBZSxLQUFLO0FBQUEsUUFDekM7QUFBQSxNQUNGLENBQUM7QUFBQSxJQUNIO0FBQUEsSUFFQSxxQkFBcUI7QUFDbkIsWUFBTSxZQUFZLEdBQUcsS0FBSyxHQUFHLEVBQUU7QUFDL0IsZUFBUyxlQUFlLFNBQVMsRUFBRSxVQUFVLE9BQU8sUUFBUTtBQUFBLElBQzlEO0FBQUEsSUFFQSxnQkFBZ0I7QUFDZCxZQUFNLFlBQVksS0FBSyxHQUFHLGFBQWEsNkJBQTZCO0FBQ3BFLFlBQU0sWUFBWSxTQUFTLGVBQWUsU0FBUztBQUNuRCxnQkFBVSxnQkFBZ0IsTUFBTTtBQUFBLElBQ2xDO0FBQUEsRUFDRjtBQU1PLE1BQU0sNkJBQTZCO0FBQUEsSUFDeEMsVUFBVTtBQUNSLFdBQUssR0FBRyxVQUFVLE1BQU07QUFDdEIsYUFBSyxrQkFBa0I7QUFDdkIsYUFBSyxXQUFXO0FBQ2hCLGFBQUssdUJBQXVCO0FBQUEsTUFDOUI7QUFBQSxJQUNGO0FBQUEsSUFFQSxrQkFBa0I7QUFDaEIsYUFBTyxLQUFLLEdBQUcsYUFBYSxvQ0FBb0MsS0FBSztBQUFBLElBQ3ZFO0FBQUEsSUFFQSxvQkFBb0I7QUFDbEIsWUFBTSxXQUFXLEtBQUssR0FBRyxhQUFhLGtDQUFrQztBQUN4RSxZQUFNLFdBQVcsU0FBUyxlQUFlLFFBQVE7QUFDakQsVUFBSSxTQUFTLGFBQWEsUUFBUyxNQUFLLHNCQUFzQixRQUFRO0FBQUEsVUFDakUsTUFBSyxlQUFlLFFBQVE7QUFBQSxJQUNuQztBQUFBLElBRUEsZUFBZSxJQUFJO0FBQ2pCLFVBQUksQ0FBQyxHQUFHLFVBQVUsU0FBUyxRQUFRLEdBQUc7QUFDcEMsV0FBRyxVQUFVLElBQUksUUFBUTtBQUFBLE1BQzNCO0FBQUEsSUFDRjtBQUFBLElBRUEsc0JBQXNCLElBQUk7QUFDeEIsWUFBTSxjQUFjLEdBQUcsYUFBYSxhQUFhO0FBQ2pELFlBQU0sbUJBQW1CLEdBQUcsYUFBYSwrQkFBK0I7QUFDeEUsVUFBSSxvQkFBb0IsTUFBTTtBQUM1QixXQUFHLGFBQWEsaUNBQWlDLFdBQVc7QUFDNUQsV0FBRyxhQUFhLGVBQWUsS0FBSztBQUFBLE1BQ3RDO0FBQUEsSUFDRjtBQUFBLElBRUEsb0JBQW9CO0FBQ2xCLGNBQVEsSUFBSSxtQkFBbUI7QUFDL0IsWUFBTSxXQUFXLEtBQUssR0FBRyxhQUFhLGtDQUFrQztBQUN4RSxZQUFNLFdBQVcsU0FBUyxlQUFlLFFBQVE7QUFDakQsVUFBSSxTQUFTLGFBQWEsUUFBUyxNQUFLLHNCQUFzQixRQUFRO0FBQUEsVUFDakUsTUFBSyxlQUFlLFFBQVE7QUFBQSxJQUNuQztBQUFBLElBRUEsZUFBZSxJQUFJO0FBQ2pCLFVBQUksR0FBRyxVQUFVLFNBQVMsUUFBUSxHQUFHO0FBQ25DLFdBQUcsVUFBVSxPQUFPLFFBQVE7QUFBQSxNQUM5QjtBQUFBLElBQ0Y7QUFBQSxJQUVBLHNCQUFzQixJQUFJO0FBQ3hCLFlBQU0sY0FBYyxHQUFHLGFBQWEsK0JBQStCO0FBQ25FLGNBQVEsSUFBSSxFQUFFLFlBQVksQ0FBQztBQUMzQixTQUFHLGFBQWEsZUFBZSxXQUFXO0FBQzFDLFNBQUcsZ0JBQWdCLCtCQUErQjtBQUFBLElBQ3BEO0FBQUEsSUFFQSxhQUFhO0FBQ1gsWUFBTSxZQUFZLEdBQUcsS0FBSyxHQUFHLEVBQUU7QUFDL0IsZUFBUyxlQUFlLFNBQVMsRUFBRSxVQUFVLE9BQU8sUUFBUTtBQUFBLElBQzlEO0FBQUEsSUFFQSx5QkFBeUI7QUFDdkIsWUFBTSxXQUFXLEtBQUssR0FBRyxhQUFhLG9DQUFvQztBQUMxRSxZQUFNLFdBQVcsU0FBUyxlQUFlLFFBQVE7QUFDakQsWUFBTSxnQkFBZ0IsTUFBTSxLQUFLLFNBQVMsUUFBUSxFQUFFLE1BQU0sQ0FBQyxVQUFVO0FBQ25FLGNBQU0sVUFBVSxNQUFNLGFBQWE7QUFDbkMsY0FBTSxXQUFXLE1BQU0sVUFBVSxTQUFTLFFBQVE7QUFFbEQsZUFBTyxXQUFXO0FBQUEsTUFDcEIsQ0FBQztBQUNELFVBQUksY0FBZSxNQUFLLGtCQUFrQjtBQUFBLElBQzVDO0FBQUEsRUFDRjsiLAogICJuYW1lcyI6IFtdCn0K
