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
export const ElementalSelectLabelAdapter = {
  mounted() { this.el.onclick = () => this.selectMouseDown() },

  selectMouseDown() {
    const selectId = `${this.el.id}__select`
    const selectEl = document.getElementById(selectId)
    const mousedown = new MouseEvent("mousedown")
    selectEl.dispatchEvent(mousedown)
  }
}
