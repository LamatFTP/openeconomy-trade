<script setup lang="ts">
/**
 * StatsRow - Stats display with optional count-up animation
 * @example <StatsRow :stats="stats" />
 */
import type { StatItem } from '~/types/content'

interface Props {
    stats: StatItem[]
    columns?: 2 | 3 | 4
    variant?: 'default' | 'card' | 'minimal'
}

const props = withDefaults(defineProps<Props>(), {
    columns: 4,
    variant: 'default',
})

const colClasses = {
    2: 'grid-cols-2',
    3: 'grid-cols-3',
    4: 'grid-cols-2 lg:grid-cols-4',
}
</script>

<template>
    <div :class="['grid gap-8', colClasses[columns]]">
        <MotionStagger :stagger-delay="100">
            <template #default="{ getStaggerStyle }">
                <div v-for="(stat, index) in stats" :key="stat.label" :style="getStaggerStyle(index)" :class="[
                    'text-center',
                    variant === 'card' && 'p-6 rounded-xl bg-surface-50 dark:bg-surface-800'
                ]">
                    <!-- Value -->
                    <div class="text-display-sm lg:text-display-md font-display text-primary-600 dark:text-primary-400">
                        <span v-if="stat.prefix">{{ stat.prefix }}</span>
                        <span>{{ stat.value }}</span>
                        <span v-if="stat.suffix">{{ stat.suffix }}</span>
                    </div>

                    <!-- Label -->
                    <p class="mt-2 text-body-md text-surface-600 dark:text-surface-400">
                        {{ stat.label }}
                    </p>
                </div>
            </template>
        </MotionStagger>
    </div>
</template>
