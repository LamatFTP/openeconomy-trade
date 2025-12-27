<script setup lang="ts">
/**
 * MotionStagger - Stagger children animations on scroll
 */

interface Props {
  staggerDelay?: number
  duration?: number
  threshold?: number
  as?: string
}

const props = withDefaults(defineProps<Props>(), {
  staggerDelay: 100,
  duration: 400,
  threshold: 0.1,
  as: 'div',
})

const el = ref<HTMLElement | null>(null)
const { isVisible, getStaggerStyle } = useStaggerAnimation(el, {
  threshold: props.threshold,
  staggerDelay: props.staggerDelay,
})

// Provide stagger context to children
provide('motionStagger', {
  isVisible,
  getStaggerStyle,
  duration: props.duration,
})
</script>

<template>
  <component :is="as" ref="el">
    <slot :is-visible="isVisible" :get-stagger-style="getStaggerStyle" />
  </component>
</template>
