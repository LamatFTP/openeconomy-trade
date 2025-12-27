<script setup lang="ts">
import { Icon as IconifyIcon } from "@iconify/vue";

interface Props {
  name: string;
  size?: string | number;
  class?: string;
}

const props = withDefaults(defineProps<Props>(), {
  size: "1em",
  class: "",
});
</script>

<template>
  <IconifyIcon :icon="name" :width="size" :height="size" :class="props.class" />
</template>
