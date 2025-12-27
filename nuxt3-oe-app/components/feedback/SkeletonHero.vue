<script setup lang="ts">
/**
 * SkeletonHero - Skeleton loader for hero sections
 * @example <SkeletonHero />
 */
</script>

<template>
    <div class="py-16 lg:py-24 space-y-8">
        <!-- Badge -->
        <FeedbackSkeletonBase class="h-6 w-32 rounded-full mx-auto" />

        <!-- Headline -->
        <div class="space-y-4 text-center max-w-3xl mx-auto">
            <FeedbackSkeletonBase class="h-12 lg:h-16 w-3/4 mx-auto" />
            <FeedbackSkeletonBase class="h-6 w-full mx-auto" />
            <FeedbackSkeletonBase class="h-6 w-2/3 mx-auto" />
        </div>

        <!-- CTAs -->
        <div class="flex justify-center gap-4">
            <FeedbackSkeletonBase class="h-12 w-40 rounded-lg" />
            <FeedbackSkeletonBase class="h-12 w-36 rounded-lg" />
        </div>

        <!-- Social proof -->
        <FeedbackSkeletonBase class="h-4 w-48 mx-auto" />
    </div>
</template>
