<script setup lang="ts">
/**
 * UToastContainer - Global toast notifications
 * Auto-positioned, animated, dismissable
 */

const toastStore = useToastStore()

const iconMap = {
  success: 'ph:check-circle-fill',
  error: 'ph:x-circle-fill',
  warning: 'ph:warning-fill',
  info: 'ph:info-fill',
}

const colorMap = {
  success: 'bg-green-50 border-green-200 text-green-800 dark:bg-green-900/20 dark:border-green-800 dark:text-green-300',
  error: 'bg-red-50 border-red-200 text-red-800 dark:bg-red-900/20 dark:border-red-800 dark:text-red-300',
  warning: 'bg-amber-50 border-amber-200 text-amber-800 dark:bg-amber-900/20 dark:border-amber-800 dark:text-amber-300',
  info: 'bg-blue-50 border-blue-200 text-blue-800 dark:bg-blue-900/20 dark:border-blue-800 dark:text-blue-300',
}

const iconColorMap = {
  success: 'text-green-500',
  error: 'text-red-500',
  warning: 'text-amber-500',
  info: 'text-blue-500',
}
</script>

<template>
  <Teleport to="body">
    <div class="fixed bottom-0 right-0 z-[100] flex flex-col gap-2 p-4 sm:bottom-4 sm:right-4">
      <TransitionGroup
        enter-active-class="duration-300 ease-out"
        enter-from-class="opacity-0 translate-y-4 scale-95"
        enter-to-class="opacity-100 translate-y-0 scale-100"
        leave-active-class="duration-200 ease-in"
        leave-from-class="opacity-100 translate-y-0 scale-100"
        leave-to-class="opacity-0 translate-y-4 scale-95"
        move-class="duration-200 ease-out"
      >
        <div
          v-for="toast in toastStore.activeToasts"
          :key="toast.id"
          :class="[
            'flex w-full max-w-sm items-start gap-3 rounded-lg border p-4 shadow-lg backdrop-blur',
            colorMap[toast.type]
          ]"
        >
          <!-- Icon -->
          <Icon 
            :name="iconMap[toast.type]" 
            :class="['h-5 w-5 flex-shrink-0', iconColorMap[toast.type]]"
          />

          <!-- Content -->
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium">{{ toast.message }}</p>
            
            <!-- Action button -->
            <button
              v-if="toast.action"
              class="mt-2 text-sm font-medium underline-offset-2 hover:underline"
              @click="toast.action.onClick"
            >
              {{ toast.action.label }}
            </button>
          </div>

          <!-- Dismiss button -->
          <button
            class="flex-shrink-0 rounded p-1 opacity-70 hover:opacity-100"
            @click="toastStore.dismiss(toast.id)"
          >
            <Icon name="ph:x" class="h-4 w-4" />
          </button>
        </div>
      </TransitionGroup>
    </div>
  </Teleport>
</template>
