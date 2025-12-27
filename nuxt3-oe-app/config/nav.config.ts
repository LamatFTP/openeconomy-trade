/**
 * Navigation Configuration
 * Config-driven navigation structure
 */

export interface NavItem {
  label: string
  to?: string
  href?: string
  icon?: string
  children?: NavItem[]
  requiresAuth?: boolean
  badge?: string
}

export const mainNav: NavItem[] = [
  {
    label: 'Home',
    to: '/',
    icon: 'ph:house',
  },
  {
    label: 'How It Works',
    to: '/how-it-works',
    icon: 'ph:lightbulb',
  },
  {
    label: 'Participate',
    to: '/participate',
    icon: 'ph:users-three',
  },
  {
    label: 'Contribute',
    to: '/contribute',
    icon: 'ph:hand-heart',
  },
  {
    label: 'Community',
    to: '/community',
    icon: 'ph:chat-circle-dots',
  },
  {
    label: 'Discover',
    to: '/discover',
    icon: 'ph:compass',
    requiresAuth: true,
  },
  {
    label: 'Dashboard',
    to: '/dashboard',
    icon: 'ph:squares-four',
    requiresAuth: true,
  },
]

export const authNav: NavItem[] = [
  {
    label: 'Sign In',
    to: '/auth/login',
  },
  {
    label: 'Get Started',
    to: '/auth/register',
  },
]

export const dashboardNav: NavItem[] = [
  {
    label: 'Overview',
    to: '/dashboard',
    icon: 'ph:squares-four',
  },
  {
    label: 'Exchanges',
    to: '/dashboard/exchanges',
    icon: 'ph:arrows-left-right',
  },
  {
    label: 'Messages',
    to: '/dashboard/messages',
    icon: 'ph:chat-circle',
    badge: 'NEW',
  },
  {
    label: 'Balance',
    to: '/dashboard/balance',
    icon: 'ph:wallet',
  },
  {
    label: 'Profile',
    to: '/dashboard/profile',
    icon: 'ph:user-circle',
  },
  {
    label: 'Settings',
    to: '/dashboard/settings',
    icon: 'ph:gear',
  },
]

export const footerNav = {
  product: [
    { label: 'How It Works', to: '/how-it-works' },
    { label: 'Participate', to: '/participate' },
    { label: 'FAQ', to: '/faq' },
  ],
  company: [
    { label: 'About', to: '/about' },
    { label: 'Contribute', to: '/contribute' },
    { label: 'Community', to: '/community' },
  ],
  resources: [
    { label: 'Documentation', href: 'https://docs.openeconomy.trade' },
    { label: 'GitHub', href: 'https://github.com/openeconomy' },
    { label: 'Discord', href: '#' },
  ],
  legal: [
    { label: 'Privacy', to: '/privacy' },
    { label: 'Terms', to: '/terms' },
    { label: 'Cookies', to: '/cookies' },
  ],
}
