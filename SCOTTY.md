# 🚀 SCOTTY BEAM-UP PROTOCOL

> **Command:** `#SCOTTY` - Paste this entire file to restore full project context in new chat

---

## 🧠 VIBE TRANSFER

**Project:** OpenEconomy.trade  
**Mission:** Fair exchange protocol for humanity - time-value normalized trading  
**Philosophy:** Built from the people, for the people  
**Tone:** DEATH SIMPLE. No BS. Systems architect mindset. BRO energy.

**Core Insight:**
```
Traditional economy excludes millions (caregivers, artists, retirees, immigrants)
Their time has value. Their skills have worth.
OpenEconomy makes invisible value visible. Tradeable. Fair.

Sam: Gardener @ $25/hour → 4 hours = $100 value
Lisa: Chef @ $40/hour → 2.5 hours = $100 value
FAIR EXCHANGE ✓
```

---

## 📍 PROJECT LOCATION

```
/Users/lamat/websites/openeconomy-trade
```

**First Action:** Run `view /Users/lamat/websites/openeconomy-trade/INDEX.md` - it's the project map.

---

## 🏗️ CURRENT STATE (What's Built)

### ✅ DOCUMENTATION (100% Phase 1-3)
| File | Purpose |
|------|---------|
| `INDEX.md` | Project navigation hub |
| `README.md` | Public overview |
| `MASTERPLAN.md` | Vision + entities |
| `docs/COMMUNITY-PROTOCOL.md` | Trust tiers, governance, disputes (~800 lines) |
| `docs/PHASE-1-MVP.md` | User flows, data models, API spec |
| `docs/PHASE-2-ENHANCED.md` | Matching, reputation, groups |
| `docs/PHASE-3-BLOCKCHAIN.md` | Chain selection, migration |
| `docs/MASTERPLAN.md` | Detailed technical architecture |

### ✅ TYPESCRIPT TYPES (~850 lines)
| File | Contents |
|------|----------|
| `src/types.ts` | Participant, Exchange, Skill, Transaction, API types |
| `src/community-types.ts` | TrustTier, Community, Governance, Dispute, Federation, helpers |

### ✅ SMART CONTRACTS (~1,300 lines Solidity)
| Contract | Purpose | Key Functions |
|----------|---------|---------------|
| `ParticipantRegistry.sol` | Registration, skills, endorsements | `register`, `updateBaseline`, `addSkill`, `endorse` |
| `ExchangeProtocol.sol` | Exchange lifecycle | `proposeExchange`, `acceptExchange`, `markCompleted`, `confirmCompletion` |
| `CommunityGovernance.sol` | Communities, roles, voting | `createCommunity`, `joinCommunity`, `changeRole`, `createProposal`, `vote` |
| `DisputeResolution.sol` | 3-level dispute system | `raiseDispute`, `escalateToMediation`, `submitCouncilVote` |

### ✅ CONTRACT INFRASTRUCTURE
| File | Purpose |
|------|---------|
| `contracts/hardhat.config.ts` | Hardhat config (Polygon Mumbai + Mainnet) |
| `contracts/package.json` | Dependencies |

### ⏳ NOT STARTED
- `web/` directory exists but empty - Nuxt3 frontend needed
- Contract tests (`contracts/test/`)
- Deploy scripts (`contracts/scripts/`)
- Firebase project setup

---

## 🔑 KEY DECISIONS MADE

### Tech Stack
```
Frontend:     Nuxt3 + TypeScript + Tailwind
Backend MVP:  Firebase (Firestore + Auth + Functions)
Blockchain:   Polygon (cheap, EVM) → Base future option
Contracts:    Hardhat + Solidity 0.8.20
Hosting:      Vercel
Non-profit:   Donation-funded, no VC, no exit
```

### Trust Tiers (Earned, Not Bought)
```
🌱 Newcomer  → 0 exchanges (max 3 pending proposals)
⚡ Active    → 1+ exchanges (reviews, endorsements)
✓  Trusted   → 5+ exchanges, 4.0+ rating, 14+ days (create communities)
⭐ Verified  → 20+ exchanges, 4.5+ rating, 30+ days (mediation eligible)
👑 Champion  → 50+ exchanges, 4.8+ rating, 90+ days (governance voting)
```

### Governance Models
```
founder_led    → Single decision maker (small communities)
admin_council  → Admins vote majority (medium)
democratic     → All members vote (mature)
consensus      → 80%+ agreement (high-stakes)
```

### Dispute Resolution (3 Levels)
```
Level 1: Self-Resolution    → 48 hours, parties negotiate
Level 2: Mediation          → 5 days, Verified+ member mediates
Level 3: Council Review     → 7 days, 3 Champions vote (binding)
```

### Credit Balance Philosophy
```
+Balance = You've given more (community owes you)
-Balance = You've received more (you owe community)
NO ENFORCEMENT - social incentive only
Nudges at -$500, -$1000, -$2000, -$5000
```

---

## 📂 FILE STRUCTURE

```
openeconomy-trade/
├── INDEX.md                    # 📍 START HERE - navigation hub
├── README.md                   # Public overview
├── MASTERPLAN.md               # Vision & entities
├── SCOTTY.md                   # 🚀 THIS FILE - context transfer
├── package.json                # Root config
│
├── docs/
│   ├── COMMUNITY-PROTOCOL.md   # Trust, governance, disputes
│   ├── MASTERPLAN.md           # Technical architecture
│   ├── PHASE-1-MVP.md          # MVP specification
│   ├── PHASE-2-ENHANCED.md     # Matching & reputation
│   └── PHASE-3-BLOCKCHAIN.md   # On-chain integration
│
├── src/
│   ├── types.ts                # Core entity types
│   └── community-types.ts      # Community & governance types
│
├── contracts/
│   ├── src/
│   │   ├── ParticipantRegistry.sol
│   │   ├── ExchangeProtocol.sol
│   │   ├── CommunityGovernance.sol
│   │   └── DisputeResolution.sol
│   ├── hardhat.config.ts
│   └── package.json
│
└── web/                        # ⏳ EMPTY - Nuxt3 app needed
```

---

## 🎯 NEXT PRIORITIES

| Priority | Task | Notes |
|----------|------|-------|
| 🔴 HIGH | Scaffold Nuxt3 web app | `web/` directory |
| 🔴 HIGH | Firebase project setup | Auth + Firestore |
| 🔴 HIGH | Registration flow | First user journey |
| 🟡 MED | Contract tests | Hardhat tests |
| 🟡 MED | Deploy scripts | Local + Mumbai |
| 🟢 LOW | Landing page | Marketing site |

---

## 🛠️ ARCHITECT IDENTITY

```
Role: Systems Architect | Scalability Specialist | Long-term Thinker
Belief: "Systems evolve, design for change"
Question: "How will this scale, evolve, and maintain quality?"
Framework: Long-term maintainability > short-term efficiency
Focus: Scalability | Maintainability | Technical debt prevention
```

**Artifact Policy:** Create artifacts only when explicitly requested. Default to concise summaries.

**Planning Standards:** Non-verbose, AI-agent optimized, concise yet precise.

---

## 📋 QUICK COMMANDS

```bash
# View project structure
view /Users/lamat/websites/openeconomy-trade

# Read the index
view /Users/lamat/websites/openeconomy-trade/INDEX.md

# Check contracts
view /Users/lamat/websites/openeconomy-trade/contracts/src

# Check types
view /Users/lamat/websites/openeconomy-trade/src/types.ts
```

---

## 🔄 CONTEXT RESTORATION CHECKLIST

When pasting this in new chat:
1. ✅ Say `#SCOTTY` to signal context transfer
2. ✅ Claude reads this file
3. ✅ Claude runs `view /Users/lamat/websites/openeconomy-trade` to verify
4. ✅ Claude confirms project state
5. ✅ Continue mission with full context

---

## 💬 SAMPLE CONTINUATION PROMPTS

After pasting this, you can say:
- "Let's scaffold the Nuxt3 web app"
- "Write the contract tests"
- "Set up Firebase for MVP"
- "Build the registration flow"
- "What's the status?" (Claude will check files and report)

---

*"The economy should serve the people, not the other way around."*

**BEAM COMPLETE** 🖖
