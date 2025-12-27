<script setup lang="ts">
/**
 * TierCard - Trust tier display
 * @example <TierCard icon="🌱" name="Newcomer" requirements="Just joined" :privileges="[...]" />
 */

interface Props {
    icon: string
    name: string
    requirements: string
    privileges: string[]
    active?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    active: false,
})
</script>

<template>
    <div :class="[
        'p-6 rounded-xl border transition-all duration-200',
        active
            ? 'border-primary-300 dark:border-primary-700 bg-primary-50 dark:bg-primary-900/20 shadow-elevation-2'
            : 'border-surface-200 dark:border-surface-700 bg-white dark:bg-surface-900'
    ]">
        <!-- Header -->
        <div class="flex items-center gap-3 mb-4">
            <span class="text-3xl">{{ icon }}</span>
            <div>
                <h3 class="text-title-md text-surface-900 dark:text-white">
                    {{ name }}
                </h3>
                <p class="text-body-sm text-surface-500 dark:text-surface-400">
                    {{ requirements }}
                </p>
            </div>
        </div>

        <!-- Privileges -->
        <ul class="space-y-2">
            <li v-for="privilege in privileges" :key="privilege"
                class="flex items-start gap-2 text-body-sm text-surface-600 dark:text-surface-400">
                <svg class="w-4 h-4 text-secondary-500 shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                {{ privilege }}
            </li>
        </ul>
    </div>
</template>
