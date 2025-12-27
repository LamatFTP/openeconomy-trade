<script setup lang="ts">
/**
 * UInput - Base input component
 * Supports various types, validation states, icons
 */

interface Props {
  modelValue?: string | number
  type?: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url' | 'search'
  placeholder?: string
  disabled?: boolean
  readonly?: boolean
  error?: string
  icon?: string
  iconRight?: string
  size?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  size: 'md',
  modelValue: '',
})

const emit = defineEmits<{
  'update:modelValue': [value: string | number]
  focus: [event: FocusEvent]
  blur: [event: FocusEvent]
}>()

const sizeClasses = {
  sm: 'py-1.5 text-sm',
  md: 'py-2.5 text-sm',
  lg: 'py-3 text-base',
}

const inputValue = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value),
})

const inputClasses = computed(() => [
  'input',
  sizeClasses[props.size],
  props.error && 'input-error',
  props.icon && 'pl-10',
  props.iconRight && 'pr-10',
])
</script>

<template>
  <div class="relative">
    <!-- Left icon -->
    <div v-if="icon" class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
      <Icon :name="icon" class="h-5 w-5 text-slate-400" />
    </div>

    <!-- Input -->
    <input
      v-model="inputValue"
      :type="type"
      :placeholder="placeholder"
      :disabled="disabled"
      :readonly="readonly"
      :class="inputClasses"
      @focus="emit('focus', $event)"
      @blur="emit('blur', $event)"
    />

    <!-- Right icon -->
    <div v-if="iconRight" class="absolute inset-y-0 right-0 flex items-center pr-3">
      <Icon :name="iconRight" class="h-5 w-5 text-slate-400" />
    </div>

    <!-- Error message -->
    <p v-if="error" class="mt-1.5 text-sm text-red-500">
      {{ error }}
    </p>
  </div>
</template>
