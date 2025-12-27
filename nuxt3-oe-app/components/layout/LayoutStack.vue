<script setup lang="ts">
/**
 * LayoutStack - Vertical flex container with consistent gap spacing
 * @example <LayoutStack gap="lg" align="center">Items</LayoutStack>
 */

interface Props {
    gap?: 'none' | 'xs' | 'sm' | 'md' | 'lg' | 'xl'
    align?: 'start' | 'center' | 'end' | 'stretch'
    as?: string
}

const props = withDefaults(defineProps<Props>(), {
    gap: 'md',
    align: 'stretch',
    as: 'div',
})

// Gap classes (Tailwind spacing scale)
const gapClasses = {
    none: 'gap-0',
    xs: 'gap-1',    // 4px
    sm: 'gap-2',    // 8px
    md: 'gap-4',    // 16px
    lg: 'gap-6',    // 24px
    xl: 'gap-8',    // 32px
}

// Alignment classes
const alignClasses = {
    start: 'items-start',
    center: 'items-center',
    end: 'items-end',
    stretch: 'items-stretch',
}

const classes = computed(() => [
    'flex flex-col',
    gapClasses[props.gap],
    alignClasses[props.align],
])
</script>

<template>
    <component :is="as" :class="classes">
        <slot />
    </component>
</template>
