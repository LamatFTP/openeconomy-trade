<script setup lang="ts">
/**
 * About Page - Mission, principles, and team
 */
import type { FeatureItem, ComparisonRow, StatItem } from '~/types/content'

const { data, loading, error } = usePageContent('about')

useHead({
    title: 'About | OpenEconomy',
    meta: [
        { name: 'description', content: 'Learn about OpenEconomy\'s mission, principles, and team. We\'re building fair exchange infrastructure for everyone.' },
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
                    :subheadline="data.hero.subheadline" />

                <!-- Mission Section -->
                <SectionsSectionBlock v-if="getSection('mission')" id="mission"
                    :headline="getSection('mission')?.header?.headline" background="muted">
                    <div class="max-w-4xl mx-auto">
                        <!-- Mission Statement -->
                        <blockquote
                            class="text-headline-md text-center text-primary-600 dark:text-primary-400 italic mb-12">
                            "{{ (getSection('mission') as any)?.statement }}"
                        </blockquote>

                        <!-- Problem & Solution Grid -->
                        <div class="grid md:grid-cols-2 gap-8">
                            <!-- Problem -->
                            <div
                                class="p-6 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
                                <h3 class="text-title-lg text-red-700 dark:text-red-400 mb-4">
                                    {{ (getSection('mission') as any)?.problem?.title }}
                                </h3>
                                <ul class="space-y-2 mb-4">
                                    <li v-for="point in (getSection('mission') as any)?.problem?.points" :key="point"
                                        class="flex items-start gap-2 text-body-md text-red-800 dark:text-red-300">
                                        <span class="text-red-500">•</span>
                                        {{ point }}
                                    </li>
                                </ul>
                                <p
                                    class="text-body-md text-red-700 dark:text-red-400 font-medium pt-4 border-t border-red-200 dark:border-red-700">
                                    {{ (getSection('mission') as any)?.problem?.conclusion }}
                                </p>
                            </div>

                            <!-- Solution -->
                            <div
                                class="p-6 rounded-xl bg-secondary-50 dark:bg-secondary-900/20 border border-secondary-200 dark:border-secondary-800">
                                <h3 class="text-title-lg text-secondary-700 dark:text-secondary-400 mb-4">
                                    {{ (getSection('mission') as any)?.solution?.title }}
                                </h3>
                                <p class="text-body-md text-secondary-800 dark:text-secondary-300 mb-4">
                                    {{ (getSection('mission') as any)?.solution?.description }}
                                </p>
                                <ul class="space-y-2">
                                    <li v-for="point in (getSection('mission') as any)?.solution?.points" :key="point"
                                        class="flex items-start gap-2 text-body-md text-secondary-800 dark:text-secondary-300">
                                        <svg class="w-5 h-5 text-secondary-500 shrink-0" fill="none" viewBox="0 0 24 24"
                                            stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M5 13l4 4L19 7" />
                                        </svg>
                                        {{ point }}
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </SectionsSectionBlock>

                <!-- Principles Section -->
                <SectionsSectionBlock v-if="getSection('principles')" id="principles"
                    :headline="getSection('principles')?.header?.headline">
                    <LayoutGrid :cols="{ sm: 1, md: 2, lg: 3 }" gap="lg">
                        <CardsFeatureCard v-for="principle in (getSection('principles')?.items as FeatureItem[])"
                            :key="principle.title" v-bind="principle" variant="bordered" />
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Comparison Section -->
                <SectionsSectionBlock v-if="getSection('comparison')" id="comparison"
                    :headline="getSection('comparison')?.header?.headline" background="muted">
                    <div class="max-w-3xl mx-auto overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b border-surface-200 dark:border-surface-700">
                                    <th class="py-4 px-4 text-left text-title-sm text-surface-900 dark:text-white" />
                                    <th
                                        class="py-4 px-4 text-center text-title-sm text-surface-500 dark:text-surface-400">
                                        Gig Platforms
                                    </th>
                                    <th
                                        class="py-4 px-4 text-center text-title-sm text-primary-600 dark:text-primary-400">
                                        OpenEconomy
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="row in (getSection('comparison')?.rows as unknown as ComparisonRow[])"
                                    :key="row.feature" class="border-b border-surface-100 dark:border-surface-800">
                                    <td class="py-4 px-4 text-body-md text-surface-900 dark:text-white">
                                        {{ row.feature }}
                                    </td>
                                    <td
                                        class="py-4 px-4 text-center text-body-md text-surface-500 dark:text-surface-400">
                                        {{ row.them }}
                                    </td>
                                    <td
                                        class="py-4 px-4 text-center text-body-md text-secondary-600 dark:text-secondary-400 font-medium">
                                        {{ row.us }}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </SectionsSectionBlock>

                <!-- Team Section -->
                <SectionsSectionBlock v-if="getSection('team')" id="team"
                    :headline="getSection('team')?.header?.headline"
                    :subheadline="getSection('team')?.header?.subheadline">
                    <SectionsStatsRow :stats="(getSection('team')?.stats as StatItem[])" class="mb-12" />

                    <div v-if="getSection('team')?.cta" class="text-center">
                        <UButton :to="getSection('team')?.cta?.to" variant="ghost" size="lg">
                            {{ getSection('team')?.cta?.label }}
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
