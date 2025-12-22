# Phase 2: Enhanced Matching & Trust

> Smart connections. Earned reputation.

---

## Goal

Transform from manual browsing to intelligent matching with trust verification.

---

## Features

### 2.1 Smart Matching Algorithm

**Match Score Calculation**:
```typescript
interface MatchScore {
  participantId: string
  score: number  // 0-100
  breakdown: {
    skillAlignment: number    // They offer what I need
    needAlignment: number     // They need what I offer
    valueCompatibility: number // Hourly rates reasonable
    reputationScore: number   // Their track record
    activityScore: number     // Recently active
  }
}

function calculateMatchScore(me: Participant, them: Participant): MatchScore {
  const skillMatch = calculateSkillOverlap(me.needs, them.skills)
  const needMatch = calculateSkillOverlap(them.needs, me.skills)
  const valueCompat = calculateValueCompatibility(me.hourlyValue, them.hourlyValue)
  const reputation = them.reputation.averageRating / 5 * 100
  const activity = calculateActivityScore(them.lastActiveAt)
  
  return {
    participantId: them.id,
    score: weightedAverage([
      { value: skillMatch, weight: 0.3 },
      { value: needMatch, weight: 0.3 },
      { value: valueCompat, weight: 0.15 },
      { value: reputation, weight: 0.15 },
      { value: activity, weight: 0.1 }
    ]),
    breakdown: { skillMatch, needMatch, valueCompat, reputation, activity }
  }
}
```

**Match Notifications**:
```
- Daily digest: "3 new matches found"
- Instant notification for high-score matches (>80)
- Weekly summary email
```

---

### 2.2 Reputation System

**Trust Tiers**:
```typescript
type TrustTier = 'new' | 'active' | 'trusted' | 'verified' | 'champion'

function calculateTrustTier(participant: Participant): TrustTier {
  const { completedExchanges, averageRating } = participant.reputation
  
  if (completedExchanges >= 50 && averageRating >= 4.8) return 'champion'
  if (completedExchanges >= 20 && averageRating >= 4.5) return 'verified'
  if (completedExchanges >= 5 && averageRating >= 4.0) return 'trusted'
  if (completedExchanges >= 1) return 'active'
  return 'new'
}
```

**Reputation Display**:
```
- Trust tier badge
- Completion rate percentage
- Average rating (stars)
- Total exchanges completed
- Member since date
- Response time average
```

**Skill Endorsements**:
```typescript
interface Endorsement {
  skillId: string
  endorserId: string
  exchangeId: string  // Must have completed exchange
  comment?: string
  createdAt: Timestamp
}
```

---

### 2.3 Categories & Taxonomy

**Skill Categories**:
```typescript
const SKILL_CATEGORIES = {
  technology: {
    label: 'Technology',
    icon: 'laptop',
    subcategories: [
      'Web Development',
      'Mobile Development',
      'Data Analysis',
      'IT Support',
      'Automation',
      'AI/ML'
    ]
  },
  creative: {
    label: 'Creative',
    icon: 'palette',
    subcategories: [
      'Graphic Design',
      'Writing & Editing',
      'Photography',
      'Video Production',
      'Music',
      'Illustration'
    ]
  },
  manual: {
    label: 'Manual & Trade',
    icon: 'wrench',
    subcategories: [
      'Gardening',
      'Carpentry',
      'Plumbing',
      'Electrical',
      'Automotive',
      'Cleaning'
    ]
  },
  education: {
    label: 'Education',
    icon: 'book',
    subcategories: [
      'Tutoring',
      'Language Teaching',
      'Music Lessons',
      'Coaching',
      'Mentoring'
    ]
  },
  care: {
    label: 'Care & Wellness',
    icon: 'heart',
    subcategories: [
      'Childcare',
      'Pet Care',
      'Elder Care',
      'Fitness Training',
      'Meal Preparation',
      'Wellness'
    ]
  },
  professional: {
    label: 'Professional',
    icon: 'briefcase',
    subcategories: [
      'Consulting',
      'Legal Assistance',
      'Accounting',
      'Marketing',
      'Project Management',
      'Translation'
    ]
  }
}
```

**Demand Indicators**:
```
- Show "High Demand" badge for sought-after skills
- Display "X people looking for this"
- Trending skills section
```

---

### 2.4 Communication System

**In-App Messaging**:
```typescript
interface Message {
  id: string
  threadId: string  // Usually exchangeId
  senderId: string
  content: string
  attachments?: Attachment[]
  readAt?: Timestamp
  createdAt: Timestamp
}

interface Thread {
  id: string
  participantIds: [string, string]
  exchangeId?: string  // If related to exchange
  lastMessageAt: Timestamp
  unreadCount: { [participantId: string]: number }
}
```

**Scheduling**:
```
- Propose available times
- Accept/decline time slots
- Calendar integration (Phase 4)
- Timezone display and conversion
```

---

### 2.5 Groups & Communities

**Group Model**:
```typescript
interface Group {
  id: string
  name: string
  description: string
  type: 'public' | 'private' | 'invite_only'
  adminIds: string[]
  memberIds: string[]
  settings: {
    allowExternalExchanges: boolean
    requireApproval: boolean
    maxMembers?: number
  }
  createdAt: Timestamp
}
```

**Use Cases**:
```
- Local community (e.g., "Brooklyn Skill Share")
- Professional group (e.g., "Tech Workers Exchange")
- Organization (e.g., "Company X Internal")
- Interest group (e.g., "Sustainable Living")
```

---

### 2.6 Dispute Resolution

**Dispute Flow**:
```
1. Either party raises dispute
2. Both submit their version
3. Mediator reviews (volunteer from trusted tier)
4. Mediator proposes resolution
5. Both parties accept or escalate
6. Final decision recorded
```

**Dispute Types**:
```typescript
type DisputeReason =
  | 'work_not_completed'
  | 'quality_issues'
  | 'time_dispute'
  | 'communication_breakdown'
  | 'no_show'
  | 'other'
```

---

## New Pages

```
/matches                - Smart match suggestions
/messages               - Message threads
/messages/:threadId     - Conversation
/groups                 - Browse/create groups
/groups/:id             - Group page
/groups/:id/members     - Group members
/disputes               - My disputes
/disputes/:id           - Dispute detail
```

---

## Enhanced API

```
# Matching
GET  /matches                     - Get match suggestions
POST /matches/refresh             - Recalculate matches

# Messaging
GET  /threads                     - List message threads
GET  /threads/:id/messages        - Get messages
POST /threads/:id/messages        - Send message
PUT  /messages/:id/read           - Mark as read

# Groups
GET  /groups                      - List groups
POST /groups                      - Create group
GET  /groups/:id                  - Get group
PUT  /groups/:id                  - Update group
POST /groups/:id/join             - Join group
POST /groups/:id/leave            - Leave group
POST /groups/:id/invite           - Invite member

# Disputes
POST /disputes                    - Raise dispute
GET  /disputes/:id                - Get dispute
POST /disputes/:id/respond        - Submit response
POST /disputes/:id/resolve        - Mediator resolution
```

---

## Success Metrics

- Match acceptance rate > 30%
- Average time to first exchange < 7 days
- Dispute rate < 5%
- Message response rate > 70%
- Community creation > 10 groups
