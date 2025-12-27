# 🏗️ MASTER WEBSITE BUILDING BLUEPRINT

> **One codebase. Infinite personalities. Config-driven.**

---

## 📊 PROJECT STATUS

### ✅ COMPLETED SYSTEMS

| System | Status | Location | Purpose |
|--------|--------|----------|---------|
| **Core Config** | ✅ | `/config/` | Site branding, nav, features |
| **Tailwind Setup** | ✅ | `tailwind.config.ts` | Design tokens, animations |
| **Base UI** | ✅ | `/components/ui/` | 7 components |
| **Motion System** | ✅ | `/components/motion/` | Scroll animations |
| **Composables** | ✅ | `/composables/` | 5 utilities |
| **State Stores** | ✅ | `/stores/` | Toast, UI state |
| **Default Layout** | ✅ | `/layouts/default.vue` | Public pages |
| **Landing Page** | ✅ | `/pages/index.vue` | Homepage |

### ⏳ PENDING SYSTEMS

| System | Priority | Purpose |
|--------|----------|---------|
| Grid/Layout Primitives | 🔴 HIGH | Material Design responsive grid |
| Personality Config | 🔴 HIGH | Animation/transition presets |
| Form Components | 🔴 HIGH | Select, Textarea, Checkbox, etc. |
| Dashboard Layout | 🟡 MED | Authenticated sidebar layout |
| Firebase Plugin | 🟡 MED | Auth + Firestore init |
| Data Components | 🟡 MED | Table, Skeleton, Empty states |
| Auth Pages | 🟡 MED | Login, Register, Forgot |

---

## 🧬 ARCHITECTURE OVERVIEW

```
nuxt3-oe-app/
├── config/                    # 🎛️ PERSONALITY CENTER
│   ├── site.config.ts         # Branding, meta, URLs
│   ├── nav.config.ts          # Navigation structure
│   ├── theme.config.ts        # ⏳ Colors, fonts, radius
│   └── motion.config.ts       # ⏳ Animation presets
│
├── composables/               # 🔧 SHARED LOGIC
│   ├── useToast.ts            # Notifications
│   ├── useModal.ts            # Modal management
│   ├── useBreakpoint.ts       # Responsive helpers
│   ├── useClickOutside.ts     # Click detection
│   └── useScrollAnimation.ts  # Intersection Observer
│
├── components/
│   ├── ui/                    # 🧱 BASE UI (prefix: U)
│   │   ├── UButton.vue
│   │   ├── UCard.vue
│   │   ├── UBadge.vue
│   │   ├── UInput.vue
│   │   ├── UAvatar.vue
│   │   ├── UModal.vue
│   │   └── UToastContainer.vue
│   │
│   ├── layout/                # 📐 LAYOUT PRIMITIVES (prefix: Layout)
│   │   ├── LayoutContainer.vue    # ⏳ Max-width wrapper
│   │   ├── LayoutGrid.vue         # ⏳ CSS Grid wrapper
│   │   ├── LayoutStack.vue        # ⏳ Vertical spacing
│   │   └── LayoutCluster.vue      # ⏳ Horizontal flex
│   │
│   ├── motion/                # 🎬 ANIMATION WRAPPERS (prefix: Motion)
│   │   ├── MotionFadeIn.vue
│   │   └── MotionStagger.vue
│   │
│   ├── forms/                 # 📝 FORM COMPONENTS (prefix: Form)
│   │   └── ... ⏳
│   │
│   └── [domain]/              # 🎯 DOMAIN-SPECIFIC
│       └── ... (exchange/, participant/, etc.)
│
├── layouts/
│   ├── default.vue            # Public layout (header/footer)
│   └── dashboard.vue          # ⏳ Authenticated (sidebar)
│
├── pages/                     # 📄 ROUTES (file-based)
│   ├── index.vue
│   ├── auth/                  # ⏳
│   ├── dashboard/             # ⏳
│   └── [domain]/              # ⏳
│
├── stores/                    # 🗄️ PINIA STORES
│   ├── toast.ts               # Toast notifications
│   ├── ui.ts                  # UI state (dark mode, sidebar)
│   └── auth.ts                # ⏳ Authentication state
│
├── plugins/                   # 🔌 NUXT PLUGINS
│   └── firebase.client.ts     # ⏳ Firebase init
│
├── types/                     # 📋 TYPESCRIPT TYPES
│   └── index.ts               # ⏳ App-specific types
│
├── utils/                     # 🛠️ PURE UTILITIES
│   └── ... ⏳
│
└── assets/css/
    └── main.css               # Tailwind + component classes
```

---

## 🎛️ CONFIGURATION SYSTEM

### Site Identity (`/config/site.config.ts`)

```typescript
export const siteConfig = {
  name: 'OpenEconomy',
  tagline: 'Fair Exchange. For Everyone.',
  description: '...',
  url: 'https://openeconomy.trade',
  
  social: { twitter: '@openeconomy', github: 'openeconomy' },
  
  features: {
    darkMode: true,
    i18n: false,
    analytics: false,
  },
}
```

**Usage:**
```vue
<script setup>
import { siteConfig } from '~/config/site.config'
</script>
<template>
  <h1>{{ siteConfig.name }}</h1>
</template>
```

### Navigation (`/config/nav.config.ts`)

```typescript
export const mainNav: NavItem[] = [
  { label: 'Home', to: '/', icon: 'ph:house' },
  { label: 'Dashboard', to: '/dashboard', requiresAuth: true },
]

export const dashboardNav: NavItem[] = [...]
export const footerNav = { product: [...], company: [...], legal: [...] }
```

### 🆕 Personality Config (`/config/personality.config.ts`) - TO BUILD

```typescript
// Animation & transition presets
export type PersonalityPreset = 'calm' | 'energetic' | 'minimal' | 'playful'

export const personalityConfig = {
  preset: 'calm' as PersonalityPreset,
  
  // Or granular control:
  transitions: {
    page: 'fade',        // 'fade' | 'slide' | 'scale' | 'none'
    duration: 200,       // ms
    easing: 'ease-out',  // CSS easing
  },
  
  animations: {
    scroll: 'fade-up',   // 'fade' | 'fade-up' | 'scale' | 'none'
    stagger: 100,        // ms between children
    duration: 400,       // ms
  },
  
  interactions: {
    hover: 'lift',       // 'lift' | 'glow' | 'scale' | 'none'
    click: 'press',      // 'press' | 'ripple' | 'none'
  },
}

// Presets expand to full config:
const PRESETS = {
  calm: { transitions: { duration: 300 }, animations: { duration: 500, stagger: 150 } },
  energetic: { transitions: { duration: 150 }, animations: { duration: 250, stagger: 50 } },
  minimal: { transitions: { duration: 100 }, animations: { scroll: 'none' } },
  playful: { transitions: { page: 'scale' }, interactions: { click: 'ripple' } },
}
```

---

## 🧱 COMPONENT ARCHITECTURE

### Component Prefixes (Auto-imported)

| Prefix | Location | Purpose | Example |
|--------|----------|---------|---------|
| `U` | `/components/ui/` | Base UI primitives | `<UButton>` |
| `Layout` | `/components/layout/` | Spacing/grid wrappers | `<LayoutStack>` |
| `Motion` | `/components/motion/` | Animation wrappers | `<MotionFadeIn>` |
| `Form` | `/components/forms/` | Form inputs | `<FormSelect>` |
| None | `/components/[domain]/` | Domain-specific | `<ExchangeCard>` |

### Creating a New UI Component

**Location:** `/components/ui/UComponentName.vue`

**Template:**
```vue
<script setup lang="ts">
/**
 * UComponentName - Brief description
 * @example <UComponentName variant="primary" />
 */

interface Props {
  variant?: 'primary' | 'secondary'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
  disabled: false,
})

const emit = defineEmits<{
  click: [event: MouseEvent]
}>()

// Variant classes map
const variantClasses = {
  primary: 'bg-brand-500 text-white',
  secondary: 'bg-slate-100 text-slate-900',
}

// Size classes map
const sizeClasses = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-sm',
  lg: 'px-6 py-3 text-base',
}

const classes = computed(() => [
  variantClasses[props.variant],
  sizeClasses[props.size],
  props.disabled && 'opacity-50 cursor-not-allowed',
])
</script>

<template>
  <div :class="classes">
    <slot />
  </div>
</template>
```

**Rules:**
1. Always use TypeScript with strict props interface
2. Always provide sensible defaults via `withDefaults`
3. Use class maps for variants/sizes (predictable, tree-shakeable)
4. Emit events with typed payloads
5. Document with JSDoc comment

### Creating a Domain Component

**Location:** `/components/[domain]/ComponentName.vue`

```vue
<script setup lang="ts">
/**
 * ExchangeCard - Displays exchange summary
 * Domain: Exchange
 */
import type { Exchange } from '~/types'

interface Props {
  exchange: Exchange
  showActions?: boolean
}

const props = defineProps<Props>()
</script>

<template>
  <UCard hover>
    <div class="flex items-center gap-4">
      <UAvatar :name="exchange.providerDisplayName" />
      <div>
        <h3>{{ exchange.providerSkill.name }}</h3>
        <p>{{ exchange.providerValue }} value</p>
      </div>
    </div>
    <template v-if="showActions" #footer>
      <UButton size="sm">View Details</UButton>
    </template>
  </UCard>
</template>
```

**Rules:**
1. Import types from `~/types`
2. Compose from UI primitives (`UCard`, `UButton`, etc.)
3. Keep business logic in composables/stores
4. Name folder after domain: `exchange/`, `participant/`, `community/`

---

## 📄 PAGE ARCHITECTURE

### Adding a New Page

**Location:** `/pages/[route].vue` or `/pages/[folder]/[route].vue`

**Basic Page Template:**
```vue
<script setup lang="ts">
/**
 * Page: /route-name
 * Description of what this page does
 */

// SEO
useHead({
  title: 'Page Title',
  meta: [{ name: 'description', content: '...' }],
})

// Optional: require auth
// definePageMeta({ middleware: 'auth' })

// Optional: use different layout
// definePageMeta({ layout: 'dashboard' })
</script>

<template>
  <div>
    <!-- Hero/Header Section -->
    <section class="py-16 lg:py-24">
      <LayoutContainer>
        <MotionFadeIn>
          <h1>Page Title</h1>
        </MotionFadeIn>
      </LayoutContainer>
    </section>

    <!-- Content Sections -->
    <section class="py-16">
      <LayoutContainer>
        <LayoutGrid cols="3" gap="lg">
          <!-- Grid items -->
        </LayoutGrid>
      </LayoutContainer>
    </section>
  </div>
</template>
```

### Page Meta Options

```typescript
definePageMeta({
  layout: 'dashboard',           // Use dashboard layout
  middleware: ['auth'],          // Require authentication
  pageTransition: { name: 'slide' }, // Override transition
})
```

### Route Structure

```
/pages
├── index.vue                    → /
├── about.vue                    → /about
├── auth/
│   ├── login.vue               → /auth/login
│   ├── register.vue            → /auth/register
│   └── forgot-password.vue     → /auth/forgot-password
├── dashboard/
│   ├── index.vue               → /dashboard
│   ├── exchanges/
│   │   ├── index.vue           → /dashboard/exchanges
│   │   └── [id].vue            → /dashboard/exchanges/:id
│   └── profile.vue             → /dashboard/profile
└── discover/
    ├── index.vue               → /discover
    └── [id].vue                → /discover/:id (participant profile)
```

---

## 🔧 COMPOSABLES REFERENCE

### Available Composables

| Composable | Purpose | Returns |
|------------|---------|---------|
| `useToast()` | Show notifications | `{ toast, dismiss, dismissAll }` |
| `useModal()` | Manage modals | `{ isOpen, open, close, closeAll }` |
| `useBreakpoint()` | Responsive detection | `{ isMobile, isTablet, isDesktop, current }` |
| `useClickOutside(ref, callback)` | Detect outside clicks | void |
| `useScrollAnimation(ref, options)` | Scroll-triggered visibility | `{ isVisible, hasAnimated }` |

### Usage Examples

```typescript
// Toast
const { toast } = useToast()
toast.success('Saved!')
toast.error('Failed to save')

// Modal
const { open, close } = useModal()
open('confirm-dialog')
close()

// Breakpoint
const { isMobile, current } = useBreakpoint()
if (isMobile.value) { /* mobile logic */ }

// Scroll Animation (used by Motion components)
const el = ref(null)
const { isVisible } = useScrollAnimation(el, { threshold: 0.2 })
```

### Creating a New Composable

**Location:** `/composables/useFeatureName.ts`

```typescript
/**
 * useFeatureName - Brief description
 * @example const { data, loading } = useFeatureName()
 */

export function useFeatureName(options?: FeatureOptions) {
  // Reactive state
  const data = ref<DataType | null>(null)
  const loading = ref(false)
  const error = ref<Error | null>(null)

  // Computed
  const hasData = computed(() => !!data.value)

  // Methods
  async function fetch() {
    loading.value = true
    try {
      data.value = await api.getData()
    } catch (e) {
      error.value = e as Error
    } finally {
      loading.value = false
    }
  }

  // Lifecycle (if needed)
  onMounted(() => {
    if (options?.autoFetch) fetch()
  })

  return {
    data: readonly(data),
    loading: readonly(loading),
    error: readonly(error),
    hasData,
    fetch,
  }
}
```

---

## 🗄️ STATE MANAGEMENT

### Store Structure

| Store | Purpose | Key State |
|-------|---------|-----------|
| `useToastStore` | Toast queue | `toasts[]`, `add()`, `dismiss()` |
| `useUIStore` | UI state | `isDark`, `sidebarOpen`, `mobileMenuOpen` |
| `useAuthStore` | ⏳ Auth state | `user`, `isAuthenticated`, `login()` |

### Creating a New Store

**Location:** `/stores/featureName.ts`

```typescript
/**
 * Feature Store - Brief description
 */
import { defineStore } from 'pinia'

export const useFeatureStore = defineStore('feature', () => {
  // State
  const items = ref<Item[]>([])
  const loading = ref(false)

  // Getters (computed)
  const itemCount = computed(() => items.value.length)
  const isEmpty = computed(() => items.value.length === 0)

  // Actions
  async function fetchItems() {
    loading.value = true
    try {
      items.value = await api.getItems()
    } finally {
      loading.value = false
    }
  }

  function addItem(item: Item) {
    items.value.push(item)
  }

  // Return public API
  return {
    items: readonly(items),
    loading: readonly(loading),
    itemCount,
    isEmpty,
    fetchItems,
    addItem,
  }
})
```

---

## 🎨 STYLING SYSTEM

### Design Tokens (Tailwind)

**Spacing:** Uses Tailwind defaults (4px base)
```
gap-1 = 4px   | gap-2 = 8px   | gap-3 = 12px
gap-4 = 16px  | gap-6 = 24px  | gap-8 = 32px
```

**Colors:**
```
brand-500    = Primary green (#22c55e)
slate-900    = Dark text/bg
slate-50     = Light bg
```

**Border Radius:**
```
rounded-lg   = 8px  (buttons, inputs)
rounded-xl   = 12px (cards)
rounded-2xl  = 16px (modals, hero cards)
rounded-full = Pills, avatars
```

### Component Classes (`/assets/css/main.css`)

Pre-defined classes for consistency:

```css
/* Buttons */
.btn              /* Base button styles */
.btn-primary      /* Brand colored */
.btn-secondary    /* Neutral */
.btn-ghost        /* Transparent */
.btn-danger       /* Red/destructive */

/* Inputs */
.input            /* Base input */
.input-error      /* Error state */

/* Cards */
.card             /* Base card */
.card-hover       /* With hover effect */

/* Badges */
.badge            /* Base badge */
.badge-brand      /* Green */
.badge-gray       /* Neutral */
```

### Adding Custom Utilities

**In `main.css`:**
```css
@layer utilities {
  .your-utility {
    @apply ...;
  }
}
```

**In `tailwind.config.ts`:**
```typescript
extend: {
  animation: {
    'your-animation': 'yourKeyframes 0.3s ease-out',
  },
  keyframes: {
    yourKeyframes: { ... },
  },
}
```

---

## 🎬 MOTION SYSTEM

### Available Motion Components

| Component | Effect | Props |
|-----------|--------|-------|
| `<MotionFadeIn>` | Fade + slide up on scroll | `delay`, `duration`, `threshold` |
| `<MotionStagger>` | Stagger children | `staggerDelay`, `duration` |

### Usage

```vue
<!-- Single element fade in -->
<MotionFadeIn :delay="200">
  <h1>Fades in on scroll</h1>
</MotionFadeIn>

<!-- Staggered children -->
<MotionStagger :stagger-delay="100">
  <template #default="{ isVisible, getStaggerStyle }">
    <div
      v-for="(item, i) in items"
      :style="getStaggerStyle(i)"
      :class="isVisible ? 'opacity-100' : 'opacity-0'"
    >
      {{ item }}
    </div>
  </template>
</MotionStagger>
```

### Page Transitions

Configured in `nuxt.config.ts`:
```typescript
app: {
  pageTransition: { name: 'page', mode: 'out-in' },
  layoutTransition: { name: 'layout', mode: 'out-in' },
}
```

CSS in `main.css`:
```css
.page-enter-from { opacity: 0; transform: translateY(8px); }
.page-leave-to { opacity: 0; transform: translateY(-8px); }
```

---

## 📐 LAYOUT PRIMITIVES (TO BUILD)

### Planned Components

```vue
<!-- Container: Max-width centered wrapper -->
<LayoutContainer size="lg">  <!-- sm | md | lg | xl | full -->
  Content with max-width and padding
</LayoutContainer>

<!-- Stack: Vertical spacing -->
<LayoutStack gap="md">  <!-- xs | sm | md | lg | xl -->
  <div>Item 1</div>
  <div>Item 2</div>
</LayoutStack>

<!-- Cluster: Horizontal flex with wrapping -->
<LayoutCluster gap="sm" justify="between">
  <UButton>One</UButton>
  <UButton>Two</UButton>
</LayoutCluster>

<!-- Grid: Responsive CSS grid -->
<LayoutGrid cols="3" gap="lg">  <!-- cols: 1-12 or object { sm: 1, md: 2, lg: 3 } -->
  <UCard v-for="i in 6" />
</LayoutGrid>
```

---

## ✅ CONVENTIONS CHECKLIST

### When Creating Components
- [ ] Use TypeScript with strict props interface
- [ ] Add JSDoc comment with description + example
- [ ] Use `withDefaults` for prop defaults
- [ ] Use class maps for variants (not ternaries)
- [ ] Emit events with typed payloads
- [ ] Place in correct directory with correct prefix

### When Creating Pages
- [ ] Set `useHead()` with title + description
- [ ] Use `definePageMeta()` for layout/middleware
- [ ] Wrap content in `<LayoutContainer>`
- [ ] Use Motion components for animations
- [ ] Follow section pattern: `<section class="py-16">`

### When Creating Composables
- [ ] Name starts with `use`
- [ ] Return reactive state as `readonly()`
- [ ] Export single function from file
- [ ] Handle loading/error states

### When Creating Stores
- [ ] Use composition API syntax (`defineStore('name', () => {})`)
- [ ] Expose readonly state, mutable actions
- [ ] Name file and store consistently

---

## 🚀 NEXT IMPLEMENTATION PRIORITIES

### Phase 1: Layout Foundation
1. [ ] Create `/config/personality.config.ts`
2. [ ] Build `LayoutContainer.vue`
3. [ ] Build `LayoutStack.vue`
4. [ ] Build `LayoutGrid.vue`
5. [ ] Build `LayoutCluster.vue`

### Phase 2: Form Components
1. [ ] `UTextarea.vue`
2. [ ] `USelect.vue`
3. [ ] `UCheckbox.vue`
4. [ ] `URadio.vue`
5. [ ] `USwitch.vue`
6. [ ] `FormField.vue` (label + input + error wrapper)

### Phase 3: Data & Feedback
1. [ ] `UAlert.vue`
2. [ ] `USkeleton.vue`
3. [ ] `UProgress.vue`
4. [ ] `UEmpty.vue`
5. [ ] `USpinner.vue`

### Phase 4: Navigation
1. [ ] `UTabs.vue`
2. [ ] `UDropdown.vue`
3. [ ] `UBreadcrumb.vue`
4. [ ] Dashboard sidebar

### Phase 5: Firebase + Auth
1. [ ] Firebase plugin
2. [ ] Auth store
3. [ ] Auth middleware
4. [ ] Login/Register pages

---

## 🔗 QUICK REFERENCE

### File Locations

| Need | Location |
|------|----------|
| Change site name/branding | `/config/site.config.ts` |
| Add nav item | `/config/nav.config.ts` |
| Change colors | `tailwind.config.ts` → `colors` |
| Add animation | `tailwind.config.ts` → `animation` |
| Add component class | `/assets/css/main.css` |
| Add page | `/pages/[route].vue` |
| Add UI component | `/components/ui/UName.vue` |
| Add composable | `/composables/useName.ts` |
| Add store | `/stores/name.ts` |

### Commands

```bash
pnpm dev          # Start dev server
pnpm build        # Production build
pnpm generate     # Static generation
pnpm typecheck    # Run type checking
```

---

*"One codebase. Config-driven personality. Infinite possibilities."*
