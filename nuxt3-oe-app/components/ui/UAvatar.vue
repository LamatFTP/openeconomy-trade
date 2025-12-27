<script setup lang="ts">
/**
 * UAvatar - User avatar component
 * Supports images, initials fallback, sizes
 */

interface Props {
  src?: string
  alt?: string
  name?: string
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  rounded?: 'full' | 'lg' | 'md'
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  rounded: 'full',
})

const sizeClasses = {
  xs: 'h-6 w-6 text-xs',
  sm: 'h-8 w-8 text-sm',
  md: 'h-10 w-10 text-sm',
  lg: 'h-12 w-12 text-base',
  xl: 'h-16 w-16 text-lg',
}

const roundedClasses = {
  full: 'rounded-full',
  lg: 'rounded-lg',
  md: 'rounded-md',
}

// Generate initials from name
const initials = computed(() => {
  if (!props.name) return '?'
  return props.name
    .split(' ')
    .map(n => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2)
})

// Generate consistent background color from name
const bgColor = computed(() => {
  if (!props.name) return 'bg-slate-200 dark:bg-slate-700'
  
  const colors = [
    'bg-brand-500',
    'bg-blue-500',
    'bg-purple-500',
    'bg-pink-500',
    'bg-orange-500',
    'bg-teal-500',
  ]
  
  const hash = props.name.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0)
  return colors[hash % colors.length]
})

const hasError = ref(false)
</script>

<template>
  <div
    :class="[
      'relative inline-flex items-center justify-center overflow-hidden',
      sizeClasses[size],
      roundedClasses[rounded],
      !src || hasError ? bgColor : 'bg-slate-200 dark:bg-slate-700'
    ]"
  >
    <!-- Image -->
    <img
      v-if="src && !hasError"
      :src="src"
      :alt="alt || name"
      class="h-full w-full object-cover"
      @error="hasError = true"
    />

    <!-- Initials fallback -->
    <span
      v-else
      class="font-medium text-white"
    >
      {{ initials }}
    </span>

    <!-- Slot for status indicator -->
    <slot />
  </div>
</template>
