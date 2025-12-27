<script setup lang="ts">
/**
 * Landing Page - OpenEconomy homepage
 * Showcases all modular components
 */
import type { PageContent, PersonaItem, FeatureItem, StepItem, StatItem } from '~/types/content'

// Fetch page content
const { data, loading, error } = usePageContent('landing')

// SEO
useHead({
  title: 'OpenEconomy | Fair Exchange Protocol for Everyone',
  meta: [
    { name: 'description', content: 'Trade skills fairly without money. OpenEconomy is a decentralized time-value exchange where everyone\'s time has worth.' },
  ],
})

// Type guards for sections
function getSection(id: string) {
  return data.value?.sections?.find(s => s.id === id)
}
</script>

<template>
  <div>
    <FeedbackLoadingContainer :loading="loading" :error="error" @retry="() => {}">
      <template #skeleton>
        <FeedbackSkeletonHero />
        <LayoutContainer>
          <LayoutGrid :cols="{ sm: 1, md: 3 }" gap="lg" class="py-16">
            <FeedbackSkeletonCard v-for="i in 3" :key="i" variant="persona" />
          </LayoutGrid>
        </LayoutContainer>
      </template>

      <template v-if="data">
        <!-- Hero Section -->
        <SectionsPageHero
          :badge="data.hero.badge"
          :headline="data.hero.headline"
          :subheadline="data.hero.subheadline"
          :primary-cta="data.hero.primaryCta"
          :secondary-cta="data.hero.secondaryCta"
          :social-proof="data.hero.socialProof"
          size="large"
        >
          <!-- Exchange Visual -->
          <LandingExchangeVisual
            v-if="data.hero.visual?.type === 'exchange' && data.hero.visual.data"
            :provider="(data.hero.visual.data as any).provider"
            :receiver="(data.hero.visual.data as any).receiver"
          />
        </SectionsPageHero>

        <!-- Problem Section -->
        <SectionsSectionBlock
          v-if="getSection('problem')"
          id="problem"
          :badge="getSection('problem')?.header?.badge"
          :headline="getSection('problem')?.header?.headline"
          :subheadline="getSection('problem')?.header?.subheadline"
          background="muted"
        >
          <LayoutGrid :cols="{ sm: 1, md: 2, lg: 3 }" gap="lg">
            <CardsPersonaCard
              v-for="persona in (getSection('problem')?.items as PersonaItem[])"
              :key="persona.name"
              v-bind="persona"
            />
          </LayoutGrid>

          <!-- Summary -->
          <p
            v-if="(getSection('problem') as any)?.summary"
            class="mt-12 text-center text-body-lg text-surface-600 dark:text-surface-400 max-w-3xl mx-auto"
          >
            {{ (getSection('problem') as any).summary }}
          </p>
        </SectionsSectionBlock>

        <!-- Solution Section -->
        <SectionsSectionBlock
          v-if="getSection('solution')"
          id="solution"
          :badge="getSection('solution')?.header?.badge"
          :headline="getSection('solution')?.header?.headline"
        >
          <!-- Insight Block -->
          <LandingInsightBlock
            v-if="(getSection('solution') as any)?.insight"
            :title="(getSection('solution') as any).insight.title"
            :description="(getSection('solution') as any).insight.description"
            :example="(getSection('solution') as any).insight.example"
            class="mb-16"
          />

          <!-- Value Props -->
          <LayoutGrid :cols="{ sm: 1, md: 3 }" gap="lg">
            <CardsFeatureCard
              v-for="feature in (getSection('solution')?.items as FeatureItem[])"
              :key="feature.title"
              v-bind="feature"
              align="center"
              variant="bordered"
            />
          </LayoutGrid>
        </SectionsSectionBlock>

        <!-- How It Works Section -->
        <SectionsSectionBlock
          v-if="getSection('how-it-works')"
          id="how-it-works"
          :badge="getSection('how-it-works')?.header?.badge"
          :headline="getSection('how-it-works')?.header?.headline"
          :subheadline="getSection('how-it-works')?.header?.subheadline"
          background="muted"
        >
          <SectionsProcessFlow
            :steps="(getSection('how-it-works')?.items as StepItem[])"
            variant="horizontal"
          />

          <!-- Section CTA -->
          <div v-if="getSection('how-it-works')?.cta" class="mt-12 text-center">
            <UButton
              :to="getSection('how-it-works')?.cta?.to"
              variant="ghost"
              size="lg"
            >
              {{ getSection('how-it-works')?.cta?.label }}
              <Icon name="ph:arrow-right" class="ml-2" />
            </UButton>
          </div>
        </SectionsSectionBlock>

        <!-- Principles Section -->
        <SectionsSectionBlock
          v-if="getSection('principles')"
          id="principles"
          :badge="getSection('principles')?.header?.badge"
          :headline="getSection('principles')?.header?.headline"
          :subheadline="getSection('principles')?.header?.subheadline"
        >
          <LayoutGrid :cols="{ sm: 1, md: 2, lg: 3 }" gap="lg">
            <CardsFeatureCard
              v-for="principle in (getSection('principles')?.items as FeatureItem[])"
              :key="principle.title"
              v-bind="principle"
              variant="bordered"
            />
          </LayoutGrid>
        </SectionsSectionBlock>

        <!-- Social Proof Section -->
        <SectionsSectionBlock
          v-if="getSection('social-proof')"
          id="social-proof"
          :headline="getSection('social-proof')?.header?.headline"
          background="muted"
        >
          <!-- Stats -->
          <SectionsStatsRow
            v-if="(getSection('social-proof') as any)?.stats"
            :stats="(getSection('social-proof') as any).stats"
            class="mb-16"
          />

          <!-- Testimonials -->
          <LayoutGrid
            v-if="(getSection('social-proof') as any)?.testimonials"
            :cols="{ sm: 1, md: 3 }"
            gap="lg"
          >
            <CardsTestimonialCard
              v-for="testimonial in (getSection('social-proof') as any).testimonials"
              :key="testimonial.name"
              v-bind="testimonial"
            />
          </LayoutGrid>
        </SectionsSectionBlock>

        <!-- Final CTA -->
        <SectionsCTASection
          v-if="data.cta"
          :headline="data.cta.headline"
          :subheadline="data.cta.subheadline"
          :primary-cta="data.cta.primaryCta"
          :secondary-cta="data.cta.secondaryCta"
          :gradient="data.cta.gradient"
        />
      </template>
    </FeedbackLoadingContainer>
  </div>
</template>
