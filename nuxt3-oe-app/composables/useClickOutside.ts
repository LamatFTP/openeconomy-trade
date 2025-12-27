/**
 * Click Outside Composable
 * Detects clicks outside an element
 */

import { onMounted, onUnmounted, type Ref } from 'vue'

export function useClickOutside(
  target: Ref<HTMLElement | null>,
  callback: (event: MouseEvent) => void
) {
  function handleClick(event: MouseEvent) {
    if (!target.value) return
    
    const path = event.composedPath()
    if (!path.includes(target.value)) {
      callback(event)
    }
  }

  onMounted(() => {
    document.addEventListener('click', handleClick, true)
  })

  onUnmounted(() => {
    document.removeEventListener('click', handleClick, true)
  })
}
