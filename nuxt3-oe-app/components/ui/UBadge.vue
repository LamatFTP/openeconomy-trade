<script setup lang="ts">
/**
 * UBadge - Status badge/chip component
 */

interface Props {
  variant?: 'default' | 'brand' | 'success' | 'warning' | 'error' | 'outline'
  size?: 'sm' | 'md' | 'lg'
  dot?: boolean
  removable?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  size: 'md',
  dot: false,
  removable: false,
})

const emit = defineEmits<{
  remove: []
}>()

const variantClasses = {
  default: 'bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300',
  brand: 'bg-brand-100 text-brand-700 dark:bg-brand-900/30 dark:text-brand-400',
  success: 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400',
  warning: 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400',
  error: 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400',
  outline: 'bg-transparent border border-slate-300 text-slate-700 dark:border-slate-600 dark:text-slate-300',
}

const sizeClasses = {
  sm: 'px-2 py-0.5 text-xs',
  md: 'px-2.5 py-0.5 text-xs',
  lg: 'px-3 py-1 text-sm',
}

const dotColorClasses = {
  default: 'bg-slate-500',
  brand: 'bg-brand-500',
  success: 'bg-green-500',
  warning: 'bg-amber-500',
  error: 'bg-red-500',
  outline: 'bg-slate-500',
}
</script>

<template>
  <span
    :class="[
      'inline-flex items-center gap-1.5 rounded-full font-medium',
      variantClasses[variant],
      sizeClasses[size]
    ]"
  >
    <!-- Dot indicator -->
    <span
      v-if="dot"
      :class="['h-1.5 w-1.5 rounded-full', dotColorClasses[variant]]"
    />

    <!-- Content -->
    <slot />

    <!-- Remove button -->
    <button
      v-if="removable"
      class="-mr-1 ml-0.5 rounded-full p-0.5 hover:bg-black/10 dark:hover:bg-white/10"
      @click="emit('remove')"
    >
      <Icon name="ph:x" class="h-3 w-3" />
    </button>
  </span>
</template>
