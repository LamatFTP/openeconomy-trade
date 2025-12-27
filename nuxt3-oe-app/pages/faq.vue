<script setup lang="ts">
/**
 * FAQ Page - Comprehensive FAQ with categories
 */
import type { FAQItem } from '~/types/content'

const { data, loading, error } = usePageContent('faq')

useHead({
    title: 'FAQ | OpenEconomy',
    meta: [
        { name: 'description', content: 'Find answers to common questions about OpenEconomy. Learn about signing up, setting your value, and how fair skill exchange works.' },
    ],
})

function getSection(id: string) {
    return data.value?.sections?.find(s => s.id === id)
}

// Get all FAQ items from the section
const faqItems = computed(() => {
    const section = getSection('faq-items')
    return section?.items as FAQItem[] || []
})
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
                    :subheadline="data.hero.subheadline" />

                <!-- FAQ Section -->
                <SectionsSectionBlock background="muted">
                    <SectionsFAQSection :items="faqItems" :categories="(data as any).categories" />
                </SectionsSectionBlock>

                <!-- Support Options -->
                <SectionsSectionBlock v-if="(data as any).support" :headline="(data as any).support.headline">
                    <LayoutGrid :cols="{ sm: 1, md: 3 }" gap="lg">
                        <div v-for="option in (data as any).support.options" :key="option.title"
                            class="p-6 rounded-xl border border-surface-200 dark:border-surface-700 bg-white dark:bg-surface-900 text-center">
                            <div
                                class="w-12 h-12 mx-auto mb-4 rounded-xl bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
                                <Icon :name="option.icon" class="w-6 h-6 text-primary-600 dark:text-primary-400" />
                            </div>
                            <h3 class="text-title-md text-surface-900 dark:text-white mb-2">
                                {{ option.title }}
                            </h3>
                            <p class="text-body-md text-surface-600 dark:text-surface-400 mb-4">
                                {{ option.description }}
                            </p>
                            <UButton v-if="option.link" :to="option.link.to" variant="ghost">
                                {{ option.link.label }}
                            </UButton>
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
