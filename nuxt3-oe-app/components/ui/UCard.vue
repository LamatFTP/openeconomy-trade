<script setup lang="ts">
/**
 * UCard - Base card component
 * Supports variants, hover effects, padding options
 */

interface Props {
  variant?: 'default' | 'bordered' | 'elevated' | 'ghost'
  hover?: boolean
  padding?: 'none' | 'sm' | 'md' | 'lg'
  as?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  hover: false,
  padding: 'md',
  as: 'div',
})

const paddingClasses = {
  none: '',
  sm: 'p-4',
  md: 'p-6',
  lg: 'p-8',
}

const variantClasses = {
  default: 'bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800',
  bordered: 'bg-transparent border-2 border-slate-200 dark:border-slate-700',
  elevated: 'bg-white dark:bg-slate-900 shadow-lg border-0',
  ghost: 'bg-slate-50 dark:bg-slate-800/50 border-0',
}

const classes = computed(() => [
  'rounded-xl',
  variantClasses[props.variant],
  paddingClasses[props.padding],
  props.hover && 'transition-all duration-200 hover:border-brand-500/50 hover:shadow-md cursor-pointer',
])
</script>

<template>
  <component :is="as" :class="classes">
    <slot />
  </component>
</template>
