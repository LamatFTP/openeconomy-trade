# Contributing to OpenEconomy.trade

> **"The economy should serve the people, not the other way around."**

Thank you for your interest in contributing to OpenEconomy! This project is built **by the people, for the people** — a decentralized, fair-value exchange protocol that enables skill and service trading without money.

---

## 🌟 Vision & Values

Before contributing, please understand our core principles:

- **Inclusive** - No barriers to entry, serving everyone including those excluded from traditional economy
- **Fair** - Time-normalized exchange rates, no exploitation
- **Trustless** - Blockchain verification, no intermediaries
- **Private** - Users control their data
- **Open** - Fully open source, community-driven
- **Non-Profit** - No investors, no profit extraction, donation-funded

If these values resonate with you, welcome to the community!

---

## 📋 Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Ways to Contribute](#ways-to-contribute)
3. [Getting Started](#getting-started)
4. [Development Setup](#development-setup)
5. [Contribution Workflow](#contribution-workflow)
6. [Coding Standards](#coding-standards)
7. [Testing Requirements](#testing-requirements)
8. [Documentation Guidelines](#documentation-guidelines)
9. [Community Governance](#community-governance)
10. [Security](#security)
11. [Communication](#communication)
12. [Recognition](#recognition)

---

## 📜 Code of Conduct

This project adheres to the principles outlined in our [Community Protocol](./docs/COMMUNITY-PROTOCOL.md). All contributors are expected to:

- **Be Respectful** - Value diverse perspectives and experiences
- **Be Inclusive** - Welcome contributors regardless of background, skill level, or employment status
- **Be Collaborative** - Work together constructively and assume good faith
- **Be Professional** - Focus on what's best for the community
- **Be Accountable** - Take responsibility for your words and actions

**Unacceptable behavior includes:**
- Harassment, discrimination, or exclusion of any kind
- Personal attacks, trolling, or inflammatory comments
- Publishing others' private information without consent
- Any conduct that would be inappropriate in a professional setting

**Reporting**: If you experience or witness unacceptable behavior, please report it to the project maintainers. All reports will be handled with discretion and confidentiality.

---

## 🤝 Ways to Contribute

We welcome contributions of all kinds:

### 💻 Code Contributions
- **Frontend Development** - Nuxt3/Vue.js, TypeScript, Tailwind CSS
- **Smart Contracts** - Solidity contracts for Polygon/Base
- **Backend/API** - Firebase Functions, Edge Functions
- **Testing** - Unit tests, integration tests, E2E tests
- **DevOps** - CI/CD, deployment, monitoring

### 📚 Documentation
- Improve existing documentation
- Write tutorials and guides
- Create video walkthroughs
- Translate documentation to other languages

### 🎨 Design
- UI/UX design and improvements
- Accessibility enhancements
- Visual assets (logos, icons, illustrations)
- User research and testing

### 🌍 Translation & Localization
- Translate the application to your language
- Review and improve existing translations
- Adapt content for local contexts

### 💭 Community Building
- Answer questions on Discord/forums
- Help new contributors get started
- Organize local community events
- Share the project with your network

### 🧪 Testing & Feedback
- Test new features and report bugs
- Provide user experience feedback
- Participate in beta testing
- Validate economic models and fairness

### 💡 Ideas & Strategy
- Economic modeling and fairness analysis
- Governance and protocol design
- Anti-gaming mechanisms
- Scaling and sustainability strategies

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** - v18 or higher
- **pnpm** - v8 or higher (preferred package manager)
- **Git** - For version control
- **Code Editor** - VS Code recommended

### Quick Start

1. **Explore the Documentation**
   - Read [README.md](./README.md) - Project overview
   - Review [MASTERPLAN.md](./MASTERPLAN.md) - Complete vision
   - Check [INDEX.md](./INDEX.md) - Project navigation
   - Understand [COMMUNITY-PROTOCOL.md](./docs/COMMUNITY-PROTOCOL.md) - Governance

2. **Find an Issue**
   - Browse [GitHub Issues](https://github.com/LamatFTP/openeconomy-trade/issues)
   - Look for `good first issue` or `help wanted` labels
   - Check the current [project phase](#project-phases) for priorities

3. **Introduce Yourself**
   - Comment on the issue you'd like to work on
   - Share your approach or ask questions
   - Wait for maintainer assignment (avoids duplicate work)

---

## 🛠️ Development Setup

### Clone the Repository

```bash
git clone https://github.com/LamatFTP/openeconomy-trade.git
cd openeconomy-trade
```

### Install Dependencies

```bash
pnpm install
```

### Project Structure

```
openeconomy-trade/
├── README.md                  # Project overview
├── MASTERPLAN.md             # Vision & architecture
├── CONTRIBUTING.md           # This file
├── INDEX.md                  # Documentation index
├── docs/                     # Detailed documentation
│   ├── COMMUNITY-PROTOCOL.md
│   ├── PHASE-1-MVP.md
│   ├── PHASE-2-ENHANCED.md
│   └── PHASE-3-BLOCKCHAIN.md
├── src/                      # Shared TypeScript types
│   ├── types.ts
│   └── community-types.ts
├── contracts/                # Solidity smart contracts
│   ├── src/                  # Contract source files
│   ├── test/                 # Contract tests
│   └── hardhat.config.ts
├── web/                      # Nuxt3 frontend (Phase 1)
└── package.json
```

### Development Commands

#### Root Level
```bash
pnpm install              # Install all dependencies
pnpm dev                  # Start web dev server
pnpm build                # Build for production
```

#### Smart Contracts
```bash
cd contracts
pnpm install              # Install contract dependencies
pnpm compile              # Compile Solidity contracts
pnpm test                 # Run contract tests
pnpm node                 # Start local Hardhat node
pnpm deploy:local         # Deploy to local node
pnpm deploy:mumbai        # Deploy to Polygon Mumbai testnet
```

#### Web Application (when ready)
```bash
cd web
pnpm dev                  # Start Nuxt dev server (port 3000)
pnpm build                # Build for production
pnpm generate             # Generate static site
```

### Environment Setup

1. **Create `.env.local` file** (when web app is initialized):
```bash
# Firebase (Phase 1-2)
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_domain
FIREBASE_PROJECT_ID=your_project_id

# Blockchain (Phase 3+)
NEXT_PUBLIC_CHAIN_ID=8453  # Base mainnet
WALLET_CONNECT_PROJECT_ID=your_project_id

# Optional
NEXT_PUBLIC_ENVIRONMENT=development
```

2. **Create `.env` for contracts** (when deploying):
```bash
PRIVATE_KEY=your_private_key_for_testnet
POLYGONSCAN_API_KEY=your_api_key
INFURA_API_KEY=your_api_key
```

**⚠️ Never commit `.env` files to git!**

---

## 🔄 Contribution Workflow

### 1. Create an Issue (or find one)

Before starting work:
- Check if an issue exists for your contribution
- If not, create a new issue describing:
  - **Problem**: What needs to be fixed/added?
  - **Solution**: Your proposed approach
  - **Alternatives**: Other options considered (if applicable)

### 2. Fork & Branch

```bash
# Fork the repository on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/openeconomy-trade.git
cd openeconomy-trade

# Add upstream remote
git remote add upstream https://github.com/LamatFTP/openeconomy-trade.git

# Create a feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

**Branch naming conventions:**
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions/improvements
- `chore/` - Build/tooling changes

### 3. Make Your Changes

- Follow the [Coding Standards](#coding-standards)
- Write clear, concise commit messages
- Test your changes thoroughly
- Update documentation if needed

### 4. Commit Your Changes

```bash
git add .
git commit -m "feat: add skill endorsement feature"
```

**Commit message format:**
```
<type>: <short description>

<optional longer description>

<optional footer>
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, no logic change)
- `refactor:` - Code refactoring
- `test:` - Adding/updating tests
- `chore:` - Build process, tooling, dependencies

**Examples:**
```
feat: add smart matching algorithm

Implements the match scoring system described in Phase 2.
Calculates compatibility based on skills, needs, and value alignment.

Closes #123
```

```
fix: resolve balance calculation error

Fixed integer overflow in balance aggregation function.
Added additional test coverage for edge cases.
```

### 5. Keep Your Branch Updated

```bash
# Fetch latest changes from upstream
git fetch upstream

# Rebase your branch on upstream main
git rebase upstream/main

# Resolve any conflicts, then:
git rebase --continue
```

### 6. Push to Your Fork

```bash
git push origin feature/your-feature-name

# If you rebased, you may need to force push
git push --force-with-lease origin feature/your-feature-name
```

### 7. Create a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select `base: main` (upstream) and `compare: your-branch` (your fork)
4. Fill in the PR template:

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issue
Closes #123

## Testing
How has this been tested?
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated
- [ ] All tests pass
```

### 8. Code Review Process

- Maintainers will review your PR
- Address feedback by pushing new commits to your branch
- Discussion happens in PR comments
- Once approved, a maintainer will merge

**Review criteria:**
- Code quality and adherence to standards
- Test coverage and passing tests
- Documentation completeness
- Alignment with project goals
- No breaking changes (unless intentional and discussed)

---

## 📝 Coding Standards

### TypeScript/JavaScript

**Style Guide:**
- Use **TypeScript** for all new code
- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use **ESLint** and **Prettier** (configs provided)
- Use **camelCase** for variables/functions, **PascalCase** for classes/types

**Best Practices:**
```typescript
// ✅ Good
interface Participant {
  id: string
  displayName: string
  hourlyValue: number
}

async function calculateMatchScore(
  me: Participant,
  them: Participant
): Promise<MatchScore> {
  // Implementation
}

// ❌ Avoid
const calc_match = (p1, p2) => {
  // Unclear names, no types
}
```

**Type Safety:**
- Avoid `any` - use `unknown` or proper types
- Use strict TypeScript settings
- Define interfaces/types in `src/types.ts` or co-located

**Comments:**
- Use comments sparingly, prefer self-documenting code
- Add JSDoc for public APIs
- Explain "why", not "what"

```typescript
/**
 * Calculates match compatibility between two participants
 * based on skill overlap, value alignment, and reputation.
 * 
 * @param me - Current user profile
 * @param them - Potential match profile
 * @returns Match score object with detailed breakdown
 */
export async function calculateMatchScore(
  me: Participant,
  them: Participant
): Promise<MatchScore> {
  // Algorithm weights skill overlap more heavily than reputation
  // because new users need opportunities to build reputation
  const weights = {
    skillMatch: 0.3,
    needMatch: 0.3,
    valueCompat: 0.2,
    reputation: 0.15,
    activity: 0.05
  }
  // ...
}
```

### Solidity Smart Contracts

**Style Guide:**
- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)
- Use Solidity **0.8.19+**
- Use **NatSpec** comments for all public functions

**Security:**
- Follow [ConsenSys Smart Contract Best Practices](https://consensys.github.io/smart-contract-best-practices/)
- Use **OpenZeppelin** libraries where applicable
- Avoid common vulnerabilities (reentrancy, overflow, etc.)
- Every contract must have comprehensive tests

**Example:**
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title ExchangeRegistry
 * @notice Records completed skill exchanges on-chain
 * @dev Immutable record of all exchanges for reputation calculation
 */
contract ExchangeRegistry is ReentrancyGuard {
    
    /// @notice Emitted when a new exchange is recorded
    event ExchangeRecorded(
        bytes32 indexed exchangeId,
        address indexed provider,
        address indexed receiver,
        uint256 timestamp
    );
    
    /**
     * @notice Records a completed exchange on-chain
     * @param _id Unique exchange identifier
     * @param _provider Address of service provider
     * @param _receiver Address of service receiver
     * @param _providerValue Value provided in wei-equivalent
     * @param _receiverValue Value received in wei-equivalent
     */
    function recordExchange(
        bytes32 _id,
        address _provider,
        address _receiver,
        uint256 _providerValue,
        uint256 _receiverValue
    ) external nonReentrant {
        // Implementation
    }
}
```

### Vue/Nuxt Components

**Structure:**
```vue
<script setup lang="ts">
// Imports
import { ref, computed } from 'vue'
import type { Participant } from '@/types'

// Props
interface Props {
  participant: Participant
  showActions?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showActions: true
})

// Emits
const emit = defineEmits<{
  propose: [participantId: string]
}>()

// State
const isHovered = ref(false)

// Computed
const displayValue = computed(() => 
  `$${props.participant.hourlyValue}/hour`
)

// Methods
function handlePropose() {
  emit('propose', props.participant.id)
}
</script>

<template>
  <div 
    class="participant-card"
    @mouseenter="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <!-- Template -->
  </div>
</template>

<style scoped>
/* Scoped styles, prefer Tailwind utility classes */
</style>
```

**Component Guidelines:**
- Keep components small and focused (single responsibility)
- Use **Composition API** (`<script setup>`)
- Prefer **TypeScript** for props and emits
- Use **Tailwind CSS** for styling
- Make components accessible (ARIA labels, keyboard navigation)

### CSS/Styling

- Use **Tailwind CSS** utility classes
- Create custom utilities in `tailwind.config` if needed
- Use scoped styles sparingly
- Follow mobile-first responsive design

---

## ✅ Testing Requirements

### Philosophy

**"If it's not tested, it's broken."**

All contributions with code changes should include appropriate tests.

### Test Coverage Goals

- **Critical paths**: 100% coverage
- **Smart contracts**: 100% coverage
- **Business logic**: 90%+ coverage
- **UI components**: 70%+ coverage
- **Overall**: 80%+ coverage

### Types of Tests

#### 1. Unit Tests

Test individual functions/components in isolation.

**JavaScript/TypeScript:**
```typescript
// calculateMatch.test.ts
import { describe, it, expect } from 'vitest'
import { calculateMatchScore } from './calculateMatch'

describe('calculateMatchScore', () => {
  it('should return high score for perfectly aligned skills', () => {
    const me = createMockParticipant({
      skills: ['Web Development'],
      needs: ['Graphic Design']
    })
    const them = createMockParticipant({
      skills: ['Graphic Design'],
      needs: ['Web Development']
    })
    
    const score = calculateMatchScore(me, them)
    
    expect(score.total).toBeGreaterThan(80)
    expect(score.breakdown.skillMatch).toBe(100)
    expect(score.breakdown.needMatch).toBe(100)
  })
  
  it('should return low score for misaligned participants', () => {
    // Test case
  })
})
```

**Smart Contracts:**
```typescript
// ExchangeRegistry.test.ts
import { expect } from "chai"
import { ethers } from "hardhat"

describe("ExchangeRegistry", () => {
  it("should record an exchange", async () => {
    const [provider, receiver] = await ethers.getSigners()
    const ExchangeRegistry = await ethers.getContractFactory("ExchangeRegistry")
    const registry = await ExchangeRegistry.deploy()
    
    const exchangeId = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("exchange-1"))
    
    await expect(
      registry.recordExchange(
        exchangeId,
        provider.address,
        receiver.address,
        ethers.utils.parseEther("100"),
        ethers.utils.parseEther("100")
      )
    )
      .to.emit(registry, "ExchangeRecorded")
      .withArgs(exchangeId, provider.address, receiver.address)
  })
})
```

#### 2. Integration Tests

Test interaction between multiple components/modules.

```typescript
// exchangeFlow.integration.test.ts
describe('Exchange Flow Integration', () => {
  it('should complete full exchange cycle', async () => {
    // 1. Create proposal
    const proposal = await createExchangeProposal(provider, receiver)
    
    // 2. Accept proposal
    await acceptProposal(proposal.id, receiver)
    
    // 3. Mark completed
    await markCompleted(proposal.id, provider)
    
    // 4. Confirm completion
    await confirmCompletion(proposal.id, receiver)
    
    // 5. Verify balances updated
    const providerBalance = await getBalance(provider.id)
    const receiverBalance = await getBalance(receiver.id)
    
    expect(providerBalance).toBe(100)
    expect(receiverBalance).toBe(-100)
  })
})
```

#### 3. E2E Tests

Test complete user workflows (when web app exists).

```typescript
// cypress/e2e/exchange.cy.ts
describe('Exchange Creation', () => {
  it('should allow creating and accepting an exchange', () => {
    cy.login('alice@example.com')
    cy.visit('/discover')
    cy.contains('Bob Smith').click()
    cy.contains('Propose Exchange').click()
    cy.selectSkill('Web Development')
    cy.fillHours(5)
    cy.contains('Submit').click()
    cy.contains('Proposal sent').should('be.visible')
  })
})
```

### Running Tests

```bash
# JavaScript/TypeScript tests
pnpm test              # Run all tests
pnpm test:unit         # Unit tests only
pnpm test:integration  # Integration tests
pnpm test:e2e          # E2E tests
pnpm test:watch        # Watch mode
pnpm test:coverage     # Coverage report

# Smart contract tests
cd contracts
pnpm test              # Run all contract tests
pnpm test:coverage     # Coverage report
pnpm test:gas          # Gas usage report
```

### Test Guidelines

- **Test behavior, not implementation**
- **Use descriptive test names**
- **Follow AAA pattern**: Arrange, Act, Assert
- **One assertion per test** (when possible)
- **Mock external dependencies**
- **Test edge cases and error conditions**
- **Keep tests fast** (unit tests < 100ms)

---

## 📖 Documentation Guidelines

Good documentation is as important as good code.

### When to Update Documentation

Update documentation when you:
- Add a new feature
- Change existing functionality
- Fix a bug that others might encounter
- Add new configuration options
- Change API endpoints or contracts
- Introduce breaking changes

### Documentation Types

#### 1. Code Comments

**When to comment:**
- Complex algorithms or business logic
- Non-obvious workarounds
- Performance optimizations
- Security considerations

**When NOT to comment:**
- Obvious code that explains itself
- What the code does (code should be clear)

#### 2. API Documentation

Use **JSDoc** for TypeScript/JavaScript:

```typescript
/**
 * Creates a new exchange proposal between two participants.
 * 
 * @param providerId - ID of the participant providing service
 * @param receiverId - ID of the participant receiving service
 * @param terms - Exchange terms including skills and hours
 * @returns Created exchange object
 * @throws {ValidationError} If terms are invalid
 * @throws {NotFoundError} If participants don't exist
 * 
 * @example
 * ```ts
 * const exchange = await createExchange(
 *   'user-123',
 *   'user-456',
 *   {
 *     providerSkill: 'Web Development',
 *     providerHours: 5,
 *     receiverSkill: 'Graphic Design',
 *     receiverHours: 4
 *   }
 * )
 * ```
 */
export async function createExchange(
  providerId: string,
  receiverId: string,
  terms: ExchangeTerms
): Promise<Exchange>
```

Use **NatSpec** for Solidity:

```solidity
/**
 * @notice Records a completed exchange on the blockchain
 * @dev Only callable after both parties have confirmed completion
 * @param _exchangeId Unique identifier for the exchange
 * @param _provider Address of the service provider
 * @param _receiver Address of the service receiver
 * @param _value Total value exchanged in wei-equivalent
 * @return success Whether the recording was successful
 */
function recordExchange(
    bytes32 _exchangeId,
    address _provider,
    address _receiver,
    uint256 _value
) external returns (bool success);
```

#### 3. User Documentation

- **README.md** - High-level overview, quick start
- **Tutorial docs** - Step-by-step guides
- **FAQ** - Common questions and answers
- **Troubleshooting** - Common issues and solutions

#### 4. Architecture Documentation

- **MASTERPLAN.md** - Overall vision and architecture
- **Phase docs** - Detailed specifications per phase
- **ADRs** (Architecture Decision Records) - Important technical decisions

### Writing Style

- **Be clear and concise**
- **Use active voice** ("Click Submit" not "Submit should be clicked")
- **Use present tense** ("The function returns..." not "The function will return...")
- **Use examples** liberally
- **Define acronyms** on first use
- **Use inclusive language**

---

## 🏛️ Community Governance

### Decision-Making Process

OpenEconomy follows a **progressive decentralization** model:

#### Phase 0-1: Founder-Led (Current)
- Core team makes technical decisions
- Community provides input via issues/discussions
- Focus on shipping MVP

#### Phase 2: Community Input
- Major decisions discussed in GitHub Discussions
- Community voting on feature priorities
- Maintainers implement consensus

#### Phase 3+: DAO Governance
- On-chain governance with OE tokens
- Community proposals and voting
- Transparent, binding decisions

### Current Process

1. **Proposal** - Create GitHub Discussion or Issue
2. **Discussion** - Community feedback (7 days minimum)
3. **Decision** - Maintainers make final call considering community input
4. **Implementation** - Assigned or picked up by contributors
5. **Review** - Code review and testing
6. **Merge** - Deployed to main branch

### What Requires Community Discussion

- Major feature additions
- Breaking changes
- Changes to economic model
- Governance structure changes
- Smart contract upgrades
- Token economics (if implemented)

### What Doesn't Require Discussion

- Bug fixes
- Performance improvements
- Documentation updates
- UI/UX improvements (non-breaking)
- Refactoring (no behavior change)

---

## 🔒 Security

### Reporting Vulnerabilities

**Please DO NOT report security vulnerabilities through public GitHub issues.**

Instead:
1. Email security@openeconomy.trade (or project maintainers directly)
2. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will:
- Acknowledge receipt within 48 hours
- Provide an estimated timeline for a fix
- Keep you updated on progress
- Credit you in the fix (if desired)

### Security Best Practices

**When contributing code:**

- ✅ **Validate all inputs**
- ✅ **Sanitize user data** before display (XSS prevention)
- ✅ **Use parameterized queries** (SQL injection prevention)
- ✅ **Implement rate limiting** on API endpoints
- ✅ **Never commit secrets** (API keys, private keys)
- ✅ **Use environment variables** for sensitive config
- ✅ **Keep dependencies updated** (run `pnpm audit`)
- ✅ **Follow least privilege principle**

**Smart Contract specific:**
- ✅ **Avoid reentrancy** - use ReentrancyGuard
- ✅ **Check for overflows** - use Solidity 0.8+ or SafeMath
- ✅ **Validate all external calls**
- ✅ **Emit events** for important state changes
- ✅ **Have contracts audited** before mainnet deployment

### Security Review Checklist

Before submitting code that handles:
- User authentication
- Financial transactions
- Smart contract interactions
- Sensitive user data

Ensure:
- [ ] Input validation implemented
- [ ] Error handling in place
- [ ] Security tests added
- [ ] No hardcoded secrets
- [ ] Dependencies up to date
- [ ] Code reviewed by another contributor

---

## 💬 Communication

### Channels

- **GitHub Issues** - Bug reports, feature requests
- **GitHub Discussions** - General discussions, Q&A, ideas
- **Discord** (coming soon) - Real-time chat, community building
- **Twitter/X** - Updates and announcements
- **Email** - security@openeconomy.trade for security issues

### Communication Guidelines

**GitHub Issues:**
- Search before creating (avoid duplicates)
- Use issue templates
- Be specific and provide details
- Include reproduction steps for bugs
- Tag appropriately

**GitHub Discussions:**
- Be respectful and constructive
- Stay on topic
- Help others when you can
- Share your experience and learnings

**Discord (when available):**
- Introduce yourself in #introductions
- Ask questions in appropriate channels
- Be patient waiting for responses (volunteers)
- Avoid DMs to maintainers unless necessary

### Response Times

We're a community project, everyone is volunteering time:
- **Critical bugs**: 24-48 hours
- **Issues/PRs**: 3-7 days
- **Discussions**: 1-2 weeks
- **Feature requests**: Varies by complexity

Please be patient. If urgent, explain why in your issue.

---

## 🏆 Recognition

### Contributor Acknowledgment

All contributors are recognized:

- **README.md** - Contributors section (after first contribution)
- **All Contributors bot** - Recognizes various contribution types
- **Release notes** - Credits for features/fixes
- **On-chain** (Phase 3+) - Contributor registry smart contract

### Types of Contributions We Recognize

- Code (features, fixes, refactors)
- Documentation (writing, editing, translating)
- Design (UI/UX, graphics, branding)
- Testing (bug reports, QA, user testing)
- Ideas (feature proposals, architecture input)
- Community (answering questions, organizing events)
- Financial (donations, grants obtained)

### Becoming a Maintainer

Regular, high-quality contributors may be invited to become maintainers:

**Criteria:**
- 10+ merged PRs over 3+ months
- Deep understanding of codebase
- Consistently follows guidelines
- Helps review other PRs
- Positive community interaction

**Privileges:**
- Triage issues
- Review and approve PRs
- Merge approved PRs
- Direct commit access
- Vote on major decisions

Interested? Let us know in Discord or via GitHub Discussion!

---

## 📅 Project Phases

Understanding where we are helps you contribute effectively:

### Current Phase: **Phase 0 → Phase 1 Transition**

**Phase 0: Foundation** ✅ (Complete)
- Core concept defined
- Documentation created
- Smart contracts drafted

**Phase 1: MVP** 🎯 (Next)
- Web portal development
- User registration & profiles
- Exchange proposal & tracking
- Balance ledger
- Firebase backend

**Contribution priorities:**
1. Frontend development (Nuxt3)
2. Firebase integration
3. User testing and feedback
4. Documentation improvements
5. UI/UX design

**Phase 2: Enhanced Matching** ⏳ (Future)
- Smart matching algorithm
- Reputation system
- Communities/groups
- In-app messaging

**Phase 3: Blockchain Integration** ⏳ (Future)
- Smart contract deployment
- Wallet integration
- On-chain ledger
- Decentralized identity

See [MASTERPLAN.md](./MASTERPLAN.md) for complete phase breakdown.

---

## 🎯 Priorities & Roadmap

### Immediate Priorities

1. **Nuxt3 Web Portal** - Core application development
2. **Firebase Setup** - Authentication and database
3. **User Flows** - Registration, discovery, exchange
4. **Mobile Responsive** - Works on all devices
5. **Testing Infrastructure** - Unit and E2E tests

### How to Help Now

- **Frontend devs**: Help build Nuxt3 components and pages
- **Backend devs**: Firebase Functions, API design
- **Designers**: UI/UX mockups, component design
- **Testers**: User testing, feedback on flows
- **Writers**: Improve documentation, create tutorials

Check [GitHub Projects](https://github.com/LamatFTP/openeconomy-trade/projects) for current sprint and tasks.

---

## ❓ FAQ

**Q: Do I need blockchain experience to contribute?**
A: No! Phase 1-2 are web application focused. Blockchain comes in Phase 3.

**Q: Can I contribute if I'm a beginner?**
A: Absolutely! Look for `good first issue` labels. We welcome all skill levels.

**Q: How much time do I need to commit?**
A: Any amount helps! Contribute when you can, no minimum required.

**Q: Will I be paid for contributions?**
A: This is a non-profit, volunteer project. No payment, but you'll gain experience, portfolio work, and help build a fairer economy!

**Q: Can I use OpenEconomy code in my own project?**
A: Yes! MIT license means you can fork, modify, and use it. We'd appreciate attribution and hope you'll contribute improvements back.

**Q: How do I stay updated?**
A: Watch the GitHub repo, join Discord (when available), or follow on Twitter/X.

**Q: Who owns OpenEconomy?**
A: The community! No single owner, no company, no investors. It's open source and will remain so forever.

---

## 📜 License

By contributing to OpenEconomy, you agree that your contributions will be licensed under the [MIT License](./LICENSE).

---

## 🙏 Thank You

Every contribution, no matter how small, makes a difference. By contributing to OpenEconomy, you're helping build a more inclusive, fair economic system.

**You're not just writing code. You're changing lives.**

---

## 📚 Additional Resources

- **[README.md](./README.md)** - Project overview
- **[MASTERPLAN.md](./MASTERPLAN.md)** - Complete vision and architecture
- **[COMMUNITY-PROTOCOL.md](./docs/COMMUNITY-PROTOCOL.md)** - Trust, governance, disputes
- **[INDEX.md](./INDEX.md)** - Complete project navigation
- **[Phase Documentation](./docs/)** - Detailed specifications

---

*"The best time to build a fairer economy was 20 years ago. The second best time is now."*

**Welcome to OpenEconomy. Let's build this together.** 🚀
