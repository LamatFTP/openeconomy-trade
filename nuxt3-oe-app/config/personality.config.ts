/**
 * Personality Config - Animation & transition presets
 * Controls the site-wide motion personality
 */

// Types
export type PersonalityPreset = "calm" | "energetic" | "minimal" | "playful";

export type PageTransition = "fade" | "slide" | "scale" | "none";
export type ScrollAnimation = "fade" | "fade-up" | "scale" | "none";
export type HoverEffect = "lift" | "glow" | "scale" | "none";
export type ClickEffect = "press" | "ripple" | "none";

export interface TransitionConfig {
  page: PageTransition;
  duration: number;
  easing: string;
}

export interface AnimationConfig {
  scroll: ScrollAnimation;
  stagger: number;
  duration: number;
}

export interface InteractionConfig {
  hover: HoverEffect;
  click: ClickEffect;
}

export interface PersonalityConfig {
  preset: PersonalityPreset;
  transitions: TransitionConfig;
  animations: AnimationConfig;
  interactions: InteractionConfig;
}

// Preset definitions
export const PERSONALITY_PRESETS: Record<
  PersonalityPreset,
  Omit<PersonalityConfig, "preset">
> = {
  calm: {
    transitions: { page: "fade", duration: 300, easing: "ease-out" },
    animations: { scroll: "fade-up", stagger: 150, duration: 500 },
    interactions: { hover: "lift", click: "press" },
  },
  energetic: {
    transitions: { page: "slide", duration: 150, easing: "ease-out" },
    animations: { scroll: "fade-up", stagger: 50, duration: 250 },
    interactions: { hover: "scale", click: "ripple" },
  },
  minimal: {
    transitions: { page: "fade", duration: 100, easing: "linear" },
    animations: { scroll: "none", stagger: 0, duration: 0 },
    interactions: { hover: "none", click: "none" },
  },
  playful: {
    transitions: {
      page: "scale",
      duration: 250,
      easing: "cubic-bezier(0.34, 1.56, 0.64, 1)",
    },
    animations: { scroll: "scale", stagger: 100, duration: 400 },
    interactions: { hover: "scale", click: "ripple" },
  },
};

// Current personality config
export const personalityConfig: PersonalityConfig = {
  preset: "calm",
  transitions: { page: "fade", duration: 200, easing: "ease-out" },
  animations: { scroll: "fade-up", stagger: 100, duration: 400 },
  interactions: { hover: "lift", click: "press" },
};

/**
 * Get merged personality values (preset + overrides)
 * @param preset - Optional preset to use instead of config preset
 */
export function getPersonalityValues(
  preset?: PersonalityPreset
): Omit<PersonalityConfig, "preset"> {
  const basePreset = PERSONALITY_PRESETS[preset || personalityConfig.preset];

  // If using the config preset, merge with any custom overrides
  if (!preset || preset === personalityConfig.preset) {
    return {
      transitions: {
        ...basePreset.transitions,
        ...personalityConfig.transitions,
      },
      animations: { ...basePreset.animations, ...personalityConfig.animations },
      interactions: {
        ...basePreset.interactions,
        ...personalityConfig.interactions,
      },
    };
  }

  return basePreset;
}

/**
 * Get CSS transition string from config
 */
export function getTransitionCSS(): string {
  const { duration, easing } = personalityConfig.transitions;
  return `all ${duration}ms ${easing}`;
}

/**
 * Get animation delay for staggered children
 */
export function getStaggerDelay(index: number): number {
  return index * personalityConfig.animations.stagger;
}
