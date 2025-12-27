/**
 * Modal Composable
 * Manages modal state with stacking support
 */

import { ref, computed } from 'vue'

interface ModalState {
  id: string
  component?: Component
  props?: Record<string, unknown>
}

const modalStack = ref<ModalState[]>([])
const isLocked = ref(false)

export function useModal() {
  const isOpen = computed(() => modalStack.value.length > 0)
  const current = computed(() => modalStack.value[modalStack.value.length - 1])

  function open(id: string, options?: { component?: Component; props?: Record<string, unknown> }) {
    if (isLocked.value) return
    
    modalStack.value.push({
      id,
      component: options?.component,
      props: options?.props,
    })
    
    // Lock body scroll
    if (typeof document !== 'undefined') {
      document.body.style.overflow = 'hidden'
    }
  }

  function close(id?: string) {
    if (id) {
      modalStack.value = modalStack.value.filter(m => m.id !== id)
    } else {
      modalStack.value.pop()
    }

    // Unlock body scroll if no modals
    if (modalStack.value.length === 0 && typeof document !== 'undefined') {
      document.body.style.overflow = ''
    }
  }

  function closeAll() {
    modalStack.value = []
    if (typeof document !== 'undefined') {
      document.body.style.overflow = ''
    }
  }

  function lock() {
    isLocked.value = true
  }

  function unlock() {
    isLocked.value = false
  }

  return {
    isOpen,
    current,
    stack: modalStack,
    open,
    close,
    closeAll,
    lock,
    unlock,
  }
}
