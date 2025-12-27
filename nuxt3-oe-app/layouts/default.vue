<script setup lang="ts">
/**
 * Default Layout
 * Public pages layout with header/footer
 */

import { siteConfig } from "~/config/site.config";
import { mainNav, footerNav } from "~/config/nav.config";

const uiStore = useUIStore();
const route = useRoute();

// Initialize dark mode on client
onMounted(() => {
  uiStore.initDarkMode();
});

// Close mobile menu on route change
watch(
  () => route.path,
  () => {
    uiStore.closeMobileMenu();
  }
);
</script>

<template>
  <div class="min-h-screen bg-white dark:bg-slate-950">
    <!-- Header -->
    <header
      class="sticky top-0 z-40 w-full border-b border-slate-200 bg-white/80 backdrop-blur-lg dark:border-slate-800 dark:bg-slate-950/80"
    >
      <nav
        class="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8"
      >
        <!-- Logo -->
        <NuxtLink to="/" class="flex items-center gap-2">
          <div
            class="flex h-8 w-8 items-center justify-center rounded-lg bg-brand-500"
          >
            <Icon name="ph:scales-bold" class="h-5 w-5 text-white" />
          </div>
          <span class="text-lg font-semibold text-slate-900 dark:text-white">
            {{ siteConfig.name }}
          </span>
        </NuxtLink>

        <!-- Desktop Nav -->
        <div class="hidden items-center gap-1 md:flex">
          <NuxtLink
            v-for="item in mainNav.filter((i) => !i.requiresAuth)"
            :key="item.to"
            :to="item.to"
            class="rounded-lg px-3 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-100 hover:text-slate-900 dark:text-slate-400 dark:hover:bg-slate-800 dark:hover:text-white"
          >
            {{ item.label }}
          </NuxtLink>
        </div>

        <!-- Coming Soon badge -->
        <div class="hidden items-center gap-3 md:flex">
          <span
            class="badge badge-brand px-3 py-1.5 text-xs font-medium"
          >
            Coming Soon
          </span>
        </div>

        <!-- Mobile menu button -->
        <button
          class="rounded-lg p-2 text-slate-600 hover:bg-slate-100 md:hidden dark:text-slate-400 dark:hover:bg-slate-800"
          @click="uiStore.toggleMobileMenu"
        >
          <Icon
            :name="uiStore.mobileMenuOpen ? 'ph:x' : 'ph:list'"
            class="h-6 w-6"
          />
        </button>
      </nav>

      <!-- Mobile menu -->
      <Transition
        enter-active-class="duration-200 ease-out"
        enter-from-class="opacity-0 -translate-y-2"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-2"
      >
        <div
          v-if="uiStore.mobileMenuOpen"
          class="border-t border-slate-200 bg-white px-4 py-4 md:hidden dark:border-slate-800 dark:bg-slate-950"
        >
          <div class="flex flex-col gap-1">
            <NuxtLink
              v-for="item in mainNav.filter((i) => !i.requiresAuth)"
              :key="item.to"
              :to="item.to"
              class="rounded-lg px-3 py-2 text-base font-medium text-slate-600 hover:bg-slate-100 dark:text-slate-400 dark:hover:bg-slate-800"
            >
              {{ item.label }}
            </NuxtLink>
          </div>
          <div
            class="mt-4 flex items-center justify-center border-t border-slate-200 pt-4 dark:border-slate-800"
          >
            <span class="badge badge-brand px-4 py-2 text-sm font-medium">
              Coming Soon
            </span>
          </div>
        </div>
      </Transition>
    </header>

    <!-- Main content -->
    <main>
      <slot />
    </main>

    <!-- Footer -->
    <footer
      class="border-t border-slate-200 bg-slate-50 dark:border-slate-800 dark:bg-slate-900"
    >
      <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div class="grid gap-8 md:grid-cols-2 lg:grid-cols-5">
          <!-- Brand -->
          <div class="lg:col-span-2">
            <NuxtLink to="/" class="flex items-center gap-2">
              <div
                class="flex h-8 w-8 items-center justify-center rounded-lg bg-brand-500"
              >
                <Icon name="ph:scales-bold" class="h-5 w-5 text-white" />
              </div>
              <span
                class="text-lg font-semibold text-slate-900 dark:text-white"
              >
                {{ siteConfig.name }}
              </span>
            </NuxtLink>
            <p class="mt-4 max-w-xs text-sm text-slate-600 dark:text-slate-400">
              {{ siteConfig.description }}
            </p>
          </div>

          <!-- Links -->
          <div>
            <h4 class="text-sm font-semibold text-slate-900 dark:text-white">
              Product
            </h4>
            <ul class="mt-4 space-y-2">
              <li v-for="item in footerNav.product" :key="item.to">
                <NuxtLink
                  :to="item.to"
                  class="text-sm text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white"
                >
                  {{ item.label }}
                </NuxtLink>
              </li>
            </ul>
          </div>

          <div>
            <h4 class="text-sm font-semibold text-slate-900 dark:text-white">
              Company
            </h4>
            <ul class="mt-4 space-y-2">
              <li v-for="item in footerNav.company" :key="item.to">
                <NuxtLink
                  :to="item.to"
                  class="text-sm text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white"
                >
                  {{ item.label }}
                </NuxtLink>
              </li>
            </ul>
          </div>

          <div>
            <h4 class="text-sm font-semibold text-slate-900 dark:text-white">
              Legal
            </h4>
            <ul class="mt-4 space-y-2">
              <li v-for="item in footerNav.legal" :key="item.to">
                <NuxtLink
                  :to="item.to"
                  class="text-sm text-slate-600 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white"
                >
                  {{ item.label }}
                </NuxtLink>
              </li>
            </ul>
          </div>
        </div>

        <!-- Bottom -->
        <div
          class="mt-12 flex flex-col items-center justify-between gap-4 border-t border-slate-200 pt-8 dark:border-slate-800 md:flex-row"
        >
          <p class="text-sm text-slate-500">
            © {{ new Date().getFullYear() }} {{ siteConfig.name }}. Built for
            humanity.
          </p>
          <div class="flex gap-4">
            <a
              href="#"
              class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300"
            >
              <Icon name="ph:twitter-logo" class="h-5 w-5" />
            </a>
            <a
              href="#"
              class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300"
            >
              <Icon name="ph:github-logo" class="h-5 w-5" />
            </a>
            <a
              href="#"
              class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300"
            >
              <Icon name="ph:discord-logo" class="h-5 w-5" />
            </a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>
