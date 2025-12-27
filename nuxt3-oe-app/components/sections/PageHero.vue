<script setup lang="ts">
/**
 * PageHero - Hero section with badge, headline, CTAs
 * @example <PageHero v-bind="heroData" />
 */
import type { CTAButton } from '~/types/content'

interface Props {
    badge?: string
    headline: string
    subheadline?: string
    primaryCta?: CTAButton
    secondaryCta?: CTAButton
    socialProof?: string
    align?: 'left' | 'center'
    size?: 'default' | 'large'
}

const props = withDefaults(defineProps<Props>(), {
    align: 'center',
    size: 'default',
})

const alignClasses = {
    left: 'text-left items-start',
    center: 'text-center items-center',
}

const headlineClasses = {
    default: 'text-display-sm lg:text-display-md',
    large: 'text-display-md lg:text-display-lg',
}
</script>

<template>
    <section class="py-16 lg:py-24">
        <LayoutContainer>
            <MotionFadeIn>
                <div :class="['flex flex-col gap-6', alignClasses[align]]">
                    <!-- Badge -->
                    <span v-if="badge"
                        class="inline-flex items-center px-3 py-1 rounded-full text-label-lg bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300">
                        {{ badge }}
                    </span>

                    <!-- Headline -->
                    <h1 :class="[
                        headlineClasses[size],
                        'font-display tracking-tight text-surface-900 dark:text-white max-w-4xl'
                    ]">
                        {{ headline }}
                    </h1>

                    <!-- Subheadline -->
                    <p v-if="subheadline" class="text-body-lg text-surface-600 dark:text-surface-300 max-w-2xl">
                        {{ subheadline }}
                    </p>

                    <!-- CTAs -->
                    <div v-if="primaryCta || secondaryCta" class="flex flex-wrap gap-4 mt-2"
                        :class="align === 'center' && 'justify-center'">
                        <UButton v-if="primaryCta" :to="primaryCta.to" variant="primary" size="lg">
                            {{ primaryCta.label }}
                        </UButton>
                        <UButton v-if="secondaryCta" :to="secondaryCta.to" :variant="secondaryCta.variant || 'ghost'"
                            size="lg">
                            {{ secondaryCta.label }}
                        </UButton>
                    </div>

                    <!-- Social Proof -->
                    <p v-if="socialProof" class="text-body-sm text-surface-500 dark:text-surface-400 mt-2">
                        {{ socialProof }}
                    </p>

                    <!-- Extra slot for visuals/custom content -->
                    <slot />
                </div>
            </MotionFadeIn>
        </LayoutContainer>
    </section>
</template>
