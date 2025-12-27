/**
 * Toast Composable
 * Usage: const { toast } = useToast()
 *        toast.success('Done!')
 */

import { useToastStore } from '~/stores/toast'

export function useToast() {
  const store = useToastStore()

  return {
    toast: {
      success: (message: string, options?: ToastOptions) => 
        store.add({ type: 'success', message, ...options }),
      
      error: (message: string, options?: ToastOptions) => 
        store.add({ type: 'error', message, ...options }),
      
      warning: (message: string, options?: ToastOptions) => 
        store.add({ type: 'warning', message, ...options }),
      
      info: (message: string, options?: ToastOptions) => 
        store.add({ type: 'info', message, ...options }),
    },
    dismiss: store.dismiss,
    dismissAll: store.dismissAll,
  }
}

export interface ToastOptions {
  duration?: number
  action?: {
    label: string
    onClick: () => void
  }
}
