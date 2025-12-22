# Community Structure & Participation Protocol

> How humans organize. How trust grows. How fairness scales.

---

## Core Philosophy

```
Traditional platforms: Extract value from community
OpenEconomy: Community IS the value

We don't build communities. We provide tools for communities to build themselves.
```

---

## Community Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    GLOBAL NETWORK                           │
│         All participants, shared protocol, open access      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Community  │  │  Community  │  │  Community  │  ...    │
│  │  "Brooklyn" │  │  "TechShare"│  │  "Familia"  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
├─────────────────────────────────────────────────────────────┤
│  ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐        │
│  │ Alice │ │  Bob  │ │ Carol │ │  Dev  │ │  Eve  │  ...   │
│  └───────┘ └───────┘ └───────┘ └───────┘ └───────┘        │
│                    PARTICIPANTS                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 1. Participant Journey

### 1.1 Onboarding Path

```
STAGE 0: Discovery
├── Hears about OpenEconomy
├── Visits landing page
├── Understands the concept
└── Decides to join

STAGE 1: Registration (Day 0)
├── Create account (email OR wallet)
├── Set display name
├── Self-assess hourly value
│   └── Guidance provided, not enforced
├── Add at least 1 skill
├── Add at least 1 need (what you're looking for)
└── STATUS: "Newcomer" 🌱

STAGE 2: First Exchange (Day 1-30)
├── Browse community
├── Find a match
├── Complete first exchange
├── Receive first rating
└── STATUS: "Active" ⚡

STAGE 3: Trusted Member (After 5+ exchanges)
├── Consistent completion
├── Positive ratings (4.0+ avg)
├── No disputes
└── STATUS: "Trusted" ✓

STAGE 4: Community Pillar (After 20+ exchanges)
├── High volume participation
├── Excellent ratings (4.5+ avg)
├── Eligible for moderation roles
└── STATUS: "Verified" ⭐

STAGE 5: Champion (After 50+ exchanges)
├── Exceptional track record (4.8+ avg)
├── Community leadership
├── Protocol governance rights
└── STATUS: "Champion" 👑
```

### 1.2 Trust Tiers

```typescript
interface TrustTier {
  tier: 'newcomer' | 'active' | 'trusted' | 'verified' | 'champion'
  requirements: {
    minExchanges: number
    minRating: number
    maxDisputeRate: number
    minAccountAge: number  // days
  }
  privileges: string[]
}

const TRUST_TIERS: TrustTier[] = [
  {
    tier: 'newcomer',
    requirements: {
      minExchanges: 0,
      minRating: 0,
      maxDisputeRate: 1.0,
      minAccountAge: 0
    },
    privileges: [
      'Create profile',
      'Browse participants',
      'Propose exchanges (max 3 pending)',
      'Join public communities'
    ]
  },
  {
    tier: 'active',
    requirements: {
      minExchanges: 1,
      minRating: 0,
      maxDisputeRate: 0.5,
      minAccountAge: 0
    },
    privileges: [
      'All newcomer privileges',
      'Propose exchanges (max 10 pending)',
      'Leave reviews',
      'Endorse skills'
    ]
  },
  {
    tier: 'trusted',
    requirements: {
      minExchanges: 5,
      minRating: 4.0,
      maxDisputeRate: 0.2,
      minAccountAge: 14
    },
    privileges: [
      'All active privileges',
      'Create communities',
      'Unlimited pending exchanges',
      'Priority in matching',
      'Trusted badge visible'
    ]
  },
  {
    tier: 'verified',
    requirements: {
      minExchanges: 20,
      minRating: 4.5,
      maxDisputeRate: 0.1,
      minAccountAge: 30
    },
    privileges: [
      'All trusted privileges',
      'Community moderation eligible',
      'Dispute mediation eligible',
      'Featured in discovery',
      'Verified badge visible'
    ]
  },
  {
    tier: 'champion',
    requirements: {
      minExchanges: 50,
      minRating: 4.8,
      maxDisputeRate: 0.05,
      minAccountAge: 90
    },
    privileges: [
      'All verified privileges',
      'Protocol governance voting',
      'Community ambassador role',
      'Can vouch for newcomers',
      'Champion badge visible'
    ]
  }
]
```

---

## 2. Community Structure

### 2.1 Community Types

```typescript
type CommunityType = 
  | 'geographic'    // Brooklyn Skill Share, Mumbai Exchange
  | 'professional'  // Tech Workers, Healthcare Pros
  | 'interest'      // Sustainable Living, Parents Network
  | 'organization'  // Company X Internal, University Y
  | 'cause'         // Mutual Aid, Refugee Support

interface Community {
  id: string
  name: string
  type: CommunityType
  description: string
  
  // Access
  visibility: 'public' | 'unlisted' | 'private'
  joinPolicy: 'open' | 'approval' | 'invite_only'
  
  // Governance
  governance: GovernanceModel
  
  // Members
  members: CommunityMember[]
  memberCount: number
  
  // Settings
  settings: CommunitySettings
  
  // Metadata
  createdAt: Timestamp
  createdBy: string
}
```

### 2.2 Community Roles

```typescript
type CommunityRole = 
  | 'member'      // Regular participant
  | 'moderator'   // Can approve members, handle minor disputes
  | 'admin'       // Full community management
  | 'founder'     // Created the community, can transfer ownership

interface CommunityMember {
  participantId: string
  role: CommunityRole
  joinedAt: Timestamp
  invitedBy?: string
  exchangesInCommunity: number
  standing: 'good' | 'warning' | 'suspended'
}

const ROLE_PERMISSIONS = {
  member: [
    'view_members',
    'participate_exchanges',
    'post_in_community',
    'leave_community'
  ],
  moderator: [
    '...member',
    'approve_join_requests',
    'warn_members',
    'mute_members_24h',
    'flag_for_admin'
  ],
  admin: [
    '...moderator',
    'update_settings',
    'suspend_members',
    'remove_members',
    'appoint_moderators',
    'manage_disputes'
  ],
  founder: [
    '...admin',
    'delete_community',
    'transfer_ownership',
    'appoint_admins'
  ]
}
```

### 2.3 Community Governance Models

```typescript
type GovernanceModel = 
  | 'founder_led'      // Founder makes decisions
  | 'admin_council'    // Admins vote (majority)
  | 'democratic'       // All members vote
  | 'consensus'        // Requires high agreement (80%+)
  | 'delegated'        // Members delegate to representatives

interface GovernanceConfig {
  model: GovernanceModel
  
  // For voting models
  votingPeriod?: number          // Hours
  quorumPercentage?: number      // Min participation
  approvalThreshold?: number     // % needed to pass
  
  // Proposal rights
  whoCanPropose: CommunityRole[]
  whoCanVote: CommunityRole[]
  
  // Scope
  decisionsRequiringVote: DecisionType[]
}

type DecisionType =
  | 'settings_change'
  | 'member_removal'
  | 'role_change'
  | 'community_merge'
  | 'policy_change'
```

---

## 3. Participation Protocol

### 3.1 Exchange Rules

```yaml
PROPOSAL:
  - Anyone can propose to anyone
  - Clear description required
  - Estimated hours required
  - Value auto-calculated from provider's baseline
  - Receiver has 7 days to respond (configurable)
  - No response = auto-decline

ACCEPTANCE:
  - Receiver can accept, counter, or decline
  - Counter-proposals unlimited until agreement
  - Once accepted, both parties committed
  - Backing out without completion affects reputation

COMPLETION:
  - Provider marks "completed" when done
  - Receiver confirms within 48 hours
  - No confirmation = auto-confirm (with notice)
  - Both parties rate each other (1-5 stars)
  - Ratings are permanent and public

CANCELLATION:
  - Either party can cancel before completion
  - Early cancellation (before work starts): No penalty
  - Late cancellation (work started): Reputation impact
  - Reason required, visible to both parties
```

### 3.2 Value Protocol

```yaml
SELF-ASSESSMENT:
  - Participants set their own hourly value
  - No minimum (but UI suggests $5+ for usability)
  - No maximum (but UI warns above $500)
  - Can change anytime
  - Changes apply to new exchanges only

GUIDANCE (not enforcement):
  - "Similar skills in your area average $X-Y/hour"
  - "Your value seems [low/high] compared to peers"
  - Educational, not prescriptive

ENDORSEMENTS:
  - Other participants can endorse your value
  - "I confirm this person's work is worth their rate"
  - Requires completed exchange first
  - Visible on profile as social proof

VALUE DISPUTES:
  - If receiver thinks value too high for quality: 
    → Rate accordingly (1-5 stars)
    → Leave honest review
    → Community sees the feedback
  - Market self-corrects through reputation
```

### 3.3 Balance Protocol

```yaml
CREDIT SYSTEM:
  - Every participant starts at 0
  - Providing service: +value
  - Receiving service: -value
  - Balance can go negative (you owe community)
  - Balance can go positive (community owes you)

NO ENFORCEMENT:
  - Negative balance is NOT debt
  - No interest, no penalties, no collection
  - Social incentive to balance over time
  - Extreme imbalance triggers soft nudges

NUDGE THRESHOLDS:
  - -$500: "Consider what you might offer back"
  - -$1000: "You've received a lot - time to give?"
  - -$2000: Visible indicator on profile
  - -$5000: May limit receiving new services

POSITIVE BALANCE:
  - +$500: "You're a generous contributor!"
  - +$1000: Recognition in community
  - +$2000: Champion track consideration
  - No upper limit, no expiration
```

---

## 4. Dispute Resolution

### 4.1 Dispute Types

```typescript
type DisputeType =
  | 'non_completion'      // Work not done
  | 'quality'             // Work done but poor quality
  | 'time_discrepancy'    // Actual hours differ from estimate
  | 'communication'       // Ghosting, unresponsive
  | 'misrepresentation'   // Skills/service not as described
  | 'behavior'            // Inappropriate conduct
  | 'other'
```

### 4.2 Resolution Process

```
LEVEL 1: Self-Resolution (48 hours)
├── Either party flags issue
├── Both parties notified
├── Direct communication encouraged
├── If resolved: Both mark resolved
└── If unresolved: Escalate to Level 2

LEVEL 2: Community Mediation (5 days)
├── Neutral mediator assigned (Verified+ tier)
├── Mediator reviews:
│   ├── Exchange details
│   ├── Communication history
│   └── Both parties' statements
├── Mediator proposes resolution
├── Both parties accept OR reject
└── If rejected: Escalate to Level 3

LEVEL 3: Council Review (7 days)
├── Panel of 3 Champions
├── Full case review
├── Binding decision made
├── Options:
│   ├── Exchange voided (no credit change)
│   ├── Partial credit adjustment
│   ├── Full credit as proposed
│   └── Participant sanctions
└── Decision is final

SANCTIONS (if warranted):
├── Warning: Visible note on profile
├── Suspension: 30-day exchange freeze
├── Removal: Banned from community
└── Protocol ban: Global (extreme cases only)
```

### 4.3 Mediator Selection

```typescript
interface MediatorCriteria {
  minTier: 'verified' | 'champion'
  minExchanges: 20
  minRating: 4.5
  noRelationship: true  // Never exchanged with either party
  sameLanguage: boolean // Can communicate with both
  available: boolean    // Opted into mediation pool
}

// Mediators earn:
// - Reputation boost per resolved dispute
// - "Mediator" badge on profile
// - Priority in matching algorithm
// - No monetary compensation (volunteer)
```

---

## 5. Community Health

### 5.1 Health Metrics

```typescript
interface CommunityHealth {
  // Activity
  activeMembers30d: number      // Exchanged in last 30 days
  exchangesPerMonth: number
  avgTimeToFirstExchange: number // Days
  
  // Quality
  avgRating: number
  completionRate: number
  disputeRate: number
  
  // Growth
  newMembersPerMonth: number
  retentionRate90d: number
  
  // Balance
  giniCoefficient: number       // Inequality measure
  avgBalance: number
  balanceDistribution: object
  
  // Engagement
  responseRate: number          // Proposals answered
  avgResponseTime: number       // Hours
}

// Health Score = weighted combination
// Displayed to members, admins can see detailed breakdown
```

### 5.2 Intervention Triggers

```yaml
LOW_ACTIVITY:
  trigger: < 5 exchanges/month for 3 months
  action: 
    - Notify admins
    - Suggest community events
    - Consider merging with similar community

HIGH_DISPUTES:
  trigger: > 10% dispute rate
  action:
    - Review common dispute causes
    - Update community guidelines
    - Consider moderator training

IMBALANCE:
  trigger: Gini > 0.6 (high inequality)
  action:
    - Highlight underutilized skills
    - Suggest matches for negative balance members
    - Community discussion on fairness

STAGNATION:
  trigger: < 10% new members / quarter
  action:
    - Outreach suggestions
    - Community ambassador program
    - Cross-community promotion
```

---

## 6. Cross-Community Protocol

### 6.1 Inter-Community Exchanges

```yaml
DEFAULT: Communities are open to cross-exchange

SETTINGS:
  allowExternalExchanges: true | false
  externalApproval: 'auto' | 'moderator' | 'admin'
  visibleToExternal: true | false

PROCESS:
  1. Alice (Community A) finds Bob (Community B)
  2. Alice proposes exchange
  3. If Bob's community requires approval:
     - Moderator reviews Alice's profile
     - Approves or denies
  4. Exchange proceeds normally
  5. Both communities' stats updated
```

### 6.2 Community Federation

```yaml
FEDERATION:
  - Communities can form alliances
  - Shared member directory
  - Cross-promotion
  - Joint events
  - Shared dispute resolution

TYPES:
  - Loose: Visibility only
  - Medium: Shared matching
  - Tight: Shared governance

EXAMPLE:
  "Bay Area Exchange Network"
  ├── Oakland Skill Share
  ├── SF Mutual Aid
  ├── Berkeley Time Bank
  └── Shared: discovery, events, reputation
```

---

## 7. Anti-Gaming Measures

### 7.1 Reputation Gaming Prevention

```yaml
SYBIL ATTACKS (fake accounts):
  - Rate limiting on registration
  - Phone/email verification optional but visible
  - Wallet connection adds trust
  - Pattern detection for suspicious activity

COLLUSION (fake exchanges):
  - Algorithm detects reciprocal-only pairs
  - Flag accounts that only exchange with each other
  - Require diverse exchange partners for tier advancement

RATING MANIPULATION:
  - Ratings only from completed exchanges
  - Can't rate same person twice in 30 days
  - Outlier detection (all 5s or all 1s)
  - Review text required for 1-2 star ratings

VALUE INFLATION:
  - Community comparison shown
  - Endorsements as social proof
  - High value + low completion = visible mismatch
```

### 7.2 Bad Actor Handling

```yaml
DETECTION:
  - High cancel rate
  - Low completion rate
  - Negative pattern in reviews
  - Multiple disputes
  - Reported by multiple participants

RESPONSE:
  - Automated warning at thresholds
  - Moderator review
  - Probation period (limited activity)
  - Suspension
  - Removal

APPEALS:
  - All actions can be appealed
  - Different reviewer than original decision
  - Transparent process
  - Reinstatement possible
```

---

## 8. Onboarding Ceremonies

### 8.1 New Participant Welcome

```yaml
AUTOMATED:
  - Welcome message with quick start guide
  - Suggested first actions
  - Highlighted active members in area
  - "First exchange" challenge

COMMUNITY-SPECIFIC:
  - Welcome post in community feed
  - Assigned "buddy" (optional)
  - Invitation to intro event
  - Skills spotlight opportunity

CHAMPION VOUCHING:
  - Champions can "vouch" for newcomers
  - Vouched newcomers get trust boost
  - Vouch appears on profile
  - Champion reputation tied to vouchee behavior
```

### 8.2 Milestone Celebrations

```yaml
FIRST_EXCHANGE:
  - Badge: "First Exchange Complete! 🎉"
  - Community notification
  - Encouragement for next

TRUSTED_STATUS:
  - Badge upgrade visible
  - Feature in "rising members"
  - New privileges unlocked message

CHAMPION_STATUS:
  - Community announcement
  - Profile highlight
  - Governance rights activated
  - Invitation to Champion council
```

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2024-XX-XX | Initial protocol definition |

---

*"Community isn't built. It grows when you create the right conditions."*
