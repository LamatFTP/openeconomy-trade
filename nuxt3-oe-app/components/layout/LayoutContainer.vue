<script setup lang="ts">
/**
 * LayoutContainer - Max-width centered wrapper with responsive padding
 * @example <LayoutContainer size="lg" padding="md">Content</LayoutContainer>
 */

interface Props {
    size?: 'sm' | 'md' | 'lg' | 'xl' | 'full'
    padding?: 'none' | 'sm' | 'md' | 'lg'
    as?: string
}

const props = withDefaults(defineProps<Props>(), {
    size: 'lg',
    padding: 'md',
    as: 'div',
})

// Max-width classes
const sizeClasses = {
    sm: 'max-w-screen-sm',   // 640px
    md: 'max-w-screen-md',   // 768px
    lg: 'max-w-screen-lg',   // 1024px
    xl: 'max-w-screen-xl',   // 1280px
    full: 'max-w-full',      // 100%
}

// Horizontal padding classes (responsive)
const paddingClasses = {
    none: '',
    sm: 'px-4',
    md: 'px-4 sm:px-6 lg:px-8',
    lg: 'px-6 sm:px-8 lg:px-12',
}

const classes = computed(() => [
    'mx-auto w-full',
    sizeClasses[props.size],
    paddingClasses[props.padding],
])
</script>

<template>
    <component :is="as" :class="classes">
        <slot />
    </component>
</template>
