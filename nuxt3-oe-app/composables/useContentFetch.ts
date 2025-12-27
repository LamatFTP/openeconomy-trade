/**
 * useContentFetch - Generic content fetching composable
 * Works with JSON files now, easily swappable to Firestore later
 */
import type { PageContent, FetchOptions } from "~/types/content";

interface ContentFetchReturn<T> {
  data: Ref<T | null>;
  loading: Ref<boolean>;
  error: Ref<Error | null>;
  refresh: () => Promise<void>;
}

/**
 * Fetch page content by slug
 * @param slug - Page slug (e.g., 'landing', 'how-it-works')
 * @param options - Fetch options
 */
export function usePageContent(
  slug: string | Ref<string>,
  options: FetchOptions = {}
): ContentFetchReturn<PageContent> {
  const store = useContentStore();
  const resolvedSlug = computed(() => unref(slug));

  const data = ref<PageContent | null>(null);
  const loading = ref(false);
  const error = ref<Error | null>(null);

  async function fetch() {
    loading.value = true;
    error.value = null;

    try {
      const result = await store.fetchPage(resolvedSlug.value);
      data.value = options.transform
        ? (options.transform(result) as PageContent)
        : result;
    } catch (e) {
      error.value = e as Error;
    } finally {
      loading.value = false;
    }
  }

  async function refresh() {
    await store.refresh(`page:${resolvedSlug.value}`);
    await fetch();
  }

  // Immediate fetch by default
  if (options.immediate !== false) {
    fetch();
  }

  // Watch for slug changes
  if (options.watch !== false && isRef(slug)) {
    watch(slug, () => fetch());
  }

  return {
    data: data as Ref<PageContent | null>,
    loading,
    error,
    refresh,
  };
}

/**
 * Fetch collection content
 * @param collection - Collection name (e.g., 'testimonials')
 * @param options - Fetch options
 */
export function useCollectionContent<T = unknown>(
  collection: string | Ref<string>,
  options: FetchOptions = {}
): ContentFetchReturn<T[]> {
  const store = useContentStore();
  const resolvedCollection = computed(() => unref(collection));

  const data = ref<T[] | null>(null);
  const loading = ref(false);
  const error = ref<Error | null>(null);

  async function fetch() {
    loading.value = true;
    error.value = null;

    try {
      const result = await store.fetchCollection<T>(resolvedCollection.value);
      data.value = options.transform
        ? (options.transform(result) as T[])
        : result;
    } catch (e) {
      error.value = e as Error;
    } finally {
      loading.value = false;
    }
  }

  async function refresh() {
    await store.refresh(`collection:${resolvedCollection.value}`);
    await fetch();
  }

  // Immediate fetch by default
  if (options.immediate !== false) {
    fetch();
  }

  // Watch for collection name changes
  if (options.watch !== false && isRef(collection)) {
    watch(collection, () => fetch());
  }

  return {
    data: data as Ref<T[] | null>,
    loading,
    error,
    refresh,
  };
}

/**
 * Legacy export for backwards compatibility
 */
export function useContentFetch<T>(
  source: string,
  options: FetchOptions = {}
): ContentFetchReturn<T> {
  // Determine if it's a page or collection based on path
  if (source.startsWith("pages/")) {
    const slug = source.replace("pages/", "");
    return usePageContent(slug, options) as ContentFetchReturn<T>;
  } else if (source.startsWith("collections/")) {
    const name = source.replace("collections/", "");
    return useCollectionContent<T>(
      name,
      options
    ) as unknown as ContentFetchReturn<T>;
  }

  // Default to page content
  return usePageContent(source, options) as ContentFetchReturn<T>;
}
