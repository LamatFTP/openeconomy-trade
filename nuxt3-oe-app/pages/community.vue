<script setup lang="ts">
/**
 * Community Page - Join the movement
 */
import type { FeatureItem, StatItem, EventItem } from '~/types/content'

const { data, loading, error } = usePageContent('community')

useHead({
    title: 'Community | OpenEconomy',
    meta: [
        { name: 'description', content: 'Join the OpenEconomy community. Connect with fellow participants, attend events, and help build the future of fair exchange.' },
    ],
})

function getSection(id: string) {
    return data.value?.sections?.find(s => s.id === id)
}

// Format date for display
function formatDate(dateStr: string) {
    const date = new Date(dateStr)
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
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

                <!-- Stats Section -->
                <SectionsSectionBlock v-if="getSection('stats')" background="muted" padding="md">
                    <SectionsStatsRow :stats="(getSection('stats')?.stats as StatItem[])" />
                </SectionsSectionBlock>

                <!-- Channels Section -->
                <SectionsSectionBlock v-if="getSection('channels')" id="channels"
                    :headline="getSection('channels')?.header?.headline">
                    <LayoutGrid :cols="{ sm: 2, md: 4 }" gap="lg">
                        <CardsFeatureCard v-for="channel in (getSection('channels')?.items as FeatureItem[])"
                            :key="channel.title" v-bind="channel" align="center" variant="bordered" />
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Events Section -->
                <SectionsSectionBlock v-if="getSection('events')" id="events"
                    :headline="getSection('events')?.header?.headline" background="muted">
                    <LayoutGrid :cols="{ sm: 1, md: 3 }" gap="lg">
                        <div v-for="event in (getSection('events')?.items as EventItem[])" :key="event.title"
                            class="p-6 rounded-xl bg-white dark:bg-surface-900 border border-surface-200 dark:border-surface-700">
                            <!-- Event type badge -->
                            <span
                                class="inline-block px-2 py-1 rounded text-label-md bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300 mb-3">
                                {{ event.type }}
                            </span>

                            <h3 class="text-title-md text-surface-900 dark:text-white mb-2">
                                {{ event.title }}
                            </h3>

                            <div class="space-y-1 text-body-sm text-surface-600 dark:text-surface-400 mb-4">
                                <p>📅 {{ formatDate(event.date) }} <span v-if="event.time">· {{ event.time }}</span></p>
                                <p>📍 {{ event.location }}</p>
                            </div>

                            <p class="text-body-md text-surface-600 dark:text-surface-400">
                                {{ event.description }}
                            </p>
                        </div>
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Testimonials Section -->
                <SectionsSectionBlock v-if="getSection('testimonials')" id="testimonials"
                    :headline="getSection('testimonials')?.header?.headline">
                    <LayoutGrid :cols="{ sm: 1, md: 3 }" gap="lg">
                        <CardsTestimonialCard v-for="testimonial in (getSection('testimonials')?.items as any[])"
                            :key="testimonial.name" v-bind="testimonial" />
                    </LayoutGrid>
                </SectionsSectionBlock>

                <!-- Chapters Section -->
                <SectionsSectionBlock v-if="getSection('chapters')" id="chapters"
                    :headline="getSection('chapters')?.header?.headline"
                    :subheadline="getSection('chapters')?.header?.subheadline" background="muted">
                    <LayoutGrid :cols="{ sm: 2, md: 4 }" gap="lg" class="mb-8">
                        <div v-for="chapter in (getSection('chapters') as any)?.featured" :key="chapter.city"
                            class="p-4 rounded-xl bg-white dark:bg-surface-900 border border-surface-200 dark:border-surface-700 text-center">
                            <p class="text-title-md text-surface-900 dark:text-white mb-2">
                                {{ chapter.city }}
                            </p>
                            <div class="flex justify-center gap-4 text-body-sm text-surface-500">
                                <span>{{ chapter.members }} members</span>
                                <span>{{ chapter.exchanges }} exchanges</span>
                            </div>
                        </div>
                    </LayoutGrid>

                    <div v-if="getSection('chapters')?.cta" class="text-center">
                        <UButton :to="getSection('chapters')?.cta?.to" variant="ghost" size="lg">
                            {{ getSection('chapters')?.cta?.label }}
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
