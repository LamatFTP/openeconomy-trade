<script setup lang="ts">
/**
 * Root App Component
 * Handles global providers and transitions
 */

// Import site config for meta
import { siteConfig } from "~/config/site.config";

// Set page defaults
useHead({
  titleTemplate: (title) =>
    title ? `${title} | ${siteConfig.name}` : siteConfig.name,
  meta: [{ name: "description", content: siteConfig.description }],
  htmlAttrs: {
    lang: "en",
  },
});
</script>

<template>
  <div>
    <!-- Page content with transitions -->
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>

    <!-- Global toast container -->
    <UToastContainer />
  </div>
</template>
