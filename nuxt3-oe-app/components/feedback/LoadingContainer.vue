<script setup lang="ts">
/**
 * LoadingContainer - Wrapper with embedded loading/error/empty states
 * @example
 * <LoadingContainer :loading="loading" :error="error">
 *   <template #skeleton><SkeletonCard /></template>
 *   <template #default>Content</template>
 * </LoadingContainer>
 */

interface Props {
    loading?: boolean
    error?: Error | null
    empty?: boolean
    emptyMessage?: string
    errorMessage?: string
    retryLabel?: string
}

const props = withDefaults(defineProps<Props>(), {
    loading: false,
    error: null,
    empty: false,
    emptyMessage: 'No content available',
    errorMessage: 'Failed to load content',
    retryLabel: 'Try again',
})

const emit = defineEmits<{
    retry: []
}>()

const slots = useSlots()
const hasSkeletonSlot = computed(() => !!slots.skeleton)
</script>

<template>
    <!-- Loading State -->
    <div v-if="loading">
        <slot v-if="hasSkeletonSlot" name="skeleton" />
        <div v-else class="flex items-center justify-center py-12">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500" />
        </div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="flex flex-col items-center justify-center py-12 px-4 text-center">
        <div class="w-16 h-16 rounded-full bg-red-100 dark:bg-red-900/20 flex items-center justify-center mb-4">
            <svg class="w-8 h-8 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
        </div>
        <p class="text-body-md text-surface-600 dark:text-surface-400 mb-4">
            {{ errorMessage }}
        </p>
        <p v-if="error.message" class="text-body-sm text-surface-500 mb-4">
            {{ error.message }}
        </p>
        <button class="px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition-colors"
            @click="emit('retry')">
            {{ retryLabel }}
        </button>
    </div>

    <!-- Empty State -->
    <div v-else-if="empty" class="flex flex-col items-center justify-center py-12 px-4 text-center">
        <div class="w-16 h-16 rounded-full bg-surface-100 dark:bg-surface-800 flex items-center justify-center mb-4">
            <svg class="w-8 h-8 text-surface-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
            </svg>
        </div>
        <p class="text-body-md text-surface-600 dark:text-surface-400">
            {{ emptyMessage }}
        </p>
        <slot name="empty-action" />
    </div>

    <!-- Content -->
    <slot v-else />
</template>