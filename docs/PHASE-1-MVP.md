# Phase 1: MVP Specification

> The simplest thing that works.

---

## Goal

Functional web portal where participants can:
1. Register and set their value
2. List their skills and needs
3. Discover other participants
4. Propose and complete exchanges
5. Track their balance

---

## User Flows

### Flow 1: Registration
```
1. Land on homepage
2. Click "Join the Economy"
3. Choose: Email/Password OR Connect Wallet
4. Enter display name
5. Set hourly value (with guidance)
   - "What would you charge per hour for your skills?"
   - Suggestions based on common ranges
6. Add at least one skill
7. Optionally add needs
8. Complete → Dashboard
```

### Flow 2: Discovery
```
1. From Dashboard, click "Discover"
2. See grid of participants
3. Filter options:
   - Skill category
   - Hourly value range
   - Location (optional)
   - Search keyword
4. Click participant → View profile
5. See: Skills, needs, hourly value, reputation
6. Option: "Propose Exchange"
```

### Flow 3: Propose Exchange
```
1. From participant profile, click "Propose Exchange"
2. Select skill you want from them
3. Enter estimated hours needed
4. System shows value: hours × their rate
5. Select skill you'll provide in return
6. Enter estimated hours you'll provide
7. System shows value: hours × your rate
8. Review: Is it balanced? (within 10%)
9. Add optional note
10. Submit proposal
```

### Flow 4: Accept/Negotiate
```
1. Receive notification of proposal
2. Review terms
3. Options:
   - Accept → Exchange starts
   - Counter → Adjust terms
   - Decline → With optional reason
4. If countered, original proposer reviews
5. Continue until agreement or decline
```

### Flow 5: Complete Exchange
```
1. Provider marks "Work Started"
2. Provider marks "Work Completed"
3. Receiver confirms completion
4. Both rate each other (1-5 stars)
5. Balances updated
6. Exchange recorded in history
```

---

## Data Models

### Participant
```typescript
interface Participant {
  id: string
  email: string
  displayName: string
  avatarUrl?: string
  hourlyValue: number
  currency: 'USD' | 'EUR' | 'GBP' | 'LOCAL'
  skills: Skill[]
  needs: string[]
  bio?: string
  location?: {
    city?: string
    country?: string
    timezone?: string
  }
  reputation: {
    completedExchanges: number
    averageRating: number
    totalValueExchanged: number
  }
  balance: number  // Can be negative (owes) or positive (credit)
  createdAt: Timestamp
  updatedAt: Timestamp
}
```

### Skill
```typescript
interface Skill {
  id: string
  name: string
  category: SkillCategory
  description?: string
  hourlyValueOverride?: number  // If different from participant default
}

type SkillCategory = 
  | 'technology'
  | 'creative'
  | 'manual'
  | 'education'
  | 'care'
  | 'professional'
  | 'other'
```

### Exchange
```typescript
interface Exchange {
  id: string
  status: ExchangeStatus
  
  // Provider side
  providerId: string
  providerSkill: Skill
  providerHoursEstimated: number
  providerHoursActual?: number
  providerValue: number
  providerConfirmed: boolean
  providerRating?: number
  
  // Receiver side
  receiverId: string
  receiverSkill?: Skill  // What they'll provide in return
  receiverHoursEstimated?: number
  receiverHoursActual?: number
  receiverValue?: number
  receiverConfirmed: boolean
  receiverRating?: number
  
  // Meta
  notes?: string
  createdAt: Timestamp
  startedAt?: Timestamp
  completedAt?: Timestamp
}

type ExchangeStatus = 
  | 'proposed'
  | 'negotiating'
  | 'accepted'
  | 'in_progress'
  | 'pending_confirmation'
  | 'completed'
  | 'cancelled'
  | 'disputed'
```

### Transaction (Ledger Entry)
```typescript
interface Transaction {
  id: string
  participantId: string
  exchangeId: string
  type: 'credit' | 'debit'
  amount: number
  balanceAfter: number
  description: string
  createdAt: Timestamp
}
```

---

## Pages

### Public Pages
```
/                   - Landing page
/about              - About the project
/how-it-works       - Explanation
/join               - Registration
/login              - Sign in
```

### Authenticated Pages
```
/dashboard          - Overview, recent activity
/discover           - Browse participants
/profile/:id        - View participant profile
/profile/edit       - Edit own profile
/exchanges          - List of exchanges
/exchanges/:id      - Exchange detail
/propose/:id        - Create proposal for participant
/balance            - Transaction history
/settings           - Account settings
```

---

## Components

### Core UI
```
Button
Input
Select
Modal
Card
Avatar
Badge
Rating
Toast
```

### Business Components
```
ParticipantCard     - Preview card in grid
ParticipantProfile  - Full profile view
SkillTag           - Skill display chip
ExchangeCard       - Exchange summary
ExchangeTimeline   - Status progression
ProposalForm       - Exchange proposal
BalanceDisplay     - Current balance
TransactionList    - Ledger entries
RatingInput        - Star rating
```

---

## API Endpoints

### Auth
```
POST /auth/register
POST /auth/login
POST /auth/logout
GET  /auth/me
```

### Participants
```
GET    /participants              - List (with filters)
GET    /participants/:id          - Get one
PUT    /participants/:id          - Update own
DELETE /participants/:id          - Delete own account
```

### Skills
```
GET    /skills/categories         - List categories
GET    /skills/popular            - Popular skills
```

### Exchanges
```
POST   /exchanges                 - Create proposal
GET    /exchanges                 - List own exchanges
GET    /exchanges/:id             - Get one
PUT    /exchanges/:id             - Update (status, details)
POST   /exchanges/:id/accept      - Accept proposal
POST   /exchanges/:id/counter     - Counter proposal
POST   /exchanges/:id/decline     - Decline
POST   /exchanges/:id/start       - Mark started
POST   /exchanges/:id/complete    - Mark completed
POST   /exchanges/:id/confirm     - Confirm completion
POST   /exchanges/:id/rate        - Submit rating
```

### Balance
```
GET    /balance                   - Current balance
GET    /balance/transactions      - Transaction history
```

---

## Firestore Structure

```
/participants/{participantId}
  - Profile data
  - Skills array
  - Needs array
  - Reputation stats
  
/exchanges/{exchangeId}
  - Exchange data
  - Both parties' info
  
/transactions/{transactionId}
  - Ledger entries
  - Linked to participant and exchange
  
/messages/{exchangeId}/thread/{messageId}
  - Negotiation messages
  - (Phase 2 enhancement)
```

---

## Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Participants
    match /participants/{participantId} {
      allow read: if request.auth != null;
      allow create: if request.auth.uid == participantId;
      allow update: if request.auth.uid == participantId;
      allow delete: if request.auth.uid == participantId;
    }
    
    // Exchanges
    match /exchanges/{exchangeId} {
      allow read: if request.auth != null && 
        (request.auth.uid == resource.data.providerId || 
         request.auth.uid == resource.data.receiverId);
      allow create: if request.auth != null;
      allow update: if request.auth != null &&
        (request.auth.uid == resource.data.providerId || 
         request.auth.uid == resource.data.receiverId);
    }
    
    // Transactions
    match /transactions/{transactionId} {
      allow read: if request.auth != null && 
        request.auth.uid == resource.data.participantId;
      allow create: if false;  // Only via Cloud Functions
    }
  }
}
```

---

## MVP Acceptance Criteria

1. ✅ User can register with email/password
2. ✅ User can set hourly value and add skills
3. ✅ User can browse other participants
4. ✅ User can propose an exchange
5. ✅ User can accept/decline proposals
6. ✅ User can mark exchange complete
7. ✅ Both parties can confirm and rate
8. ✅ Balance updates automatically
9. ✅ Transaction history visible
10. ✅ Mobile responsive

---

## Out of Scope (Phase 1)

- Wallet connection (Phase 3)
- Smart matching (Phase 2)
- In-app messaging (Phase 2)
- Groups/communities (Phase 2)
- Blockchain ledger (Phase 3)
- Mobile apps (Phase 4)
- Dispute resolution (Phase 2)
