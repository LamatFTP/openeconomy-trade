<script setup lang="ts">
/**
 * SectionBlock - Wrapper for content sections with header
 * @example <SectionBlock badge="Features" headline="Why Choose Us">Content</SectionBlock>
 */

interface Props {
    id?: string
    badge?: string
    headline?: string
    subheadline?: string
    align?: 'left' | 'center'
    background?: 'default' | 'muted' | 'primary' | 'gradient'
    padding?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
    align: 'center',
    background: 'default',
    padding: 'lg',
})

const alignClasses = {
    left: 'text-left',
    center: 'text-center mx-auto',
}

const bgClasses = {
    default: 'bg-white dark:bg-surface-950',
    muted: 'bg-surface-50 dark:bg-surface-900',
    primary: 'bg-primary-50 dark:bg-primary-950',
    gradient: 'bg-gradient-to-br from-primary-600 to-secondary-600 text-white',
}

const paddingClasses = {
    sm: 'py-12',
    md: 'py-16',
    lg: 'py-20 lg:py-24',
}
</script>

<template>
    <section :id="id" :class="[bgClasses[background], paddingClasses[padding]]">
        <LayoutContainer>
            <MotionFadeIn>
                <!-- Section Header -->
                <div v-if="badge || headline || subheadline" :class="['mb-12 lg:mb-16 max-w-3xl', alignClasses[align]]">
                    <!-- Badge -->
                    <span v-if="badge" :class="[
                        'inline-flex items-center px-3 py-1 rounded-full text-label-lg mb-4',
                        background === 'gradient'
                            ? 'bg-white/20 text-white'
                            : 'bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300'
                    ]">
                        {{ badge }}
                    </span>

                    <!-- Headline -->
                    <h2 v-if="headline" :class="[
                        'text-headline-lg lg:text-headline-lg font-display tracking-tight',
                        background === 'gradient'
                            ? 'text-white'
                            : 'text-surface-900 dark:text-white'
                    ]">
                        {{ headline }}
                    </h2>

                    <!-- Subheadline -->
                    <p v-if="subheadline" :class="[
                        'mt-4 text-body-lg',
                        background === 'gradient'
                            ? 'text-white/80'
                            : 'text-surface-600 dark:text-surface-300'
                    ]">
                        {{ subheadline }}
                    </p>
                </div>

                <!-- Content -->
                <slot />
            </MotionFadeIn>
        </LayoutContainer>
    </section>
</template>
