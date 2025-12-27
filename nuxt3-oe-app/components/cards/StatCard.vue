<script setup lang="ts">
/**
 * StatCard - Single stat display with optional animation
 * @example <StatCard value="1,234" label="Users" suffix="+" />
 */

interface Props {
    value: string | number
    label: string
    prefix?: string
    suffix?: string
    variant?: 'default' | 'card' | 'minimal'
    size?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
    variant: 'default',
    size: 'md',
})

const sizeClasses = {
    sm: {
        value: 'text-headline-md',
        label: 'text-body-sm',
    },
    md: {
        value: 'text-headline-lg lg:text-display-sm',
        label: 'text-body-md',
    },
    lg: {
        value: 'text-display-sm lg:text-display-md',
        label: 'text-body-lg',
    },
}
</script>

<template>
    <div :class="[
        'text-center',
        variant === 'card' && 'p-6 rounded-xl bg-surface-50 dark:bg-surface-800'
    ]">
        <!-- Value -->
        <div :class="[
            'font-display text-primary-600 dark:text-primary-400',
            sizeClasses[size].value
        ]">
            <span v-if="prefix">{{ prefix }}</span>
            <span>{{ value }}</span>
            <span v-if="suffix">{{ suffix }}</span>
        </div>

        <!-- Label -->
        <p :class="[
            'mt-2 text-surface-600 dark:text-surface-400',
            sizeClasses[size].label
        ]">
            {{ label }}
        </p>
    </div>
</template>
