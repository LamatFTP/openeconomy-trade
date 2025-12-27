<script setup lang="ts">
/**
 * LoadingSpinner - Simple loading indicator
 * @example <LoadingSpinner size="lg" />
 */

interface Props {
    size?: 'sm' | 'md' | 'lg'
    color?: 'primary' | 'white' | 'current'
}

const props = withDefaults(defineProps<Props>(), {
    size: 'md',
    color: 'primary',
})

const sizeClasses = {
    sm: 'h-4 w-4 border-2',
    md: 'h-8 w-8 border-2',
    lg: 'h-12 w-12 border-3',
}

const colorClasses = {
    primary: 'border-primary-500 border-t-transparent',
    white: 'border-white border-t-transparent',
    current: 'border-current border-t-transparent',
}
</script>

<template>
    <div :class="[
        'animate-spin rounded-full',
        sizeClasses[size],
        colorClasses[color]
    ]" role="status" aria-label="Loading" />
</template>
