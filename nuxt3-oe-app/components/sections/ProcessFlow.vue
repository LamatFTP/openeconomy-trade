<script setup lang="ts">
/**
 * ProcessFlow - Visual step progression
 * @example <ProcessFlow :steps="steps" variant="horizontal" />
 */
import type { StepItem } from '~/types/content'

interface Props {
    steps: StepItem[]
    variant?: 'horizontal' | 'vertical'
}

const props = withDefaults(defineProps<Props>(), {
    variant: 'horizontal',
})
</script>

<template>
    <div :class="[
        'relative',
        variant === 'horizontal'
            ? 'flex flex-col lg:flex-row gap-8 lg:gap-4'
            : 'flex flex-col gap-8'
    ]">
        <!-- Connector line (horizontal) -->
        <div v-if="variant === 'horizontal' && steps.length > 1"
            class="hidden lg:block absolute top-8 left-[10%] right-[10%] h-0.5 bg-surface-200 dark:bg-surface-700"
            aria-hidden="true" />

        <!-- Steps -->
        <MotionStagger :stagger-delay="100">
            <template #default="{ getStaggerStyle }">
                <div v-for="(step, index) in steps" :key="step.number" :style="getStaggerStyle(index)" :class="[
                    'relative flex-1',
                    variant === 'horizontal' ? 'text-center' : 'flex gap-6'
                ]">
                    <!-- Step number/icon -->
                    <div :class="[
                        'flex items-center justify-center w-16 h-16 rounded-2xl font-display text-title-lg',
                        'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400',
                        variant === 'horizontal' ? 'mx-auto mb-4' : 'shrink-0'
                    ]">
                        {{ step.number }}
                    </div>

                    <!-- Content -->
                    <div :class="variant === 'vertical' && 'flex-1'">
                        <h3 class="text-title-lg text-surface-900 dark:text-white mb-2">
                            {{ step.title }}
                        </h3>
                        <p v-if="step.subtitle" class="text-body-sm text-primary-600 dark:text-primary-400 mb-2">
                            {{ step.subtitle }}
                        </p>
                        <p class="text-body-md text-surface-600 dark:text-surface-400">
                            {{ step.description }}
                        </p>
                    </div>

                    <!-- Connector arrow (horizontal) -->
                    <div v-if="variant === 'horizontal' && index < steps.length - 1"
                        class="hidden lg:flex absolute -right-4 top-8 transform -translate-y-1/2 z-10">
                        <svg class="w-6 h-6 text-surface-300 dark:text-surface-600" fill="none" viewBox="0 0 24 24"
                            stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                        </svg>
                    </div>
                </div>
            </template>
        </MotionStagger>
    </div>
</template>
