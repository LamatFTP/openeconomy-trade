/**
 * Content Store - Central state for all page content
 * Manages loading states, caching, and data fetching
 * Currently uses static JSON, easily swappable to Firestore
 */
import { defineStore } from "pinia";
import type { PageContent } from "~/types/content";

// Static imports for JSON content (will be replaced by Firestore fetches)
import landingContent from "~/content/data/pages/landing.json";
import howItWorksContent from "~/content/data/pages/how-it-works.json";
import participateContent from "~/content/data/pages/participate.json";
import faqContent from "~/content/data/pages/faq.json";
import aboutContent from "~/content/data/pages/about.json";
import contributeContent from "~/content/data/pages/contribute.json";
import communityContent from "~/content/data/pages/community.json";
import testimonialsContent from "~/content/data/collections/testimonials.json";

// Page content map
const PAGE_CONTENT: Record<string, PageContent> = {
  landing: landingContent as unknown as PageContent,
  "how-it-works": howItWorksContent as unknown as PageContent,
  participate: participateContent as unknown as PageContent,
  faq: faqContent as unknown as PageContent,
  about: aboutContent as unknown as PageContent,
  contribute: contributeContent as unknown as PageContent,
  community: communityContent as unknown as PageContent,
};

// Collection content map
const COLLECTION_CONTENT: Record<string, unknown[]> = {
  testimonials: testimonialsContent,
};

export const useContentStore = defineStore("content", () => {
  // State
  const pages = ref<Record<string, PageContent>>({});
  const collections = ref<Record<string, unknown[]>>({});
  const loading = ref<Record<string, boolean>>({});
  const errors = ref<Record<string, Error | null>>({});

  // Getters
  const getPage = computed(() => (slug: string) => pages.value[slug] || null);
  const getCollection = computed(
    () => (name: string) => collections.value[name] || []
  );
  const isLoading = computed(
    () => (key: string) => loading.value[key] || false
  );
  const getError = computed(() => (key: string) => errors.value[key] || null);

  /**
   * Fetch a single page by slug
   * Currently loads from static imports, will swap to Firestore later
   */
  async function fetchPage(slug: string): Promise<PageContent | null> {
    // Return cached if exists
    if (pages.value[slug]) {
      return pages.value[slug];
    }

    const key = `page:${slug}`;
    loading.value[key] = true;
    errors.value[key] = null;

    try {
      // Simulate async fetch (for future Firestore compatibility)
      await new Promise((resolve) => setTimeout(resolve, 50));

      const content = PAGE_CONTENT[slug];
      if (!content) {
        throw new Error(`Page not found: ${slug}`);
      }

      pages.value[slug] = content;
      return pages.value[slug];
    } catch (e) {
      errors.value[key] = e as Error;
      console.error(`[ContentStore] Failed to fetch page: ${slug}`, e);
      return null;
    } finally {
      loading.value[key] = false;
    }
  }

  /**
   * Fetch a collection of items
   * Currently loads from static imports, will swap to Firestore later
   */
  async function fetchCollection<T = unknown>(name: string): Promise<T[]> {
    // Return cached if exists
    if (collections.value[name]) {
      return collections.value[name] as T[];
    }

    const key = `collection:${name}`;
    loading.value[key] = true;
    errors.value[key] = null;

    try {
      // Simulate async fetch (for future Firestore compatibility)
      await new Promise((resolve) => setTimeout(resolve, 50));

      const content = COLLECTION_CONTENT[name];
      if (!content) {
        throw new Error(`Collection not found: ${name}`);
      }

      collections.value[name] = content;
      return collections.value[name] as T[];
    } catch (e) {
      errors.value[key] = e as Error;
      console.error(`[ContentStore] Failed to fetch collection: ${name}`, e);
      return [];
    } finally {
      loading.value[key] = false;
    }
  }

  /**
   * Clear cache for a specific key or all
   */
  function clearCache(key?: string) {
    if (key) {
      if (key.startsWith("page:")) {
        delete pages.value[key.replace("page:", "")];
      } else if (key.startsWith("collection:")) {
        delete collections.value[key.replace("collection:", "")];
      }
    } else {
      pages.value = {};
      collections.value = {};
    }
  }

  /**
   * Refresh content (clear cache and refetch)
   */
  async function refresh(key: string) {
    clearCache(key);
    if (key.startsWith("page:")) {
      return fetchPage(key.replace("page:", ""));
    } else if (key.startsWith("collection:")) {
      return fetchCollection(key.replace("collection:", ""));
    }
  }

  return {
    // State
    pages: readonly(pages),
    collections: readonly(collections),
    loading: readonly(loading),
    errors: readonly(errors),
    // Getters
    getPage,
    getCollection,
    isLoading,
    getError,
    // Actions
    fetchPage,
    fetchCollection,
    clearCache,
    refresh,
  };
});
