/**
 * Simple helper to set a checkbox to the indeterminate state upon
 * first mounting. Primarily used for the`Elemental.Actions.Swap`
 * component to support the `indeterminate` option.
 */
export const ElementalIndeterminateCheckbox = {
  mounted() { this.el.indeterminate = true }
}
