<script setup lang="ts">
/**
 * LayoutGrid - Responsive CSS Grid with breakpoint-aware columns
 * @example <LayoutGrid :cols="3" gap="lg">Items</LayoutGrid>
 * @example <LayoutGrid :cols="{ sm: 1, md: 2, lg: 3 }" gap="md">Items</LayoutGrid>
 */

interface ResponsiveCols {
    sm?: number
    md?: number
    lg?: number
    xl?: number
}

interface Props {
    cols?: number | ResponsiveCols
    gap?: 'none' | 'sm' | 'md' | 'lg' | 'xl'
    as?: string
}

const props = withDefaults(defineProps<Props>(), {
    cols: 1,
    gap: 'md',
    as: 'div',
})

// Gap classes
const gapClasses = {
    none: 'gap-0',
    sm: 'gap-2',    // 8px
    md: 'gap-4',    // 16px
    lg: 'gap-6',    // 24px
    xl: 'gap-8',    // 32px
}

// Column class maps for each breakpoint
const colClassMap: Record<number, string> = {
    1: 'grid-cols-1',
    2: 'grid-cols-2',
    3: 'grid-cols-3',
    4: 'grid-cols-4',
    5: 'grid-cols-5',
    6: 'grid-cols-6',
    12: 'grid-cols-12',
}

const mdColClassMap: Record<number, string> = {
    1: 'md:grid-cols-1',
    2: 'md:grid-cols-2',
    3: 'md:grid-cols-3',
    4: 'md:grid-cols-4',
    5: 'md:grid-cols-5',
    6: 'md:grid-cols-6',
    12: 'md:grid-cols-12',
}

const lgColClassMap: Record<number, string> = {
    1: 'lg:grid-cols-1',
    2: 'lg:grid-cols-2',
    3: 'lg:grid-cols-3',
    4: 'lg:grid-cols-4',
    5: 'lg:grid-cols-5',
    6: 'lg:grid-cols-6',
    12: 'lg:grid-cols-12',
}

const xlColClassMap: Record<number, string> = {
    1: 'xl:grid-cols-1',
    2: 'xl:grid-cols-2',
    3: 'xl:grid-cols-3',
    4: 'xl:grid-cols-4',
    5: 'xl:grid-cols-5',
    6: 'xl:grid-cols-6',
    12: 'xl:grid-cols-12',
}

const columnClasses = computed(() => {
    // If cols is a number, use same columns at all breakpoints
    if (typeof props.cols === 'number') {
        return colClassMap[props.cols] || 'grid-cols-1'
    }

    // Responsive object: { sm: 1, md: 2, lg: 3 }
    const responsive = props.cols as ResponsiveCols
    const classes: string[] = []

    // Base/sm columns (always start with sm or default to 1)
    const smCols = responsive.sm || 1
    classes.push(colClassMap[smCols] || 'grid-cols-1')

    // md breakpoint
    if (responsive.md) {
        classes.push(mdColClassMap[responsive.md] || '')
    }

    // lg breakpoint
    if (responsive.lg) {
        classes.push(lgColClassMap[responsive.lg] || '')
    }

    // xl breakpoint
    if (responsive.xl) {
        classes.push(xlColClassMap[responsive.xl] || '')
    }

    return classes.join(' ')
})

const classes = computed(() => [
    'grid',
    gapClasses[props.gap],
    columnClasses.value,
])
</script>

<template>
    <component :is="as" :class="classes">
        <slot />
    </component>
</template>
