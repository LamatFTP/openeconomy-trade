<script setup lang="ts">
/**
 * InsightBlock - Key insight/concept display
 */

interface Example {
    left: { label: string; calculation: string }
    right: { label: string; calculation: string }
    result: string
}

interface Props {
    title: string
    description: string
    example?: Example
}

defineProps<Props>()
</script>

<template>
    <div
        class="max-w-3xl mx-auto p-6 lg:p-8 rounded-2xl bg-primary-50 dark:bg-primary-900/20 border border-primary-200 dark:border-primary-800">
        <!-- Title -->
        <div class="flex items-center gap-3 mb-4">
            <div class="w-10 h-10 rounded-lg bg-primary-100 dark:bg-primary-800 flex items-center justify-center">
                <svg class="w-5 h-5 text-primary-600 dark:text-primary-400" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                </svg>
            </div>
            <h3 class="text-title-lg text-primary-900 dark:text-primary-100">
                {{ title }}
            </h3>
        </div>

        <!-- Description -->
        <p class="text-body-lg text-primary-800 dark:text-primary-200 mb-6">
            {{ description }}
        </p>

        <!-- Example calculation -->
        <div v-if="example" class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="p-4 rounded-lg bg-white/50 dark:bg-surface-900/50">
                    <p class="text-label-lg text-primary-700 dark:text-primary-300 mb-1">
                        {{ example.left.label }}
                    </p>
                    <p class="text-title-md text-primary-900 dark:text-primary-100">
                        {{ example.left.calculation }}
                    </p>
                </div>
                <div class="p-4 rounded-lg bg-white/50 dark:bg-surface-900/50">
                    <p class="text-label-lg text-primary-700 dark:text-primary-300 mb-1">
                        {{ example.right.label }}
                    </p>
                    <p class="text-title-md text-primary-900 dark:text-primary-100">
                        {{ example.right.calculation }}
                    </p>
                </div>
            </div>

            <!-- Result -->
            <p class="text-center text-title-md text-primary-600 dark:text-primary-400 font-medium">
                {{ example.result }}
            </p>
        </div>
    </div>
</template>
