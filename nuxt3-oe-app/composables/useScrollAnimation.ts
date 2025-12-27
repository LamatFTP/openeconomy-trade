/**
 * Scroll Animation Composable
 * IntersectionObserver-based scroll animations
 */

import { ref, onMounted, onUnmounted } from 'vue'
import type { Ref } from 'vue'

export interface ScrollAnimationOptions {
  threshold?: number
  rootMargin?: string
  once?: boolean
  delay?: number
}

export function useScrollAnimation(
  target: Ref<HTMLElement | null>,
  options: ScrollAnimationOptions = {}
) {
  const {
    threshold = 0.1,
    rootMargin = '0px',
    once = true,
    delay = 0,
  } = options

  const isVisible = ref(false)
  const hasAnimated = ref(false)
  let observer: IntersectionObserver | null = null

  onMounted(() => {
    if (!target.value) return

    observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            if (delay > 0) {
              setTimeout(() => {
                isVisible.value = true
                hasAnimated.value = true
              }, delay)
            } else {
              isVisible.value = true
              hasAnimated.value = true
            }

            if (once && observer) {
              observer.unobserve(entry.target)
            }
          } else if (!once) {
            isVisible.value = false
          }
        })
      },
      {
        threshold,
        rootMargin,
      }
    )

    observer.observe(target.value)
  })

  onUnmounted(() => {
    if (observer) {
      observer.disconnect()
    }
  })

  return {
    isVisible,
    hasAnimated,
  }
}

/**
 * Stagger children animations
 */
export function useStaggerAnimation(
  container: Ref<HTMLElement | null>,
  options: ScrollAnimationOptions & { staggerDelay?: number } = {}
) {
  const { staggerDelay = 100, ...scrollOptions } = options
  const { isVisible } = useScrollAnimation(container, scrollOptions)

  function getStaggerStyle(index: number) {
    return {
      transitionDelay: `${index * staggerDelay}ms`,
    }
  }

  return {
    isVisible,
    getStaggerStyle,
  }
}
