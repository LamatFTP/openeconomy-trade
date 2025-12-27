<script setup lang="ts">
/**
 * FeatureCard - Icon + title + description card
 * @example <FeatureCard icon="ph:star" title="Feature" description="..." />
 */

interface Props {
    icon: string
    title: string
    description: string
    variant?: 'default' | 'bordered' | 'elevated'
    align?: 'left' | 'center'
    size?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
    variant: 'default',
    align: 'left',
    size: 'md',
})

const variantClasses = {
    default: 'bg-white dark:bg-surface-900',
    bordered: 'bg-white dark:bg-surface-900 border border-surface-200 dark:border-surface-700',
    elevated: 'bg-white dark:bg-surface-900 shadow-elevation-2',
}

const alignClasses = {
    left: 'text-left items-start',
    center: 'text-center items-center',
}

const iconSizeClasses = {
    sm: 'w-10 h-10 text-xl',
    md: 'w-12 h-12 text-2xl',
    lg: 'w-14 h-14 text-3xl',
}

const paddingClasses = {
    sm: 'p-4',
    md: 'p-6',
    lg: 'p-8',
}
</script>

<template>
    <div :class="[
        'flex flex-col gap-4 rounded-xl transition-all duration-200',
        variantClasses[variant],
        alignClasses[align],
        paddingClasses[size],
        'hover:shadow-elevation-2 hover:-translate-y-0.5'
    ]">
        <!-- Icon -->
        <div :class="[
            'flex items-center justify-center rounded-xl',
            'bg-primary-100 dark:bg-primary-900/30 text-primary-600 dark:text-primary-400',
            iconSizeClasses[size]
        ]">
            <Icon :name="icon" class="w-6 h-6" />
        </div>

        <!-- Title -->
        <h3 class="text-title-md text-surface-900 dark:text-white">
            {{ title }}
        </h3>

        <!-- Description -->
        <p class="text-body-md text-surface-600 dark:text-surface-400">
            {{ description }}
        </p>
    </div>
</template>
