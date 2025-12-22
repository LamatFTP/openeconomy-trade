/**
 * OpenEconomy Community Types
 * 
 * Type definitions for community structure and participation protocol.
 */

import { Timestamp } from './types'

// ============================================
// TRUST & REPUTATION
// ============================================

export type TrustTier = 
  | 'newcomer'   // 0 exchanges, just joined
  | 'active'     // 1+ exchanges
  | 'trusted'    // 5+ exchanges, 4.0+ rating
  | 'verified'   // 20+ exchanges, 4.5+ rating
  | 'champion'   // 50+ exchanges, 4.8+ rating

export interface TrustTierConfig {
  tier: TrustTier
  requirements: {
    minExchanges: number
    minRating: number
    maxDisputeRate: number
    minAccountAgeDays: number
  }
  privileges: TrustPrivilege[]
}

export type TrustPrivilege =
  | 'create_profile'
  | 'browse_participants'
  | 'propose_exchanges'
  | 'join_public_communities'
  | 'leave_reviews'
  | 'endorse_skills'
  | 'create_communities'
  | 'unlimited_pending_exchanges'
  | 'priority_matching'
  | 'community_moderation'
  | 'dispute_mediation'
  | 'featured_discovery'
  | 'protocol_governance'
  | 'vouch_newcomers'

export const TRUST_TIER_CONFIG: TrustTierConfig[] = [
  {
    tier: 'newcomer',
    requirements: {
      minExchanges: 0,
      minRating: 0,
      maxDisputeRate: 1.0,
      minAccountAgeDays: 0
    },
    privileges: [
      'create_profile',
      'browse_participants',
      'propose_exchanges',
      'join_public_communities'
    ]
  },
  {
    tier: 'active',
    requirements: {
      minExchanges: 1,
      minRating: 0,
      maxDisputeRate: 0.5,
      minAccountAgeDays: 0
    },
    privileges: [
      'create_profile',
      'browse_participants',
      'propose_exchanges',
      'join_public_communities',
      'leave_reviews',
      'endorse_skills'
    ]
  },
  {
    tier: 'trusted',
    requirements: {
      minExchanges: 5,
      minRating: 4.0,
      maxDisputeRate: 0.2,
      minAccountAgeDays: 14
    },
    privileges: [
      'create_profile',
      'browse_participants',
      'propose_exchanges',
      'join_public_communities',
      'leave_reviews',
      'endorse_skills',
      'create_communities',
      'unlimited_pending_exchanges',
      'priority_matching'
    ]
  },
  {
    tier: 'verified',
    requirements: {
      minExchanges: 20,
      minRating: 4.5,
      maxDisputeRate: 0.1,
      minAccountAgeDays: 30
    },
    privileges: [
      'create_profile',
      'browse_participants',
      'propose_exchanges',
      'join_public_communities',
      'leave_reviews',
      'endorse_skills',
      'create_communities',
      'unlimited_pending_exchanges',
      'priority_matching',
      'community_moderation',
      'dispute_mediation',
      'featured_discovery'
    ]
  },
  {
    tier: 'champion',
    requirements: {
      minExchanges: 50,
      minRating: 4.8,
      maxDisputeRate: 0.05,
      minAccountAgeDays: 90
    },
    privileges: [
      'create_profile',
      'browse_participants',
      'propose_exchanges',
      'join_public_communities',
      'leave_reviews',
      'endorse_skills',
      'create_communities',
      'unlimited_pending_exchanges',
      'priority_matching',
      'community_moderation',
      'dispute_mediation',
      'featured_discovery',
      'protocol_governance',
      'vouch_newcomers'
    ]
  }
]

// ============================================
// COMMUNITY
// ============================================

export type CommunityType =
  | 'geographic'     // Location-based (Brooklyn, Mumbai)
  | 'professional'   // Industry (Tech Workers, Healthcare)
  | 'interest'       // Shared interest (Sustainability, Parents)
  | 'organization'   // Company/institution internal
  | 'cause'          // Mission-driven (Mutual Aid, Refugee Support)

export type CommunityVisibility = 'public' | 'unlisted' | 'private'
export type JoinPolicy = 'open' | 'approval' | 'invite_only'
export type CommunityRole = 'member' | 'moderator' | 'admin' | 'founder'
export type MemberStanding = 'good' | 'warning' | 'suspended'

export interface Community {
  id: string
  name: string
  slug: string  // URL-friendly identifier
  type: CommunityType
  description: string
  imageUrl?: string
  bannerUrl?: string
  
  // Access control
  visibility: CommunityVisibility
  joinPolicy: JoinPolicy
  
  // Governance
  governance: GovernanceConfig
  
  // Stats (denormalized for performance)
  memberCount: number
  exchangeCount: number
  avgRating: number
  
  // Cross-community settings
  federation: FederationSettings
  
  // Metadata
  createdAt: Timestamp
  createdBy: string
  updatedAt: Timestamp
}

export interface CommunityMember {
  id: string
  communityId: string
  participantId: string
  role: CommunityRole
  standing: MemberStanding
  
  // Stats within this community
  exchangesInCommunity: number
  ratingInCommunity: number
  
  // Moderation
  warnings: Warning[]
  suspendedUntil?: Timestamp
  
  // Meta
  joinedAt: Timestamp
  invitedBy?: string
  lastActiveAt: Timestamp
}

export interface Warning {
  id: string
  reason: string
  issuedBy: string
  issuedAt: Timestamp
  expiresAt?: Timestamp
}

// ============================================
// GOVERNANCE
// ============================================

export type GovernanceModel =
  | 'founder_led'    // Founder decides
  | 'admin_council'  // Admins vote (majority)
  | 'democratic'     // All members vote
  | 'consensus'      // High agreement required (80%+)
  | 'delegated'      // Representatives

export type DecisionType =
  | 'settings_change'
  | 'member_removal'
  | 'role_change'
  | 'community_merge'
  | 'policy_change'
  | 'federation_join'
  | 'federation_leave'

export interface GovernanceConfig {
  model: GovernanceModel
  
  // Voting parameters (for voting models)
  votingPeriodHours: number
  quorumPercentage: number      // Min participation required
  approvalThreshold: number     // % yes votes to pass
  
  // Who can do what
  whoCanPropose: CommunityRole[]
  whoCanVote: CommunityRole[]
  
  // What requires voting
  decisionsRequiringVote: DecisionType[]
}

export interface Proposal {
  id: string
  communityId: string
  type: DecisionType
  title: string
  description: string
  proposedBy: string
  
  // Voting
  status: 'active' | 'passed' | 'rejected' | 'expired'
  votesFor: number
  votesAgainst: number
  votesAbstain: number
  totalEligibleVoters: number
  
  // Timing
  createdAt: Timestamp
  endsAt: Timestamp
  executedAt?: Timestamp
}

export interface Vote {
  proposalId: string
  participantId: string
  vote: 'for' | 'against' | 'abstain'
  votedAt: Timestamp
}

// ============================================
// FEDERATION
// ============================================

export type FederationType = 'loose' | 'medium' | 'tight'

export interface FederationSettings {
  allowExternalExchanges: boolean
  externalApprovalRequired: 'auto' | 'moderator' | 'admin'
  visibleToExternal: boolean
  federations: FederationMembership[]
}

export interface FederationMembership {
  federationId: string
  federationName: string
  type: FederationType
  joinedAt: Timestamp
}

export interface Federation {
  id: string
  name: string
  description: string
  type: FederationType
  
  // Member communities
  communities: FederatedCommunity[]
  
  // Shared features based on type
  sharedFeatures: {
    discovery: boolean      // Can see each other's members
    matching: boolean       // Cross-community matching
    reputation: boolean     // Reputation visible across
    governance: boolean     // Shared decision making
    events: boolean         // Joint events
  }
  
  createdAt: Timestamp
}

export interface FederatedCommunity {
  communityId: string
  communityName: string
  memberCount: number
  joinedAt: Timestamp
}

// ============================================
// DISPUTES
// ============================================

export type DisputeType =
  | 'non_completion'      // Work not done
  | 'quality'             // Poor quality
  | 'time_discrepancy'    // Hours dispute
  | 'communication'       // Ghosting
  | 'misrepresentation'   // Not as described
  | 'behavior'            // Inappropriate conduct
  | 'other'

export type DisputeStatus =
  | 'self_resolution'     // Level 1: parties trying to resolve
  | 'mediation'           // Level 2: mediator assigned
  | 'council_review'      // Level 3: champion panel
  | 'resolved'            // Closed with resolution
  | 'expired'             // Closed due to timeout

export type DisputeResolution =
  | 'voided'              // Exchange cancelled, no credit change
  | 'partial_credit'      // Adjusted credit
  | 'full_credit'         // Original credit stands
  | 'provider_favor'      // Decided for provider
  | 'receiver_favor'      // Decided for receiver

export type DisputeSanction =
  | 'none'
  | 'warning'             // Note on profile
  | 'suspension_30d'      // 30-day freeze
  | 'community_removal'   // Removed from community
  | 'protocol_ban'        // Global ban (extreme)

export interface Dispute {
  id: string
  exchangeId: string
  communityId?: string
  
  // Parties
  raisedBy: string
  againstParticipant: string
  
  // Details
  type: DisputeType
  description: string
  evidence?: DisputeEvidence[]
  
  // Statements
  raisedByStatement: string
  respondentStatement?: string
  
  // Resolution process
  status: DisputeStatus
  level: 1 | 2 | 3
  
  // Level 2: Mediation
  mediatorId?: string
  mediatorProposal?: string
  mediatorProposalAccepted?: {
    raisedBy: boolean
    respondent: boolean
  }
  
  // Level 3: Council
  councilMembers?: string[]  // 3 champions
  councilVotes?: CouncilVote[]
  
  // Outcome
  resolution?: DisputeResolution
  creditAdjustment?: number
  sanction?: DisputeSanction
  sanctionedParticipant?: string
  
  // Timing
  createdAt: Timestamp
  escalatedToL2At?: Timestamp
  escalatedToL3At?: Timestamp
  resolvedAt?: Timestamp
  
  // Deadlines
  selfResolutionDeadline: Timestamp    // 48 hours from creation
  mediationDeadline?: Timestamp         // 5 days from L2
  councilDeadline?: Timestamp           // 7 days from L3
}

export interface DisputeEvidence {
  id: string
  type: 'text' | 'image' | 'document' | 'link'
  content: string  // Text or URL
  submittedBy: string
  submittedAt: Timestamp
}

export interface CouncilVote {
  championId: string
  resolution: DisputeResolution
  sanction: DisputeSanction
  reasoning: string
  votedAt: Timestamp
}

// ============================================
// COMMUNITY HEALTH
// ============================================

export interface CommunityHealth {
  communityId: string
  calculatedAt: Timestamp
  
  // Activity metrics
  activeMembers30d: number
  exchangesPerMonth: number
  avgTimeToFirstExchangeDays: number
  proposalResponseRate: number
  avgResponseTimeHours: number
  
  // Quality metrics
  avgRating: number
  completionRate: number
  disputeRate: number
  
  // Growth metrics
  newMembersPerMonth: number
  retentionRate90d: number
  churnRate30d: number
  
  // Balance metrics
  giniCoefficient: number       // 0 = equal, 1 = unequal
  avgBalance: number
  membersWithNegativeBalance: number
  membersWithPositiveBalance: number
  
  // Overall score (0-100)
  healthScore: number
  
  // Flags
  alerts: HealthAlert[]
}

export type HealthAlertType =
  | 'low_activity'
  | 'high_disputes'
  | 'imbalance'
  | 'stagnation'
  | 'rapid_growth'

export interface HealthAlert {
  type: HealthAlertType
  severity: 'info' | 'warning' | 'critical'
  message: string
  suggestedActions: string[]
  triggeredAt: Timestamp
}

// ============================================
// VOUCHING & CEREMONIES
// ============================================

export interface Vouch {
  id: string
  voucherId: string       // Champion who vouches
  voucheeId: string       // Newcomer being vouched for
  message?: string
  
  // Vouch validity
  isActive: boolean
  revokedAt?: Timestamp
  revokeReason?: string
  
  createdAt: Timestamp
}

export interface Milestone {
  participantId: string
  type: MilestoneType
  achievedAt: Timestamp
  communityId?: string    // If community-specific
  celebrated: boolean     // If notification sent
}

export type MilestoneType =
  | 'first_exchange'
  | 'active_status'
  | 'trusted_status'
  | 'verified_status'
  | 'champion_status'
  | 'first_community_created'
  | 'first_mediation'
  | 'exchanges_10'
  | 'exchanges_25'
  | 'exchanges_50'
  | 'exchanges_100'
  | 'perfect_rating_10'   // 10 exchanges with 5-star

// ============================================
// MODERATION
// ============================================

export type ModeratorAction =
  | 'approve_member'
  | 'reject_member'
  | 'warn_member'
  | 'mute_member'
  | 'suspend_member'
  | 'remove_member'
  | 'resolve_dispute'
  | 'escalate_dispute'

export interface ModerationLog {
  id: string
  communityId: string
  moderatorId: string
  action: ModeratorAction
  targetParticipantId: string
  reason: string
  details?: object
  createdAt: Timestamp
}

// ============================================
// ANTI-GAMING
// ============================================

export interface SuspiciousActivity {
  id: string
  participantId: string
  type: SuspiciousActivityType
  confidence: number      // 0-1 score
  details: object
  detectedAt: Timestamp
  reviewedBy?: string
  reviewedAt?: Timestamp
  actionTaken?: string
}

export type SuspiciousActivityType =
  | 'sybil_pattern'           // Multiple accounts
  | 'collusion_pattern'       // Only exchanges with same person
  | 'rating_manipulation'     // All 5s or all 1s
  | 'value_inflation'         // Unrealistic hourly rate
  | 'rapid_tier_advancement'  // Too fast to be legitimate
  | 'cross_vouching'          // Champions vouching each other's alts

// ============================================
// HELPERS
// ============================================

export function calculateTrustTier(stats: {
  exchanges: number
  rating: number
  disputeRate: number
  accountAgeDays: number
}): TrustTier {
  for (let i = TRUST_TIER_CONFIG.length - 1; i >= 0; i--) {
    const config = TRUST_TIER_CONFIG[i]
    const req = config.requirements
    
    if (
      stats.exchanges >= req.minExchanges &&
      stats.rating >= req.minRating &&
      stats.disputeRate <= req.maxDisputeRate &&
      stats.accountAgeDays >= req.minAccountAgeDays
    ) {
      return config.tier
    }
  }
  
  return 'newcomer'
}

export function hasPrivilege(tier: TrustTier, privilege: TrustPrivilege): boolean {
  const config = TRUST_TIER_CONFIG.find(t => t.tier === tier)
  return config?.privileges.includes(privilege) ?? false
}

export function canPerformAction(
  member: CommunityMember,
  action: ModeratorAction
): boolean {
  const roleHierarchy: CommunityRole[] = ['member', 'moderator', 'admin', 'founder']
  const memberLevel = roleHierarchy.indexOf(member.role)
  
  const actionRequirements: Record<ModeratorAction, CommunityRole> = {
    approve_member: 'moderator',
    reject_member: 'moderator',
    warn_member: 'moderator',
    mute_member: 'moderator',
    suspend_member: 'admin',
    remove_member: 'admin',
    resolve_dispute: 'moderator',
    escalate_dispute: 'moderator'
  }
  
  const requiredLevel = roleHierarchy.indexOf(actionRequirements[action])
  return memberLevel >= requiredLevel && member.standing === 'good'
}
