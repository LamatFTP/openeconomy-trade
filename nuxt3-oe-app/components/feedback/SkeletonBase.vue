<script setup lang="ts">
/**
 * SkeletonBase - Base skeleton loading animation
 * @example <SkeletonBase class="h-4 w-full" />
 */

interface Props {
    animate?: boolean
}

withDefaults(defineProps<Props>(), {
    animate: true,
})
</script>

<template>
    <div :class="[
        'bg-surface-200 dark:bg-surface-700 rounded',
        animate && 'animate-pulse'
    ]" />
</template>
