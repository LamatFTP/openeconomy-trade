<script setup lang="ts">
/**
 * FAQSection - Accordion FAQ list with categories
 * @example <FAQSection :items="faqItems" />
 */
import type { FAQItem } from '~/types/content'

interface Props {
    items: FAQItem[]
    categories?: string[]
}

const props = withDefaults(defineProps<Props>(), {
    categories: () => [],
})

const activeCategory = ref<string | null>(null)

const filteredItems = computed(() => {
    if (!activeCategory.value) return props.items
    return props.items.filter(item => item.category === activeCategory.value)
})

const openIndex = ref<number | null>(null)

function toggle(index: number) {
    openIndex.value = openIndex.value === index ? null : index
}
</script>

<template>
    <div class="space-y-8">
        <!-- Category Tabs -->
        <div v-if="categories.length > 0" class="flex flex-wrap justify-center gap-2">
            <button :class="[
                'px-4 py-2 rounded-full text-body-sm font-medium transition-colors',
                !activeCategory
                    ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300'
                    : 'bg-surface-100 dark:bg-surface-800 text-surface-600 dark:text-surface-400 hover:bg-surface-200 dark:hover:bg-surface-700'
            ]" @click="activeCategory = null">
                All
            </button>
            <button v-for="cat in categories" :key="cat" :class="[
                'px-4 py-2 rounded-full text-body-sm font-medium transition-colors',
                activeCategory === cat
                    ? 'bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300'
                    : 'bg-surface-100 dark:bg-surface-800 text-surface-600 dark:text-surface-400 hover:bg-surface-200 dark:hover:bg-surface-700'
            ]" @click="activeCategory = cat">
                {{ cat }}
            </button>
        </div>

        <!-- FAQ Items -->
        <div class="space-y-4 max-w-3xl mx-auto">
            <div v-for="(item, index) in filteredItems" :key="index"
                class="border border-surface-200 dark:border-surface-700 rounded-xl overflow-hidden">
                <!-- Question -->
                <button
                    class="w-full flex items-center justify-between p-5 text-left hover:bg-surface-50 dark:hover:bg-surface-800/50 transition-colors"
                    @click="toggle(index)">
                    <span class="text-title-md text-surface-900 dark:text-white pr-4">
                        {{ item.question }}
                    </span>
                    <svg :class="[
                        'w-5 h-5 text-surface-500 transition-transform shrink-0',
                        openIndex === index && 'rotate-180'
                    ]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>

                <!-- Answer -->
                <div v-show="openIndex === index" class="px-5 pb-5">
                    <p class="text-body-md text-surface-600 dark:text-surface-400 whitespace-pre-line">
                        {{ item.answer }}
                    </p>
                </div>
            </div>
        </div>
    </div>
</template>
