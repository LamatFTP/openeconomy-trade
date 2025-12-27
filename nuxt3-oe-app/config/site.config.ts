/**
 * Site Configuration
 * Central config for branding, meta, social links
 */

export const siteConfig = {
  // Branding
  name: 'OpenEconomy',
  shortName: 'OE',
  tagline: 'Fair Exchange. For Everyone.',
  description: 'A decentralized time-value exchange protocol where everyone\'s time has worth.',

  // URLs
  url: 'https://openeconomy.trade',
  github: 'https://github.com/openeconomy/trade',
  discord: '#', // Coming soon

  // Contact
  email: 'hello@openeconomy.trade',

  // Social
  social: {
    twitter: '@openeconomy',
    github: 'openeconomy',
  },

  // SEO
  keywords: [
    'time bank',
    'skill exchange',
    'fair trade',
    'community exchange',
    'decentralized',
    'barter',
  ],

  // Theme
  theme: {
    primaryColor: '#22c55e', // brand-500
    backgroundColor: '#0f172a', // slate-900
  },

  // Features flags
  features: {
    darkMode: true,
    i18n: false, // Phase 4
    analytics: false, // Enable in production
  },
} as const

export type SiteConfig = typeof siteConfig
