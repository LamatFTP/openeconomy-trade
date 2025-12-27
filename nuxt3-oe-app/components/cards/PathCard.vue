<script setup lang="ts">
/**
 * PathCard - Clickable path/option card
 * @example <PathCard icon="🚀" title="Join" subtitle="Ready to start?" />
 */
import type { CTAButton } from '~/types/content'

interface Props {
    icon: string
    title: string
    subtitle: string
    description?: string
    cta?: CTAButton
    features?: string[]
    variant?: 'default' | 'featured'
}

const props = withDefaults(defineProps<Props>(), {
    variant: 'default',
})
</script>

<template>
    <div :class="[
        'p-6 lg:p-8 rounded-xl border transition-all duration-200 cursor-pointer',
        'hover:shadow-elevation-2 hover:-translate-y-1',
        variant === 'featured'
            ? 'border-primary-300 dark:border-primary-700 bg-primary-50/50 dark:bg-primary-900/20'
            : 'border-surface-200 dark:border-surface-700 bg-white dark:bg-surface-900'
    ]">
        <!-- Icon (emoji or icon name) -->
        <div class="text-4xl mb-4">
            <span v-if="icon.length <= 2">{{ icon }}</span>
            <Icon v-else :name="icon" class="w-10 h-10 text-primary-500" />
        </div>

        <!-- Title -->
        <h3 class="text-title-lg text-surface-900 dark:text-white mb-1">
            {{ title }}
        </h3>

        <!-- Subtitle -->
        <p class="text-body-md text-surface-500 dark:text-surface-400 mb-4">
            {{ subtitle }}
        </p>

        <!-- Description -->
        <p v-if="description" class="text-body-md text-surface-600 dark:text-surface-300 mb-4">
            {{ description }}
        </p>

        <!-- Features List -->
        <ul v-if="features && features.length" class="space-y-2 mb-6">
            <li v-for="feature in features" :key="feature"
                class="flex items-start gap-2 text-body-sm text-surface-600 dark:text-surface-400">
                <svg class="w-5 h-5 text-secondary-500 shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                {{ feature }}
            </li>
        </ul>

        <!-- CTA -->
        <UButton v-if="cta" :to="cta.to" :variant="cta.variant || 'primary'" class="w-full">
            {{ cta.label }}
        </UButton>

        <!-- Slot for custom content -->
        <slot />
    </div>
</template>
