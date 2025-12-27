<script setup lang="ts">
/**
 * ExchangeVisual - Interactive exchange demonstration
 * Shows how fair exchange works between two people
 */

interface Participant {
    name: string
    role: string
    rate: number
    hours: number
}

interface Props {
    provider: Participant
    receiver: Participant
}

const props = defineProps<Props>()

const providerValue = computed(() => props.provider.hours * props.provider.rate)
const receiverValue = computed(() => props.receiver.hours * props.receiver.rate)
const isBalanced = computed(() => Math.abs(providerValue.value - receiverValue.value) < 1)
</script>

<template>
    <div class="relative mt-12 max-w-2xl mx-auto">
        <div
            class="p-6 lg:p-8 rounded-2xl bg-surface-50 dark:bg-surface-800/50 border border-surface-200 dark:border-surface-700">
            <!-- Exchange participants -->
            <div class="flex items-center justify-between gap-4">
                <!-- Provider -->
                <div class="flex-1 text-center">
                    <div
                        class="w-16 h-16 mx-auto mb-3 rounded-full bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
                        <span class="text-2xl font-display text-primary-600 dark:text-primary-400">
                            {{ provider.name.charAt(0) }}
                        </span>
                    </div>
                    <p class="text-title-sm text-surface-900 dark:text-white">{{ provider.name }}</p>
                    <p class="text-body-sm text-surface-500">{{ provider.role }}</p>
                    <p class="text-label-lg text-primary-600 dark:text-primary-400 mt-1">
                        @ ${{ provider.rate }}/hr
                    </p>
                </div>

                <!-- Exchange indicator -->
                <div class="flex flex-col items-center gap-2">
                    <div class="text-3xl">⟷</div>
                    <span :class="[
                        'px-3 py-1 rounded-full text-label-md',
                        isBalanced
                            ? 'bg-secondary-100 dark:bg-secondary-900/30 text-secondary-700 dark:text-secondary-300'
                            : 'bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-300'
                    ]">
                        {{ isBalanced ? '✓ Fair Exchange' : 'Unbalanced' }}
                    </span>
                </div>

                <!-- Receiver -->
                <div class="flex-1 text-center">
                    <div
                        class="w-16 h-16 mx-auto mb-3 rounded-full bg-secondary-100 dark:bg-secondary-900/30 flex items-center justify-center">
                        <span class="text-2xl font-display text-secondary-600 dark:text-secondary-400">
                            {{ receiver.name.charAt(0) }}
                        </span>
                    </div>
                    <p class="text-title-sm text-surface-900 dark:text-white">{{ receiver.name }}</p>
                    <p class="text-body-sm text-surface-500">{{ receiver.role }}</p>
                    <p class="text-label-lg text-secondary-600 dark:text-secondary-400 mt-1">
                        @ ${{ receiver.rate }}/hr
                    </p>
                </div>
            </div>

            <!-- Value calculation -->
            <div class="mt-6 pt-6 border-t border-surface-200 dark:border-surface-700">
                <div class="flex justify-between items-center text-center">
                    <div class="flex-1">
                        <p class="text-headline-sm text-primary-600 dark:text-primary-400">
                            {{ provider.hours }} hours = ${{ providerValue }}
                        </p>
                    </div>
                    <div class="text-2xl text-surface-400">=</div>
                    <div class="flex-1">
                        <p class="text-headline-sm text-secondary-600 dark:text-secondary-400">
                            {{ receiver.hours }} hours = ${{ receiverValue }}
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
