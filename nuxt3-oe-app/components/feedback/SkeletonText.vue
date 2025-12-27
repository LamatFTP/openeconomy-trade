<script setup lang="ts">
/**
 * SkeletonText - Skeleton loader for text content
 * @example <SkeletonText lines="3" />
 */

interface Props {
    lines?: number
    lastLineWidth?: 'full' | 'half' | 'third' | 'quarter'
}

const props = withDefaults(defineProps<Props>(), {
    lines: 1,
    lastLineWidth: 'half',
})

const lastWidthClass = {
    full: 'w-full',
    half: 'w-1/2',
    third: 'w-1/3',
    quarter: 'w-1/4',
}
</script>

<template>
    <div class="space-y-2">
        <FeedbackSkeletonBase v-for="i in lines" :key="i" :class="[
            'h-4',
            i === lines ? lastWidthClass[lastLineWidth] : 'w-full'
        ]" />
    </div>
</template>
