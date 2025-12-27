<script setup lang="ts">
/**
 * MotionFadeIn - Scroll-triggered fade animation
 */

interface Props {
  delay?: number
  duration?: number
  threshold?: number
  once?: boolean
  as?: string
}

const props = withDefaults(defineProps<Props>(), {
  delay: 0,
  duration: 400,
  threshold: 0.1,
  once: true,
  as: 'div',
})

const el = ref<HTMLElement | null>(null)
const { isVisible } = useScrollAnimation(el, {
  threshold: props.threshold,
  once: props.once,
  delay: props.delay,
})

const style = computed(() => ({
  transitionDuration: `${props.duration}ms`,
  transitionDelay: `${props.delay}ms`,
}))
</script>

<template>
  <component
    :is="as"
    ref="el"
    :style="style"
    :class="[
      'transition-all ease-out-expo',
      isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'
    ]"
  >
    <slot />
  </component>
</template>
