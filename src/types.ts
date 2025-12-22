/**
 * OpenEconomy Core Types
 * 
 * Central type definitions for the entire platform.
 * Phase 1 MVP types - will extend as platform evolves.
 */

// ============================================
// CORE ENTITIES
// ============================================

export interface Participant {
  id: string
  email: string
  displayName: string
  avatarUrl?: string
  
  // Value Assessment
  hourlyValue: number
  currency: Currency
  
  // Skills & Needs
  skills: Skill[]
  needs: string[]
  
  // Profile
  bio?: string
  location?: Location
  
  // Reputation
  reputation: ReputationScore
  trustTier: TrustTier
  
  // Balance
  balance: number  // Positive = credit, Negative = debt
  
  // Blockchain (Phase 3)
  walletAddress?: string
  
  // Meta
  createdAt: Timestamp
  updatedAt: Timestamp
  lastActiveAt: Timestamp
}

export interface Skill {
  id: string
  name: string
  category: SkillCategory
  subcategory?: string
  description?: string
  hourlyValueOverride?: number  // If different from participant default
  endorsements?: Endorsement[]  // Phase 2
}

export interface Exchange {
  id: string
  status: ExchangeStatus
  
  // Provider (giving the service)
  providerId: string
  providerDisplayName: string  // Denormalized for display
  providerSkill: Skill
  providerHoursEstimated: number
  providerHoursActual?: number
  providerValue: number  // hours × hourlyValue
  providerConfirmed: boolean
  providerRating?: number
  providerReview?: string
  
  // Receiver (receiving the service)
  receiverId: string
  receiverDisplayName: string  // Denormalized for display
  receiverSkill?: Skill  // What they'll provide in return (for balanced trade)
  receiverHoursEstimated?: number
  receiverHoursActual?: number
  receiverValue?: number
  receiverConfirmed: boolean
  receiverRating?: number
  receiverReview?: string
  
  // Trade Balance
  netValue: number  // providerValue - receiverValue (should be ~0 for balanced)
  isBalanced: boolean  // Within acceptable threshold
  
  // Notes & Communication
  notes?: string
  
  // Blockchain (Phase 3)
  onChain: boolean
  blockchainTxHash?: string
  
  // Timestamps
  createdAt: Timestamp
  acceptedAt?: Timestamp
  startedAt?: Timestamp
  completedAt?: Timestamp
  cancelledAt?: Timestamp
}

export interface Transaction {
  id: string
  participantId: string
  exchangeId: string
  type: TransactionType
  amount: number
  balanceBefore: number
  balanceAfter: number
  description: string
  createdAt: Timestamp
}

// ============================================
// SUPPORTING TYPES
// ============================================

export interface Location {
  city?: string
  country?: string
  timezone?: string
  coordinates?: {
    lat: number
    lng: number
  }
}

export interface ReputationScore {
  completedExchanges: number
  cancelledExchanges: number
  completionRate: number  // Calculated
  totalRatings: number
  averageRating: number
  totalValueProvided: number
  totalValueReceived: number
  responseTimeAvg?: number  // In hours
}

export interface Endorsement {
  id: string
  skillId: string
  endorserId: string
  endorserDisplayName: string
  exchangeId: string  // Must have completed exchange
  comment?: string
  createdAt: Timestamp
}

// Phase 2
export interface Group {
  id: string
  name: string
  description: string
  type: GroupType
  adminIds: string[]
  memberIds: string[]
  settings: GroupSettings
  imageUrl?: string
  createdAt: Timestamp
  updatedAt: Timestamp
}

export interface GroupSettings {
  allowExternalExchanges: boolean
  requireApproval: boolean
  maxMembers?: number
  visibility: 'public' | 'unlisted' | 'private'
}

// Phase 2
export interface Message {
  id: string
  threadId: string
  senderId: string
  content: string
  attachments?: Attachment[]
  readAt?: Timestamp
  createdAt: Timestamp
}

export interface Attachment {
  id: string
  type: 'image' | 'document'
  url: string
  name: string
  size: number
}

// Phase 2
export interface Dispute {
  id: string
  exchangeId: string
  raisedBy: string
  reason: DisputeReason
  description: string
  providerStatement?: string
  receiverStatement?: string
  mediatorId?: string
  resolution?: string
  status: DisputeStatus
  createdAt: Timestamp
  resolvedAt?: Timestamp
}

// ============================================
// ENUMS & LITERALS
// ============================================

export type Currency = 'USD' | 'EUR' | 'GBP' | 'INR' | 'LOCAL'

export type SkillCategory = 
  | 'technology'
  | 'creative'
  | 'manual'
  | 'education'
  | 'care'
  | 'professional'
  | 'other'

export type ExchangeStatus = 
  | 'proposed'      // Initial proposal sent
  | 'negotiating'   // Counter-proposals in progress
  | 'accepted'      // Both parties agreed
  | 'in_progress'   // Work has started
  | 'pending_confirmation'  // Work done, awaiting confirmations
  | 'completed'     // Both confirmed, exchange done
  | 'cancelled'     // Cancelled before completion
  | 'disputed'      // Under dispute resolution

export type TransactionType = 'credit' | 'debit'

export type TrustTier = 
  | 'new'       // No completed exchanges
  | 'active'    // 1+ exchanges
  | 'trusted'   // 5+ exchanges, 4.0+ rating
  | 'verified'  // 20+ exchanges, 4.5+ rating
  | 'champion'  // 50+ exchanges, 4.8+ rating

export type GroupType = 'public' | 'private' | 'invite_only'

export type DisputeReason = 
  | 'work_not_completed'
  | 'quality_issues'
  | 'time_dispute'
  | 'communication_breakdown'
  | 'no_show'
  | 'other'

export type DisputeStatus = 
  | 'open'
  | 'under_review'
  | 'resolved'
  | 'escalated'

// ============================================
// FIRESTORE HELPERS
// ============================================

export type Timestamp = {
  seconds: number
  nanoseconds: number
}

// For creating new documents
export type CreateParticipant = Omit<Participant, 'id' | 'createdAt' | 'updatedAt' | 'lastActiveAt' | 'reputation' | 'trustTier' | 'balance'>
export type CreateExchange = Omit<Exchange, 'id' | 'createdAt' | 'status' | 'onChain'>
export type CreateSkill = Omit<Skill, 'id' | 'endorsements'>

// ============================================
// API TYPES
// ============================================

export interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: {
    code: string
    message: string
  }
}

export interface PaginatedResponse<T> {
  items: T[]
  total: number
  page: number
  pageSize: number
  hasMore: boolean
}

export interface ParticipantFilters {
  skillCategory?: SkillCategory
  minHourlyValue?: number
  maxHourlyValue?: number
  trustTier?: TrustTier
  location?: string
  search?: string
}

export interface ExchangeFilters {
  status?: ExchangeStatus
  role?: 'provider' | 'receiver'
  startDate?: Date
  endDate?: Date
}

// ============================================
// MATCHING (Phase 2)
// ============================================

export interface MatchScore {
  participantId: string
  displayName: string
  avatarUrl?: string
  score: number  // 0-100
  breakdown: {
    skillAlignment: number
    needAlignment: number
    valueCompatibility: number
    reputationScore: number
    activityScore: number
  }
  matchingSkills: string[]  // Skills they have that I need
  matchingNeeds: string[]   // Needs they have that I can fulfill
}

// ============================================
// BLOCKCHAIN (Phase 3)
// ============================================

export interface OnChainExchange {
  id: string  // keccak256 hash
  provider: string  // Wallet address
  receiver: string  // Wallet address
  providerValue: bigint
  receiverValue: bigint
  timestamp: number
  providerConfirmed: boolean
  receiverConfirmed: boolean
  status: 'Pending' | 'Confirmed' | 'Disputed' | 'Resolved'
}

export interface OnChainReputation {
  totalExchanges: number
  totalRating: number
  totalValueProvided: bigint
  totalValueReceived: bigint
  lastActiveTimestamp: number
}
