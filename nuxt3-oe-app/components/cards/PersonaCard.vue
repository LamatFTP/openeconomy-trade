<script setup lang="ts">
/**
 * PersonaCard - User story/persona display
 * @example <PersonaCard name="Maria" role="Caregiver" quote="..." :skills="['Cooking']" />
 */

interface Props {
    icon?: string
    avatar?: string
    name: string
    role: string
    quote: string
    skills?: string[]
    problem?: string
}

const props = defineProps<Props>()
</script>

<template>
    <div
        class="p-6 rounded-xl border border-surface-200 dark:border-surface-700 bg-white dark:bg-surface-900 hover:shadow-elevation-2 transition-all duration-200">
        <!-- Header: Icon/Avatar + Name -->
        <div class="flex items-start gap-4 mb-4">
            <!-- Icon or Avatar -->
            <div v-if="icon || avatar" class="shrink-0">
                <div v-if="icon"
                    class="w-12 h-12 rounded-xl bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
                    <Icon :name="icon" class="w-6 h-6 text-primary-600 dark:text-primary-400" />
                </div>
                <UAvatar v-else-if="avatar" :src="avatar" :name="name" size="lg" />
            </div>

            <!-- Name & Role -->
            <div>
                <h3 class="text-title-md text-surface-900 dark:text-white">
                    {{ name }}
                </h3>
                <p class="text-body-sm text-surface-500 dark:text-surface-400">
                    {{ role }}
                </p>
            </div>
        </div>

        <!-- Quote -->
        <blockquote class="text-body-md text-surface-700 dark:text-surface-300 italic mb-4">
            "{{ quote }}"
        </blockquote>

        <!-- Skills -->
        <div v-if="skills && skills.length" class="flex flex-wrap gap-2 mb-4">
            <span v-for="skill in skills" :key="skill"
                class="px-2 py-1 text-label-md rounded-full bg-secondary-100 dark:bg-secondary-900/30 text-secondary-700 dark:text-secondary-300">
                {{ skill }}
            </span>
        </div>

        <!-- Problem -->
        <p v-if="problem"
            class="text-body-sm text-surface-500 dark:text-surface-400 pt-4 border-t border-surface-100 dark:border-surface-800">
            <span class="text-red-500">Problem:</span> {{ problem }}
        </p>
    </div>
</template>
