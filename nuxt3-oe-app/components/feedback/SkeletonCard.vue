<script setup lang="ts">
/**
 * SkeletonCard - Skeleton loader for card components
 * @example <SkeletonCard variant="feature" />
 */

interface Props {
    variant?: 'default' | 'feature' | 'persona' | 'testimonial' | 'stat'
    showAvatar?: boolean
    showImage?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    variant: 'default',
    showAvatar: false,
    showImage: false,
})
</script>

<template>
    <div class="p-6 rounded-xl border border-surface-200 dark:border-surface-700 space-y-4">
        <!-- Image placeholder -->
        <FeedbackSkeletonBase v-if="showImage" class="h-40 w-full rounded-lg" />

        <!-- Avatar + Title row -->
        <div v-if="showAvatar" class="flex items-center gap-3">
            <FeedbackSkeletonAvatar size="md" />
            <div class="flex-1 space-y-2">
                <FeedbackSkeletonBase class="h-4 w-1/2" />
                <FeedbackSkeletonBase class="h-3 w-1/3" />
            </div>
        </div>

        <!-- Icon + Title for feature cards -->
        <div v-if="variant === 'feature'" class="space-y-3">
            <FeedbackSkeletonBase class="h-10 w-10 rounded-lg" />
            <FeedbackSkeletonBase class="h-5 w-2/3" />
            <FeedbackSkeletonText :lines="2" />
        </div>

        <!-- Stat variant -->
        <div v-else-if="variant === 'stat'" class="text-center space-y-2">
            <FeedbackSkeletonBase class="h-10 w-24 mx-auto" />
            <FeedbackSkeletonBase class="h-4 w-16 mx-auto" />
        </div>

        <!-- Testimonial variant -->
        <div v-else-if="variant === 'testimonial'" class="space-y-4">
            <FeedbackSkeletonText :lines="3" />
            <div class="flex items-center gap-3 pt-2">
                <FeedbackSkeletonAvatar size="sm" />
                <div class="space-y-1">
                    <FeedbackSkeletonBase class="h-3 w-20" />
                    <FeedbackSkeletonBase class="h-3 w-16" />
                </div>
            </div>
        </div>

        <!-- Persona variant -->
        <div v-else-if="variant === 'persona'" class="space-y-4">
            <div class="flex items-start gap-3">
                <FeedbackSkeletonBase class="h-10 w-10 rounded-lg shrink-0" />
                <div class="space-y-2 flex-1">
                    <FeedbackSkeletonBase class="h-4 w-1/2" />
                    <FeedbackSkeletonBase class="h-3 w-2/3" />
                </div>
            </div>
            <FeedbackSkeletonText :lines="3" />
            <div class="flex gap-2">
                <FeedbackSkeletonBase class="h-6 w-16 rounded-full" />
                <FeedbackSkeletonBase class="h-6 w-20 rounded-full" />
                <FeedbackSkeletonBase class="h-6 w-14 rounded-full" />
            </div>
        </div>

        <!-- Default variant -->
        <div v-else class="space-y-3">
            <FeedbackSkeletonBase class="h-5 w-3/4" />
            <FeedbackSkeletonText :lines="2" />
        </div>
    </div>
</template>
