<script setup lang="ts">
/**
 * UModal - Base modal component
 * Supports sizes, close on ESC/backdrop
 */

interface Props {
  modelValue?: boolean
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full'
  closeable?: boolean
  title?: string
  description?: string
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  size: 'md',
  closeable: true,
})

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  close: []
}>()

const isOpen = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})

const sizeClasses = {
  sm: 'max-w-sm',
  md: 'max-w-md',
  lg: 'max-w-lg',
  xl: 'max-w-xl',
  full: 'max-w-full mx-4',
}

function close() {
  if (props.closeable) {
    isOpen.value = false
    emit('close')
  }
}

// Close on ESC
function handleKeydown(event: KeyboardEvent) {
  if (event.key === 'Escape' && props.closeable) {
    close()
  }
}

// Lock body scroll when open
watch(isOpen, (open) => {
  if (typeof document !== 'undefined') {
    document.body.style.overflow = open ? 'hidden' : ''
    
    if (open) {
      document.addEventListener('keydown', handleKeydown)
    } else {
      document.removeEventListener('keydown', handleKeydown)
    }
  }
})

onUnmounted(() => {
  if (typeof document !== 'undefined') {
    document.body.style.overflow = ''
    document.removeEventListener('keydown', handleKeydown)
  }
})
</script>

<template>
  <Teleport to="body">
    <Transition
      enter-active-class="duration-200 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="duration-150 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="isOpen"
        class="fixed inset-0 z-50 flex items-center justify-center p-4"
      >
        <!-- Backdrop -->
        <div
          class="absolute inset-0 bg-black/50 backdrop-blur-sm"
          @click="close"
        />

        <!-- Modal panel -->
        <Transition
          enter-active-class="duration-200 ease-out"
          enter-from-class="opacity-0 scale-95"
          enter-to-class="opacity-100 scale-100"
          leave-active-class="duration-150 ease-in"
          leave-from-class="opacity-100 scale-100"
          leave-to-class="opacity-0 scale-95"
        >
          <div
            v-if="isOpen"
            :class="[
              'relative w-full rounded-2xl bg-white p-6 shadow-xl dark:bg-slate-900',
              sizeClasses[size]
            ]"
          >
            <!-- Close button -->
            <button
              v-if="closeable"
              class="absolute right-4 top-4 rounded-lg p-1 text-slate-400 hover:bg-slate-100 hover:text-slate-600 dark:hover:bg-slate-800"
              @click="close"
            >
              <Icon name="ph:x" class="h-5 w-5" />
            </button>

            <!-- Header -->
            <div v-if="title || $slots.header" class="mb-4">
              <slot name="header">
                <h3 class="text-lg font-semibold text-slate-900 dark:text-white">
                  {{ title }}
                </h3>
                <p v-if="description" class="mt-1 text-sm text-slate-500">
                  {{ description }}
                </p>
              </slot>
            </div>

            <!-- Body -->
            <div>
              <slot />
            </div>

            <!-- Footer -->
            <div v-if="$slots.footer" class="mt-6 flex justify-end gap-3">
              <slot name="footer" />
            </div>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>
