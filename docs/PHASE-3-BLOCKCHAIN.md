# Phase 3: Blockchain Integration

> Trustless. Transparent. Permanent.

---

## Goal

Migrate core exchange ledger to blockchain for:
- Immutable record of all exchanges
- Trustless verification
- Decentralized identity
- Foundation for governance

---

## Chain Selection

### Evaluation Matrix

| Criteria | Solana | Polygon | Base | Arbitrum |
|----------|--------|---------|------|----------|
| Tx Cost | ~$0.001 | ~$0.01 | ~$0.001 | ~$0.01 |
| Speed | ~400ms | ~2s | ~2s | ~2s |
| EVM Compatible | No | Yes | Yes | Yes |
| Ecosystem | Strong | Strong | Growing | Strong |
| Mobile Wallets | Good | Great | Good | Good |
| Green | Moderate | Good | Good | Good |

### Recommendation: **Base**

Reasons:
- EVM compatible (easier development)
- Coinbase backing (mainstream adoption potential)
- Low fees
- Growing ecosystem
- Good mobile wallet support
- Aligns with "for the people" ethos

---

## Smart Contracts

### ExchangeRegistry.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ExchangeRegistry {
    struct Exchange {
        bytes32 id;
        address provider;
        address receiver;
        uint256 providerValue;    // In wei equivalent (for record)
        uint256 receiverValue;
        uint256 timestamp;
        bool providerConfirmed;
        bool receiverConfirmed;
        ExchangeStatus status;
    }
    
    enum ExchangeStatus {
        Pending,
        Confirmed,
        Disputed,
        Resolved
    }
    
    mapping(bytes32 => Exchange) public exchanges;
    mapping(address => bytes32[]) public participantExchanges;
    
    event ExchangeRecorded(bytes32 indexed id, address provider, address receiver);
    event ExchangeConfirmed(bytes32 indexed id);
    event ExchangeDisputed(bytes32 indexed id);
    
    function recordExchange(
        bytes32 _id,
        address _provider,
        address _receiver,
        uint256 _providerValue,
        uint256 _receiverValue
    ) external {
        // Only callable by verified relayer or participants
        exchanges[_id] = Exchange({
            id: _id,
            provider: _provider,
            receiver: _receiver,
            providerValue: _providerValue,
            receiverValue: _receiverValue,
            timestamp: block.timestamp,
            providerConfirmed: false,
            receiverConfirmed: false,
            status: ExchangeStatus.Pending
        });
        
        participantExchanges[_provider].push(_id);
        participantExchanges[_receiver].push(_id);
        
        emit ExchangeRecorded(_id, _provider, _receiver);
    }
    
    function confirmExchange(bytes32 _id) external {
        Exchange storage exchange = exchanges[_id];
        require(
            msg.sender == exchange.provider || msg.sender == exchange.receiver,
            "Not a participant"
        );
        
        if (msg.sender == exchange.provider) {
            exchange.providerConfirmed = true;
        } else {
            exchange.receiverConfirmed = true;
        }
        
        if (exchange.providerConfirmed && exchange.receiverConfirmed) {
            exchange.status = ExchangeStatus.Confirmed;
            emit ExchangeConfirmed(_id);
        }
    }
    
    function getParticipantHistory(address _participant) 
        external view returns (bytes32[] memory) 
    {
        return participantExchanges[_participant];
    }
}
```

### ReputationRegistry.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ReputationRegistry {
    struct Reputation {
        uint256 totalExchanges;
        uint256 totalRating;       // Sum of all ratings
        uint256 totalValueProvided;
        uint256 totalValueReceived;
        uint256 lastActiveTimestamp;
    }
    
    mapping(address => Reputation) public reputations;
    
    event ReputationUpdated(address indexed participant);
    
    function updateReputation(
        address _participant,
        uint256 _rating,
        uint256 _valueProvided,
        uint256 _valueReceived
    ) external {
        // Only callable by ExchangeRegistry
        Reputation storage rep = reputations[_participant];
        rep.totalExchanges += 1;
        rep.totalRating += _rating;
        rep.totalValueProvided += _valueProvided;
        rep.totalValueReceived += _valueReceived;
        rep.lastActiveTimestamp = block.timestamp;
        
        emit ReputationUpdated(_participant);
    }
    
    function getAverageRating(address _participant) 
        external view returns (uint256) 
    {
        Reputation memory rep = reputations[_participant];
        if (rep.totalExchanges == 0) return 0;
        return (rep.totalRating * 100) / rep.totalExchanges; // Returns as percentage
    }
}
```

---

## Wallet Integration

### Connection Flow
```typescript
// Using wagmi/viem for Base
import { createConfig, http } from 'wagmi'
import { base } from 'wagmi/chains'
import { injected, coinbaseWallet } from 'wagmi/connectors'

const config = createConfig({
  chains: [base],
  connectors: [
    injected(),
    coinbaseWallet({ appName: 'OpenEconomy' })
  ],
  transports: {
    [base.id]: http()
  }
})
```

### Account Abstraction
For users without wallets:
```
1. User registers with email
2. We create embedded wallet (e.g., Privy, Dynamic)
3. Wallet address linked to account
4. User can later export/take custody
5. Gas abstracted via paymaster
```

---

## Hybrid Architecture

**Not everything goes on-chain.**

| Data | Location | Reason |
|------|----------|--------|
| Profile details | Firestore | Mutable, large |
| Messages | Firestore | Privacy, volume |
| Exchange proposals | Firestore | Negotiation |
| Completed exchanges | Blockchain | Immutable record |
| Reputation score | Blockchain | Trustless |
| Balance (credits) | Blockchain | Transparency |
| Skill categories | Firestore | Mutable taxonomy |
| Groups | Firestore | Privacy options |

---

## On-Chain Sync

### Exchange Completion Flow
```typescript
async function completeExchangeOnChain(exchange: Exchange) {
  // 1. Both parties confirmed in Firestore
  if (!exchange.providerConfirmed || !exchange.receiverConfirmed) {
    throw new Error('Not fully confirmed')
  }
  
  // 2. Generate deterministic ID
  const exchangeId = keccak256(
    encodePacked(['string', 'uint256'], [exchange.id, exchange.createdAt])
  )
  
  // 3. Record on-chain
  const tx = await exchangeRegistry.recordExchange(
    exchangeId,
    exchange.providerWallet,
    exchange.receiverWallet,
    parseEther(exchange.providerValue.toString()),
    parseEther(exchange.receiverValue.toString())
  )
  
  // 4. Wait for confirmation
  await tx.wait()
  
  // 5. Update Firestore with tx hash
  await updateDoc(doc(db, 'exchanges', exchange.id), {
    blockchainTxHash: tx.hash,
    onChain: true
  })
  
  // 6. Update reputation on-chain
  await updateReputationOnChain(exchange)
}
```

---

## Gas Strategy

**Users should never pay gas.**

Options:
1. **Paymaster** - We sponsor gas via account abstraction
2. **Relayer** - Backend submits transactions on behalf
3. **Batching** - Bundle multiple exchanges, submit hourly
4. **Lazy sync** - Record on-chain in batches, not real-time

**Recommended: Batching + Paymaster**
- Collect completed exchanges
- Every hour, batch submit to chain
- Use paymaster for sponsored transactions
- Cost: ~$50-100/month at moderate scale

---

## Privacy Considerations

**What's visible on-chain**:
- Wallet addresses (pseudonymous)
- Exchange values
- Timestamps
- Reputation scores

**What's NOT on-chain**:
- Real names
- Skills/services exchanged
- Messages
- Profile details

**Future: ZK proofs**
- Prove reputation without revealing history
- Prove exchange completion without details
- Private but verifiable

---

## Token Economics (Optional)

**OE Token - Governance Only**

```
NOT for:
- Speculation
- Required for exchanges
- Fee payment

FOR:
- Governance voting
- Dispute resolution voting
- Feature proposals
- Community treasury decisions

Distribution:
- 1 OE per completed exchange
- Cannot be bought, only earned
- 1 token = 1 vote
- No financial value by design
```

---

## Migration Plan

### Step 1: Deploy contracts (Week 1)
- Deploy ExchangeRegistry
- Deploy ReputationRegistry
- Test on testnet

### Step 2: Add wallet connection (Week 2)
- Add "Connect Wallet" option
- Link wallet to existing account
- Optional, not required

### Step 3: Shadow recording (Week 3-4)
- Record completed exchanges on-chain
- Sync reputation
- Users don't need to do anything

### Step 4: Verification UI (Week 5-6)
- Show "Verified on blockchain" badge
- Link to block explorer
- Display on-chain reputation

### Step 5: Full integration (Week 7-8)
- Reputation displayed from chain
- Exchange history from chain
- Wallet-only registration option

---

## Contracts Directory Structure

```
/contracts
  /src
    ExchangeRegistry.sol
    ReputationRegistry.sol
    GovernanceToken.sol (future)
  /test
    ExchangeRegistry.test.ts
    ReputationRegistry.test.ts
  /scripts
    deploy.ts
    verify.ts
  /deployments
    base-mainnet.json
    base-sepolia.json
  hardhat.config.ts
  foundry.toml
```

---

## Success Metrics

- 100% of completed exchanges recorded on-chain
- Wallet connection rate > 50%
- Zero gas costs for users
- Sub-second reputation queries
- Block explorer verification working
