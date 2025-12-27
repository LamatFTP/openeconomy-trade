/**
 * Content Types - Shared types for page content and data fetching
 */

// CTA Button
export interface CTAButton {
  label: string;
  to: string;
  variant?: "primary" | "secondary" | "ghost" | "outline";
  icon?: string;
}

// Page Meta
export interface PageMeta {
  title: string;
  description: string;
  ogImage?: string;
  keywords?: string[];
}

// Hero Section
export interface HeroContent {
  badge?: string;
  headline: string;
  subheadline: string;
  primaryCta?: CTAButton;
  secondaryCta?: CTAButton;
  socialProof?: string;
  visual?: {
    type: "exchange" | "image" | "illustration";
    data?: Record<string, unknown>;
  };
}

// Section Header
export interface SectionHeader {
  badge?: string;
  headline: string;
  subheadline?: string;
}

// Feature/Principle Card
export interface FeatureItem {
  icon: string;
  title: string;
  description: string;
}

// Persona/Story Card
export interface PersonaItem {
  icon?: string;
  avatar?: string;
  name: string;
  role: string;
  quote: string;
  skills?: string[];
  problem?: string;
  location?: string;
  exchanges?: number;
}

// Step Card
export interface StepItem {
  number: string | number;
  title: string;
  subtitle?: string;
  description: string;
  content?: string;
  icon?: string;
}

// Stat Item
export interface StatItem {
  value: string | number;
  label: string;
  suffix?: string;
  prefix?: string;
}

// FAQ Item
export interface FAQItem {
  question: string;
  answer: string;
  category?: string;
}

// Tier/Level Card
export interface TierItem {
  icon: string;
  name: string;
  requirements: string;
  privileges: string[];
}

// Category Card
export interface CategoryItem {
  icon: string;
  name: string;
  examples: string[];
  count?: number;
}

// Event Card
export interface EventItem {
  type: string;
  title: string;
  date: string;
  time?: string;
  location: string;
  description: string;
  link?: string;
}

// Contributor/Team Card
export interface ContributorItem {
  avatar?: string;
  name: string;
  role: string;
  bio?: string;
  links?: {
    github?: string;
    twitter?: string;
    linkedin?: string;
  };
}

// Comparison Table
export interface ComparisonRow {
  feature: string;
  them: string;
  us: string;
}

// Timeline Item
export interface TimelineItem {
  date: string;
  title: string;
  description?: string;
}

// Path/Option Card
export interface PathItem {
  icon: string;
  title: string;
  subtitle: string;
  description?: string;
  cta?: CTAButton;
  features?: string[];
}

// Generic Section
export interface ContentSection {
  id: string;
  type: string;
  header?: SectionHeader;
  items?: unknown[];
  content?: string;
  cta?: CTAButton;
  rows?: ComparisonRow[];
  stats?: StatItem[];
}

// CTA Section
export interface CTASectionContent {
  headline: string;
  subheadline?: string;
  primaryCta: CTAButton;
  secondaryCta?: CTAButton;
  gradient?: boolean;
}

// Full Page Content
export interface PageContent {
  slug: string;
  meta: PageMeta;
  hero: HeroContent;
  sections: ContentSection[];
  cta?: CTASectionContent;
}

// Loading State
export interface ContentState<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
}

// Fetch Options
export interface FetchOptions {
  immediate?: boolean;
  watch?: boolean;
  transform?: (data: unknown) => unknown;
}
