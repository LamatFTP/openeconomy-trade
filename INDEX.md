# OpenEconomy.trade - Project Index

> **Quick navigation for all documentation and code**

---

## 🎯 Start Here

| If you want to... | Go to |
|-------------------|-------|
| Understand the vision | [README.md](./README.md) |
| See the full plan | [MASTERPLAN.md](./MASTERPLAN.md) |
| Understand community rules | [docs/COMMUNITY-PROTOCOL.md](./docs/COMMUNITY-PROTOCOL.md) |
| See MVP scope | [docs/PHASE-1-MVP.md](./docs/PHASE-1-MVP.md) |
| Review type definitions | [src/types.ts](./src/types.ts) |
| Check smart contracts | [contracts/src/](./contracts/src/) |

---

## 📚 Documentation

### Core Documents

| File | Purpose | Status |
|------|---------|--------|
| [README.md](./README.md) | Public-facing overview, quick start | ✅ Complete |
| [MASTERPLAN.md](./MASTERPLAN.md) | Vision, entities, phase overview | ✅ Complete |

### Phase Specifications

| File | Scope | Status |
|------|-------|--------|
| [docs/PHASE-1-MVP.md](./docs/PHASE-1-MVP.md) | User flows, data models, API, Firestore rules | ✅ Complete |
| [docs/PHASE-2-ENHANCED.md](./docs/PHASE-2-ENHANCED.md) | Smart matching, reputation, groups, messaging | ✅ Complete |
| [docs/PHASE-3-BLOCKCHAIN.md](./docs/PHASE-3-BLOCKCHAIN.md) | Chain selection, contracts, migration plan | ✅ Complete |
| docs/PHASE-4-SCALE.md | Multi-community, DAO, mobile, i18n | ⏳ Planned |
| docs/PHASE-5-NETWORK.md | Federation, critical mass, self-sustaining | ⏳ Planned |

### Protocol Documents

| File | Purpose | Status |
|------|---------|--------|
| [docs/COMMUNITY-PROTOCOL.md](./docs/COMMUNITY-PROTOCOL.md) | Trust tiers, governance, disputes, anti-gaming | ✅ Complete |
| [docs/MASTERPLAN.md](./docs/MASTERPLAN.md) | Detailed technical architecture | ✅ Complete |

---

## 💻 Source Code

### TypeScript Types (`/src`)

| File | Contents | Lines |
|------|----------|-------|
| [src/types.ts](./src/types.ts) | Core entities: Participant, Exchange, Skill, Transaction | ~350 |
| [src/community-types.ts](./src/community-types.ts) | Community, Governance, Disputes, Trust Tiers | ~500 |

### Smart Contracts (`/contracts/src`)

| Contract | Purpose | Key Functions |
|----------|---------|---------------|
| [ParticipantRegistry.sol](./contracts/src/ParticipantRegistry.sol) | User registration, skills, endorsements | `register`, `updateBaseline`, `addSkill`, `endorse` |
| [ExchangeProtocol.sol](./contracts/src/ExchangeProtocol.sol) | Exchange lifecycle management | `proposeExchange`, `acceptExchange`, `markCompleted`, `confirmCompletion` |
| [CommunityGovernance.sol](./contracts/src/CommunityGovernance.sol) | Communities, roles, proposals, voting | `createCommunity`, `joinCommunity`, `changeRole`, `createProposal`, `vote` |
| [DisputeResolution.sol](./contracts/src/DisputeResolution.sol) | 3-level dispute escalation | `raiseDispute`, `submitMediatorProposal`, `submitCouncilVote` |

### Contract Infrastructure (`/contracts`)

| File | Purpose |
|------|---------|
| [contracts/hardhat.config.ts](./contracts/hardhat.config.ts) | Hardhat configuration (Polygon Mumbai + Mainnet) |
| [contracts/package.json](./contracts/package.json) | Contract dependencies |

### Web Application (`/web`)

| Directory | Purpose | Status |
|-----------|---------|--------|
| web/ | Nuxt3 frontend application | ⏳ Not started |

---

## 🏗️ Project Structure

```
openeconomy-trade/
│
├── 📄 INDEX.md                    # ← You are here
├── 📄 README.md                   # Public overview
├── 📄 MASTERPLAN.md               # Vision & entities
├── 📄 package.json                # Root package config
│
├── 📁 docs/                       # All documentation
│   ├── COMMUNITY-PROTOCOL.md      # Trust, governance, disputes
│   ├── MASTERPLAN.md              # Technical architecture
│   ├── PHASE-1-MVP.md             # MVP specification
│   ├── PHASE-2-ENHANCED.md        # Matching & reputation
│   └── PHASE-3-BLOCKCHAIN.md      # On-chain integration
│
├── 📁 src/                        # Shared TypeScript types
│   ├── types.ts                   # Core entity types
│   └── community-types.ts         # Community & governance types
│
├── 📁 contracts/                  # Solidity smart contracts
│   ├── src/
│   │   ├── ParticipantRegistry.sol
│   │   ├── ExchangeProtocol.sol
│   │   ├── CommunityGovernance.sol
│   │   └── DisputeResolution.sol
│   ├── test/                      # Contract tests (TODO)
│   ├── scripts/                   # Deploy scripts (TODO)
│   ├── hardhat.config.ts
│   └── package.json
│
├── 📁 web/                        # Nuxt3 frontend (TODO)
│   ├── components/
│   ├── pages/
│   ├── stores/
│   └── composables/
│
├── 📁 subgraph/                   # The Graph indexer (Phase 3)
│
└── 📁 sdk/                        # JavaScript SDK (Phase 4)
```

---

## 🔑 Key Concepts Quick Reference

### Trust Tiers

| Tier | Requirements | Key Privileges |
|------|--------------|----------------|
| 🌱 Newcomer | 0 exchanges | Browse, propose (max 3 pending) |
| ⚡ Active | 1+ exchanges | Reviews, endorsements |
| ✓ Trusted | 5+ exchanges, 4.0+ rating, 14+ days | Create communities, unlimited proposals |
| ⭐ Verified | 20+ exchanges, 4.5+ rating, 30+ days | Moderation, dispute mediation |
| 👑 Champion | 50+ exchanges, 4.8+ rating, 90+ days | Governance voting, vouch newcomers |

### Exchange States

```
proposed → accepted → in_progress → pending_confirmation → completed
    ↓         ↓            ↓                ↓
cancelled  cancelled   disputed         disputed
```

### Dispute Levels

```
Level 1: Self-Resolution (48h) → Both parties try to agree
Level 2: Mediation (5 days)    → Verified member mediates
Level 3: Council (7 days)      → 3 Champions vote (binding)
```

### Governance Models

| Model | Decision Maker | Use Case |
|-------|----------------|----------|
| Founder-led | Founder only | Small/new communities |
| Admin Council | Admins vote (majority) | Medium communities |
| Democratic | All members vote | Mature communities |
| Consensus | 80%+ agreement | High-stakes decisions |

---

## 🚀 Development Commands

### Root

```bash
pnpm install          # Install all dependencies
pnpm dev              # Start web development server
pnpm build            # Build for production
```

### Contracts

```bash
cd contracts
pnpm compile          # Compile Solidity contracts
pnpm test             # Run contract tests
pnpm node             # Start local Hardhat node
pnpm deploy:local     # Deploy to local node
pnpm deploy:mumbai    # Deploy to Polygon Mumbai
```

### Web (when ready)

```bash
cd web
pnpm dev              # Start Nuxt dev server
pnpm build            # Build for production
pnpm generate         # Generate static site
```

---

## 📊 Progress Tracker

### Documentation
- [x] README.md
- [x] MASTERPLAN.md
- [x] COMMUNITY-PROTOCOL.md
- [x] PHASE-1-MVP.md
- [x] PHASE-2-ENHANCED.md
- [x] PHASE-3-BLOCKCHAIN.md
- [ ] PHASE-4-SCALE.md
- [ ] PHASE-5-NETWORK.md
- [ ] CONTRIBUTING.md
- [ ] CODE_OF_CONDUCT.md

### Types
- [x] Core types (types.ts)
- [x] Community types (community-types.ts)
- [ ] API types
- [ ] Event types

### Smart Contracts
- [x] ParticipantRegistry.sol
- [x] ExchangeProtocol.sol
- [x] CommunityGovernance.sol
- [x] DisputeResolution.sol
- [ ] Contract tests
- [ ] Deploy scripts
- [ ] Gas optimization
- [ ] Security audit

### Web Application
- [ ] Nuxt3 scaffold
- [ ] Firebase setup
- [ ] Auth flow
- [ ] Registration flow
- [ ] Discovery/browse
- [ ] Profile pages
- [ ] Exchange flow
- [ ] Community pages
- [ ] Dispute UI

### Infrastructure
- [ ] Firebase project
- [ ] Vercel deployment
- [ ] Contract deployment (testnet)
- [ ] Domain setup (openeconomy.trade)

---

## 🔗 External Links

| Resource | URL |
|----------|-----|
| Website | https://openeconomy.trade (coming soon) |
| GitHub | https://github.com/openeconomy/trade (coming soon) |
| Discord | Coming soon |
| Documentation | Coming soon |

---

## 📝 Recent Updates

| Date | Change |
|------|--------|
| 2024-XX-XX | Added COMMUNITY-PROTOCOL.md |
| 2024-XX-XX | Added CommunityGovernance.sol |
| 2024-XX-XX | Added DisputeResolution.sol |
| 2024-XX-XX | Added community-types.ts |
| 2024-XX-XX | Created INDEX.md |

---

*Last updated: Auto-generated*
