<script setup lang="ts">
/**
 * UButton - Base button component
 * Supports variants, sizes, loading state
 */

interface Props {
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger' | 'link' | 'outline'
  size?: 'xs' | 'sm' | 'md' | 'lg'
  loading?: boolean
  disabled?: boolean
  icon?: string
  iconRight?: string
  block?: boolean
  type?: 'button' | 'submit' | 'reset'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
  loading: false,
  disabled: false,
  block: false,
  type: 'button',
})

const emit = defineEmits<{
  click: [event: MouseEvent]
}>()

const variantClasses = {
  primary: 'btn-primary',
  secondary: 'btn-secondary',
  ghost: 'btn-ghost',
  danger: 'btn-danger',
  outline: 'btn-outline',
  link: 'text-brand-500 hover:text-brand-600 underline-offset-4 hover:underline',
}

const sizeClasses = {
  xs: 'px-2 py-1 text-xs',
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-sm',
  lg: 'px-6 py-3 text-base',
}

const classes = computed(() => [
  props.variant !== 'link' && 'btn',
  variantClasses[props.variant],
  sizeClasses[props.size],
  props.block && 'w-full',
])

function handleClick(event: MouseEvent) {
  if (!props.loading && !props.disabled) {
    emit('click', event)
  }
}
</script>

<template>
  <button
    :type="type"
    :class="classes"
    :disabled="disabled || loading"
    @click="handleClick"
  >
    <!-- Loading spinner -->
    <Icon 
      v-if="loading" 
      name="svg-spinners:90-ring-with-bg" 
      class="h-4 w-4"
    />
    
    <!-- Left icon -->
    <Icon 
      v-else-if="icon" 
      :name="icon" 
      class="h-4 w-4"
    />

    <!-- Content -->
    <span v-if="$slots.default">
      <slot />
    </span>

    <!-- Right icon -->
    <Icon 
      v-if="iconRight && !loading" 
      :name="iconRight" 
      class="h-4 w-4"
    />
  </button>
</template>
