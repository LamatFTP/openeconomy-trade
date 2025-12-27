<script setup lang="ts">
/**
 * Contribute Page - How to help build OpenEconomy
 */
import type { FeatureItem } from '~/types/content'

const { data, loading, error } = usePageContent('contribute')

useHead({
    title: 'Contribute | OpenEconomy',
    meta: [
        { name: 'description', content: 'Help build OpenEconomy. Whether you code, design, write, or want to grow the community—there\'s a place for you.' },
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

                <!-- Ways to Contribute Section -->
                <SectionsSectionBlock v-if="getSection('ways')" id="ways"
                    :headline="getSection('ways')?.header?.headline"
                    :subheadline="getSection('ways')?.header?.subheadline" background="muted">
                    <LayoutGrid :cols="{ sm: 1, md: 2, lg: 3 }" gap="lg">
                        <CardsPathCard v-for="way in (getSection('ways')?.items as any[])" :key="way.title"
                            v-bind="way" />
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Tech Stack Section -->
                <SectionsSectionBlock v-if="getSection('tech-stack')" id="tech-stack"
                    :badge="getSection('tech-stack')?.header?.badge"
                    :headline="getSection('tech-stack')?.header?.headline">
                    <LayoutGrid :cols="{ sm: 2, md: 4 }" gap="lg">
                        <CardsFeatureCard v-for="tech in (getSection('tech-stack')?.items as FeatureItem[])"
                            :key="tech.title" v-bind="tech" align="center" variant="bordered" size="sm" />
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Recognition Section -->
                <SectionsSectionBlock v-if="getSection('recognition')" id="recognition"
                    :headline="getSection('recognition')?.header?.headline" background="muted">
                    <LayoutGrid :cols="{ sm: 1, md: 2, lg: 4 }" gap="lg">
                        <div v-for="item in (getSection('recognition')?.items as any[])" :key="item.title"
                            class="p-6 rounded-xl bg-white dark:bg-surface-900 border border-surface-200 dark:border-surface-700 text-center">
                            <h3 class="text-title-md text-surface-900 dark:text-white mb-2">
                                {{ item.title }}
                            </h3>
                            <p class="text-body-sm text-surface-600 dark:text-surface-400">
                                {{ item.description }}
                            </p>
                        </div>
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Final CTA -->
                <SectionsCTASection v-if="data.cta" :headline="data.cta.headline" :subheadline="data.cta.subheadline"
                    :primary-cta="data.cta.primaryCta" :secondary-cta="data.cta.secondaryCta"
                    :gradient="data.cta.gradient" />
            </template>
        </FeedbackLoadingContainer>
    </div>
</template>
