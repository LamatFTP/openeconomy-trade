/**
 * Breakpoint Composable
 * Reactive breakpoint detection
 */

import { useMediaQuery } from '@vueuse/core'

export function useBreakpoint() {
  const isMobile = useMediaQuery('(max-width: 639px)')
  const isTablet = useMediaQuery('(min-width: 640px) and (max-width: 1023px)')
  const isDesktop = useMediaQuery('(min-width: 1024px)')
  const isLargeDesktop = useMediaQuery('(min-width: 1280px)')

  const current = computed(() => {
    if (isMobile.value) return 'mobile'
    if (isTablet.value) return 'tablet'
    if (isLargeDesktop.value) return 'xl'
    return 'desktop'
  })

  return {
    isMobile,
    isTablet,
    isDesktop,
    isLargeDesktop,
    current,
    // Helpers for conditional rendering
    isMobileOrTablet: computed(() => isMobile.value || isTablet.value),
    isDesktopOrLarger: computed(() => isDesktop.value || isLargeDesktop.value),
  }
}
