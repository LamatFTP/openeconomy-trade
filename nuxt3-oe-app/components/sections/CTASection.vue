<script setup lang="ts">
/**
 * CTASection - Final call-to-action block
 * @example <CTASection headline="Ready to start?" :gradient="true" />
 */
import type { CTAButton } from '~/types/content'

interface Props {
    headline: string
    subheadline?: string
    primaryCta?: CTAButton
    secondaryCta?: CTAButton
    gradient?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    gradient: true,
})
</script>

<template>
    <section class="py-16 lg:py-24">
        <LayoutContainer>
            <MotionFadeIn>
                <div :class="[
                    'rounded-2xl lg:rounded-3xl p-8 lg:p-16 text-center',
                    gradient
                        ? 'bg-gradient-to-br from-primary-600 via-primary-700 to-secondary-700'
                        : 'bg-surface-100 dark:bg-surface-800'
                ]">
                    <!-- Headline -->
                    <h2 :class="[
                        'text-headline-md lg:text-headline-lg font-display tracking-tight',
                        gradient ? 'text-white' : 'text-surface-900 dark:text-white'
                    ]">
                        {{ headline }}
                    </h2>

                    <!-- Subheadline -->
                    <p v-if="subheadline" :class="[
                        'mt-4 text-body-lg max-w-2xl mx-auto',
                        gradient ? 'text-white/80' : 'text-surface-600 dark:text-surface-300'
                    ]">
                        {{ subheadline }}
                    </p>

                    <!-- CTAs -->
                    <div v-if="primaryCta || secondaryCta" class="flex flex-wrap justify-center gap-4 mt-8">
                        <UButton v-if="primaryCta" :to="primaryCta.to" :variant="gradient ? 'secondary' : 'primary'"
                            size="lg" class="min-w-[160px]">
                            {{ primaryCta.label }}
                        </UButton>
                        <UButton v-if="secondaryCta" :to="secondaryCta.to" :variant="gradient ? 'ghost' : 'outline'"
                            size="lg" :class="gradient && 'text-white border-white/30 hover:bg-white/10'">
                            {{ secondaryCta.label }}
                        </UButton>
                    </div>
                </div>
            </MotionFadeIn>
        </LayoutContainer>
    </section>
</template>
