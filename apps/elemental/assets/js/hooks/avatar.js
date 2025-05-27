// Small helper to check if the image is OK
function isImgOk(img) {
  if (!img.complete) return "loading"
  if (img.naturalWidth === 0 && img.naturalHeight === 0) return "errored"
  return "ok"
}

/**
 * Simple hook to handle on-error when loading images for the Avatar component.
 * If an error happens this will hide the image and show the
 * placeholder if provided.
 */
export const ElementalAvatar = {
  mounted() {
    const imgId = `${this.el.id}__img`
    const imgEl = document.getElementById(imgId)
    if (imgEl == null) return
    this.mountOnError(imgEl)
  },

  mountOnError(imgEl) {
    switch (isImgOk(imgEl)) {
      // If the image is still loading set an onerror callback
      case "loading": imgEl.onerror = this.onError.bind(this, imgEl)
        break

      // If the image already failed, call the callback
      case "errored": onError(imgEl)
        break

      // If all is good do nothing
      case "ok": return
    }
  },

  onError(imgEl) {
    this.hideEl(imgEl)

    const placeholderId = `${this.el.id}__placeholder`
    const placeholderEl = document.getElementById(placeholderId)
    if (placeholderEl != null) this.showPlaceholder(placeholderEl)
  },

  hideEl(el) { el.setAttribute("hidden", "hidden") },

  showPlaceholder(placeholderEl) {
    this.el.classList.add("avatar-placeholder")
    placeholderEl.removeAttribute("hidden")
  }
}
