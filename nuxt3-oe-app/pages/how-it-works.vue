<script setup lang="ts">
/**
 * How It Works Page - Detailed explanation of the exchange process
 */
import type { StepItem, TierItem, FAQItem } from '~/types/content'

const { data, loading, error } = usePageContent('how-it-works')

useHead({
    title: 'How It Works | OpenEconomy',
    meta: [
        { name: 'description', content: 'Learn how OpenEconomy works: set your value, list skills, find matches, and exchange fairly.' },
    ],
})

function getSection(id: string) {
    return data.value?.sections?.find(s => s.id === id)
}
</script>

<template>
    <div>
        <FeedbackLoadingContainer :loading="loading" :error="error">
            <template #skeleton>
                <FeedbackSkeletonHero />
            </template>

            <template v-if="data">
                <!-- Hero -->
                <SectionsPageHero :badge="data.hero.badge" :headline="data.hero.headline"
                    :subheadline="data.hero.subheadline" :primary-cta="data.hero.primaryCta"
                    :secondary-cta="data.hero.secondaryCta" />

                <!-- Detailed Steps Section -->
                <SectionsSectionBlock v-if="getSection('steps')" id="steps" background="muted">
                    <LayoutStack gap="xl">
                        <div v-for="step in (getSection('steps')?.items as any[])" :key="step.number"
                            class="scroll-mt-24">
                            <MotionFadeIn>
                                <!-- Step Header -->
                                <div class="flex items-start gap-6 mb-8">
                                    <div
                                        class="w-16 h-16 rounded-2xl bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center font-display text-title-lg text-primary-600 dark:text-primary-400 shrink-0">
                                        {{ step.number }}
                                    </div>
                                    <div>
                                        <h2 class="text-headline-md text-surface-900 dark:text-white">
                                            {{ step.title }}
                                        </h2>
                                        <p class="text-body-lg text-primary-600 dark:text-primary-400">
                                            {{ step.subtitle }}
                                        </p>
                                    </div>
                                </div>

                                <!-- Step Description -->
                                <p class="text-body-lg text-surface-600 dark:text-surface-400 mb-8 max-w-3xl">
                                    {{ step.description }}
                                </p>

                                <!-- Step Options (for step 1) -->
                                <LayoutGrid v-if="step.options" :cols="{ sm: 1, md: 3 }" gap="md" class="mb-8">
                                    <CardsFeatureCard v-for="option in step.options" :key="option.title" v-bind="option"
                                        variant="bordered" />
                                </LayoutGrid>

                                <!-- Categories (for step 2) -->
                                <LayoutGrid v-if="step.categories" :cols="{ sm: 2, md: 3 }" gap="md" class="mb-8">
                                    <div v-for="cat in step.categories" :key="cat.name"
                                        class="p-4 rounded-xl border border-surface-200 dark:border-surface-700 bg-white dark:bg-surface-900">
                                        <div class="flex items-center gap-3 mb-3">
                                            <Icon :name="cat.icon" class="w-6 h-6 text-primary-500" />
                                            <span class="text-title-sm text-surface-900 dark:text-white">{{ cat.name
                                                }}</span>
                                        </div>
                                        <div class="flex flex-wrap gap-2">
                                            <span v-for="ex in cat.examples" :key="ex"
                                                class="px-2 py-1 text-label-md rounded bg-surface-100 dark:bg-surface-800 text-surface-600 dark:text-surface-400">
                                                {{ ex }}
                                            </span>
                                        </div>
                                    </div>
                                </LayoutGrid>

                                <!-- Methods (for step 3) -->
                                <LayoutGrid v-if="step.methods" :cols="{ sm: 1, md: 2 }" gap="md" class="mb-8">
                                    <CardsFeatureCard v-for="method in step.methods" :key="method.title" v-bind="method"
                                        variant="bordered" />
                                </LayoutGrid>

                                <!-- Phases (for step 4) -->
                                <div v-if="step.phases" class="flex flex-col md:flex-row gap-4 mb-8">
                                    <div v-for="(phase, idx) in step.phases" :key="phase.title"
                                        class="flex-1 p-4 rounded-xl border border-surface-200 dark:border-surface-700 bg-white dark:bg-surface-900 relative">
                                        <div class="flex items-center gap-3 mb-2">
                                            <Icon :name="phase.icon" class="w-5 h-5 text-primary-500" />
                                            <span class="text-title-sm text-surface-900 dark:text-white">{{ phase.title
                                                }}</span>
                                        </div>
                                        <p class="text-body-sm text-surface-600 dark:text-surface-400">
                                            {{ phase.description }}
                                        </p>
                                        <!-- Arrow connector -->
                                        <div v-if="idx < step.phases.length - 1"
                                            class="hidden md:block absolute -right-3 top-1/2 -translate-y-1/2 text-surface-300">
                                            →
                                        </div>
                                    </div>
                                </div>
                            </MotionFadeIn>
                        </div>
                    </LayoutStack>
                </SectionsSectionBlock>

                <!-- Trust Tiers Section -->
                <SectionsSectionBlock v-if="getSection('trust')" id="trust" :badge="getSection('trust')?.header?.badge"
                    :headline="getSection('trust')?.header?.headline"
                    :subheadline="getSection('trust')?.header?.subheadline">
                    <LayoutGrid :cols="{ sm: 1, md: 2, lg: 3 }" gap="lg">
                        <CardsTierCard v-for="tier in (getSection('trust')?.items as TierItem[])" :key="tier.name"
                            v-bind="tier" />
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- FAQ Preview Section -->
                <SectionsSectionBlock v-if="getSection('faq-preview')" id="faq-preview"
                    :headline="getSection('faq-preview')?.header?.headline" background="muted">
                    <SectionsFAQSection :items="(getSection('faq-preview')?.items as FAQItem[])" />

                    <!-- See all FAQ link -->
                    <div v-if="getSection('faq-preview')?.cta" class="text-center mt-8">
                        <UButton :to="getSection('faq-preview')?.cta?.to" variant="ghost" size="lg">
                            {{ getSection('faq-preview')?.cta?.label }}
                            <Icon name="ph:arrow-right" class="ml-2" />
                        </UButton>
                    </div>
                </SectionsSectionBlock>

                <!-- Final CTA -->
                <SectionsCTASection v-if="data.cta" :headline="data.cta.headline" :subheadline="data.cta.subheadline"
                    :primary-cta="data.cta.primaryCta" :secondary-cta="data.cta.secondaryCta"
                    :gradient="data.cta.gradient" />
            </template>
        </FeedbackLoadingContainer>
    </div>
</template>
