/**
 * Toast Store
 * Global toast notification state
 */

import { defineStore } from "pinia";
import { ref, computed } from "vue";

export type ToastType = "success" | "error" | "warning" | "info";

export interface Toast {
  id: string;
  type: ToastType;
  message: string;
  duration?: number;
  action?: {
    label: string;
    onClick: () => void;
  };
}

export const useToastStore = defineStore("toast", () => {
  const toasts = ref<Toast[]>([]);
  const maxToasts = 5;
  const defaultDuration = 5000;

  const activeToasts = computed(() => toasts.value.slice(0, maxToasts));

  function add(options: Omit<Toast, "id"> & { id?: string }) {
    const id =
      options.id ||
      `toast-${Date.now()}-${Math.random().toString(36).slice(2)}`;
    const duration = options.duration ?? defaultDuration;

    const toast: Toast = {
      id,
      type: options.type,
      message: options.message,
      duration,
      action: options.action,
    };

    toasts.value.push(toast);

    // Auto dismiss
    if (duration > 0) {
      setTimeout(() => {
        dismiss(id);
      }, duration);
    }

    return id;
  }

  function dismiss(id: string) {
    const index = toasts.value.findIndex((t) => t.id === id);
    if (index > -1) {
      toasts.value.splice(index, 1);
    }
  }

  function dismissAll() {
    toasts.value = [];
  }

  return {
    toasts,
    activeToasts,
    add,
    dismiss,
    dismissAll,
  };
});
