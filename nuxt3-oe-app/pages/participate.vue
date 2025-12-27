<script setup lang="ts">
/**
 * Participate Page - For potential participants
 */
import type { StepItem, FAQItem } from '~/types/content'

const { data, loading, error } = usePageContent('participate')

useHead({
    title: 'Participate | OpenEconomy',
    meta: [
        { name: 'description', content: 'Ready to trade skills without money? Learn how to participate in OpenEconomy.' },
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

                <!-- Paths Section -->
                <SectionsSectionBlock v-if="getSection('paths')" id="paths"
                    :headline="getSection('paths')?.header?.headline"
                    :subheadline="getSection('paths')?.header?.subheadline" background="muted">
                    <LayoutGrid :cols="{ sm: 1, md: 2, lg: 3 }" gap="lg">
                        <CardsPathCard v-for="path in (getSection('paths')?.items as any[])" :key="path.title"
                            v-bind="path" />
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Getting Started Section -->
                <SectionsSectionBlock v-if="getSection('getting-started')" id="getting-started"
                    :badge="getSection('getting-started')?.header?.badge"
                    :headline="getSection('getting-started')?.header?.headline">
                    <SectionsProcessFlow :steps="(getSection('getting-started')?.items as StepItem[])"
                        variant="horizontal" />
                </SectionsSectionBlock>

                <!-- FAQ Section -->
                <SectionsSectionBlock v-if="getSection('faq')" id="faq" :headline="getSection('faq')?.header?.headline"
                    background="muted">
                    <SectionsFAQSection :items="(getSection('faq')?.items as FAQItem[])" />
                </SectionsSectionBlock>

                <!-- Final CTA -->
                <SectionsCTASection v-if="data.cta" :headline="data.cta.headline" :subheadline="data.cta.subheadline"
                    :primary-cta="data.cta.primaryCta" :secondary-cta="data.cta.secondaryCta"
                    :gradient="data.cta.gradient" />
            </template>
        </FeedbackLoadingContainer>
    </div>
</template>
