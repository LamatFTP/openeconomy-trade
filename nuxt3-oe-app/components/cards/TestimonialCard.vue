<script setup lang="ts">
/**
 * TestimonialCard - Quote + author testimonial
 * @example <TestimonialCard quote="Great service!" name="John" role="Designer" />
 */

interface Props {
    quote: string
    name: string
    role: string
    location?: string
    avatar?: string
    rating?: number
    variant?: 'default' | 'featured' | 'compact'
}

const props = withDefaults(defineProps<Props>(), {
    variant: 'default',
})
</script>

<template>
    <div :class="[
        'rounded-xl transition-all duration-200',
        variant === 'featured'
            ? 'p-8 bg-primary-50 dark:bg-primary-900/20 border border-primary-200 dark:border-primary-800'
            : variant === 'compact'
                ? 'p-4 bg-white dark:bg-surface-900'
                : 'p-6 bg-white dark:bg-surface-900 border border-surface-200 dark:border-surface-700'
    ]">
        <!-- Quote icon -->
        <svg v-if="variant !== 'compact'" class="w-8 h-8 text-primary-300 dark:text-primary-700 mb-4"
            fill="currentColor" viewBox="0 0 24 24">
            <path
                d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.983z" />
        </svg>

        <!-- Quote -->
        <blockquote :class="[
            'text-surface-700 dark:text-surface-300',
            variant === 'featured' ? 'text-body-lg' : 'text-body-md'
        ]">
            "{{ quote }}"
        </blockquote>

        <!-- Rating -->
        <div v-if="rating" class="flex gap-1 mt-4">
            <svg v-for="i in 5" :key="i" :class="[
                'w-4 h-4',
                i <= rating ? 'text-yellow-400' : 'text-surface-300 dark:text-surface-600'
            ]" fill="currentColor" viewBox="0 0 20 20">
                <path
                    d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
            </svg>
        </div>

        <!-- Author -->
        <div class="flex items-center gap-3 mt-4 pt-4 border-t border-surface-100 dark:border-surface-800">
            <UAvatar v-if="avatar" :src="avatar" :name="name" size="sm" />
            <div v-else
                class="w-8 h-8 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center text-primary-600 dark:text-primary-400 text-label-lg">
                {{ name.charAt(0) }}
            </div>
            <div>
                <p class="text-title-sm text-surface-900 dark:text-white">
                    {{ name }}
                </p>
                <p class="text-body-sm text-surface-500 dark:text-surface-400">
                    {{ role }}
                    <span v-if="location"> · {{ location }}</span>
                </p>
            </div>
        </div>
    </div>
</template>
