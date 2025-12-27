// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },

  modules: ["@nuxtjs/tailwindcss", "@pinia/nuxt"],

  // App Configuration
  app: {
    head: {
      title: "OpenEconomy",
      titleTemplate: "%s | OpenEconomy",
      meta: [
        { charset: "utf-8" },
        { name: "viewport", content: "width=device-width, initial-scale=1" },
        {
          name: "description",
          content: "Fair Exchange Protocol - Built for humanity",
        },
        { name: "theme-color", content: "#0f172a" },
      ],
      link: [{ rel: "icon", type: "image/svg+xml", href: "/favicon.svg" }],
    },
    pageTransition: { name: "page", mode: "out-in" },
    layoutTransition: { name: "layout", mode: "out-in" },
  },

  // Runtime Config
  runtimeConfig: {
    public: {
      firebase: {
        apiKey: process.env.NUXT_PUBLIC_FIREBASE_API_KEY || "",
        authDomain: process.env.NUXT_PUBLIC_FIREBASE_AUTH_DOMAIN || "",
        projectId: process.env.NUXT_PUBLIC_FIREBASE_PROJECT_ID || "",
        storageBucket: process.env.NUXT_PUBLIC_FIREBASE_STORAGE_BUCKET || "",
        messagingSenderId:
          process.env.NUXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID || "",
        appId: process.env.NUXT_PUBLIC_FIREBASE_APP_ID || "",
      },
      siteUrl: process.env.NUXT_PUBLIC_SITE_URL || "http://localhost:3000",
    },
  },

  // TypeScript
  typescript: {
    strict: true,
    typeCheck: false,
  },

  // Tailwind
  tailwindcss: {
    cssPath: "~/assets/css/main.css",
  },

  // Auto-imports
  imports: {
    dirs: ["composables/**", "utils/**", "stores/**"],
  },

  // Components
  components: [
    { path: "~/components/ui", prefix: "U" },
    { path: "~/components/layout", prefix: "Layout" },
    { path: "~/components/motion", prefix: "Motion" },
    { path: "~/components/forms", prefix: "Form" },
    { path: "~/components/feedback", prefix: "Feedback" },
    { path: "~/components/sections", prefix: "Sections" },
    { path: "~/components/cards", prefix: "Cards" },
    { path: "~/components/landing", prefix: "Landing" },
    "~/components",
  ],

  // Pinia
  pinia: {
    storesDirs: ["./stores/**"],
  },

  // PostCSS
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },

  // Vite optimizations
  vite: {
    vue: {
      script: {
        defineModel: true,
        propsDestructure: true,
      },
    },
  },

  // Nitro
  nitro: {
    preset: "vercel",
  },

  compatibilityDate: "2024-01-01",
});
