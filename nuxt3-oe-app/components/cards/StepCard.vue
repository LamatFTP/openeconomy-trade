<script setup lang="ts">
/**
 * StepCard - Numbered step with content
 * @example <StepCard number="01" title="First Step" description="..." />
 */

interface Props {
    number: string | number
    title: string
    subtitle?: string
    description: string
    icon?: string
    variant?: 'default' | 'compact' | 'horizontal'
}

const props = withDefaults(defineProps<Props>(), {
    variant: 'default',
})
</script>

<template>
    <div :class="[
        variant === 'horizontal' ? 'flex gap-6' : 'flex flex-col gap-4'
    ]">
        <!-- Number/Icon -->
        <div :class="[
            'flex items-center justify-center rounded-2xl font-display text-title-lg',
            'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400',
            variant === 'compact' ? 'w-12 h-12' : 'w-16 h-16',
            variant === 'horizontal' && 'shrink-0'
        ]">
            <Icon v-if="icon" :name="icon" class="w-6 h-6" />
            <span v-else>{{ number }}</span>
        </div>

        <!-- Content -->
        <div :class="variant === 'horizontal' && 'flex-1'">
            <h3 class="text-title-lg text-surface-900 dark:text-white">
                {{ title }}
            </h3>

            <p v-if="subtitle" class="text-body-sm text-primary-600 dark:text-primary-400 mt-1">
                {{ subtitle }}
            </p>

            <p class="mt-2 text-body-md text-surface-600 dark:text-surface-400">
                {{ description }}
            </p>

            <!-- Slot for additional content -->
            <slot />
        </div>
    </div>
</template>
