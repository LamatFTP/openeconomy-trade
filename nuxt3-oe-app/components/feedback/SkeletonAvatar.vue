<script setup lang="ts">
/**
 * SkeletonAvatar - Skeleton loader for avatar/image
 * @example <SkeletonAvatar size="lg" />
 */

interface Props {
    size?: 'sm' | 'md' | 'lg' | 'xl'
    shape?: 'circle' | 'square'
}

const props = withDefaults(defineProps<Props>(), {
    size: 'md',
    shape: 'circle',
})

const sizeClasses = {
    sm: 'w-8 h-8',
    md: 'w-12 h-12',
    lg: 'w-16 h-16',
    xl: 'w-24 h-24',
}

const shapeClasses = {
    circle: 'rounded-full',
    square: 'rounded-lg',
}
</script>

<template>
    <FeedbackSkeletonBase :class="[sizeClasses[size], shapeClasses[shape]]" />
</template>
