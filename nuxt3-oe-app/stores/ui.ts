/**
 * UI Store
 * Global UI state (sidebar, dark mode, loading states)
 */

import { defineStore } from 'pinia'

export const useUIStore = defineStore('ui', () => {
  // Sidebar state
  const sidebarOpen = ref(false)
  const sidebarCollapsed = ref(false)

  // Dark mode
  const isDark = ref(false)

  // Global loading
  const isLoading = ref(false)
  const loadingMessage = ref('')

  // Mobile menu
  const mobileMenuOpen = ref(false)

  // Actions
  function toggleSidebar() {
    sidebarOpen.value = !sidebarOpen.value
  }

  function toggleSidebarCollapse() {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  function toggleDarkMode() {
    isDark.value = !isDark.value
    if (typeof document !== 'undefined') {
      document.documentElement.classList.toggle('dark', isDark.value)
      localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
    }
  }

  function setDarkMode(value: boolean) {
    isDark.value = value
    if (typeof document !== 'undefined') {
      document.documentElement.classList.toggle('dark', value)
      localStorage.setItem('theme', value ? 'dark' : 'light')
    }
  }

  function startLoading(message = '') {
    isLoading.value = true
    loadingMessage.value = message
  }

  function stopLoading() {
    isLoading.value = false
    loadingMessage.value = ''
  }

  function toggleMobileMenu() {
    mobileMenuOpen.value = !mobileMenuOpen.value
  }

  function closeMobileMenu() {
    mobileMenuOpen.value = false
  }

  // Initialize dark mode from localStorage
  function initDarkMode() {
    if (typeof window === 'undefined') return

    const stored = localStorage.getItem('theme')
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches

    if (stored === 'dark' || (!stored && prefersDark)) {
      setDarkMode(true)
    }
  }

  return {
    // State
    sidebarOpen,
    sidebarCollapsed,
    isDark,
    isLoading,
    loadingMessage,
    mobileMenuOpen,
    // Actions
    toggleSidebar,
    toggleSidebarCollapse,
    toggleDarkMode,
    setDarkMode,
    startLoading,
    stopLoading,
    toggleMobileMenu,
    closeMobileMenu,
    initDarkMode,
  }
})
