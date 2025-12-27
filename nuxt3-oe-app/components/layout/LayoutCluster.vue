<script setup lang="ts">
/**
 * LayoutCluster - Horizontal flex with wrapping for inline elements
 * @example <LayoutCluster gap="sm" justify="between">Buttons</LayoutCluster>
 */

interface Props {
    gap?: 'none' | 'xs' | 'sm' | 'md' | 'lg'
    justify?: 'start' | 'center' | 'end' | 'between' | 'around'
    align?: 'start' | 'center' | 'end' | 'baseline'
    wrap?: boolean
    as?: string
}

const props = withDefaults(defineProps<Props>(), {
    gap: 'sm',
    justify: 'start',
    align: 'center',
    wrap: true,
    as: 'div',
})

// Gap classes
const gapClasses = {
    none: 'gap-0',
    xs: 'gap-1',    // 4px
    sm: 'gap-2',    // 8px
    md: 'gap-4',    // 16px
    lg: 'gap-6',    // 24px
}

// Justify content classes
const justifyClasses = {
    start: 'justify-start',
    center: 'justify-center',
    end: 'justify-end',
    between: 'justify-between',
    around: 'justify-around',
}

// Align items classes
const alignClasses = {
    start: 'items-start',
    center: 'items-center',
    end: 'items-end',
    baseline: 'items-baseline',
}

const classes = computed(() => [
    'flex',
    props.wrap ? 'flex-wrap' : 'flex-nowrap',
    gapClasses[props.gap],
    justifyClasses[props.justify],
    alignClasses[props.align],
])
</script>

<template>
    <component :is="as" :class="classes">
        <slot />
    </component>
</template>
