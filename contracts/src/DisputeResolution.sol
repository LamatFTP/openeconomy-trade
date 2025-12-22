// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ParticipantRegistry.sol";
import "./ExchangeProtocol.sol";

/**
 * @title DisputeResolution
 * @notice Manages dispute lifecycle: self-resolution → mediation → council
 * @dev Three-level escalation with community-driven resolution
 * 
 * PHILOSOPHY:
 * - Encourage self-resolution first
 * - Neutral mediators from verified tier
 * - Champion council as final authority
 * - Transparent, recorded decisions
 */
contract DisputeResolution {
    
    // ============ Enums ============
    
    enum DisputeType {
        NonCompletion,        // Work not done
        Quality,              // Poor quality
        TimeDiscrepancy,      // Hours dispute
        Communication,        // Ghosting
        Misrepresentation,    // Not as described
        Behavior,             // Inappropriate conduct
        Other
    }
    
    enum DisputeStatus {
        SelfResolution,       // Level 1: 48 hours
        Mediation,            // Level 2: 5 days
        CouncilReview,        // Level 3: 7 days
        Resolved,
        Expired
    }
    
    enum Resolution {
        None,
        Voided,               // Exchange cancelled, no credit change
        PartialCredit,        // Adjusted credit
        FullCredit,           // Original credit stands
        ProviderFavor,        // Decided for provider
        ReceiverFavor         // Decided for receiver
    }
    
    enum Sanction {
        None,
        Warning,              // Note on profile
        Suspension30d,        // 30-day freeze
        CommunityRemoval,     // Removed from community
        ProtocolBan           // Global ban (extreme)
    }
    
    // ============ Structs ============
    
    struct Dispute {
        uint256 id;
        uint256 exchangeId;
        
        // Parties
        address raisedBy;
        address respondent;
        
        // Details
        DisputeType disputeType;
        string description;
        
        // Statements
        string raisedByStatement;
        string respondentStatement;
        
        // Status
        DisputeStatus status;
        uint8 level;          // 1, 2, or 3
        
        // Level 2: Mediation
        address mediator;
        string mediatorProposal;
        bool raisedByAccepts;
        bool respondentAccepts;
        
        // Level 3: Council
        address[3] councilMembers;
        Resolution[3] councilVotes;
        Sanction[3] councilSanctions;
        uint8 councilVoteCount;
        
        // Outcome
        Resolution resolution;
        int256 creditAdjustment;
        Sanction sanction;
        address sanctionedParticipant;
        
        // Timing
        uint256 createdAt;
        uint256 level1Deadline;    // 48 hours
        uint256 level2Deadline;    // +5 days
        uint256 level3Deadline;    // +7 days
        uint256 resolvedAt;
    }
    
    struct MediatorProfile {
        address mediator;
        uint256 disputesMediated;
        uint256 successfulResolutions;
        uint256 lastActiveAt;
        bool isActive;
    }
    
    // ============ Constants ============
    
    uint256 public constant LEVEL_1_DURATION = 48 hours;
    uint256 public constant LEVEL_2_DURATION = 5 days;
    uint256 public constant LEVEL_3_DURATION = 7 days;
    
    uint256 public constant MIN_MEDIATOR_EXCHANGES = 20;
    uint256 public constant MIN_MEDIATOR_RATING = 450; // 4.5 * 100
    
    uint256 public constant MIN_COUNCIL_EXCHANGES = 50;
    uint256 public constant MIN_COUNCIL_RATING = 480;  // 4.8 * 100
    
    // ============ State Variables ============
    
    ParticipantRegistry public registry;
    ExchangeProtocol public exchangeProtocol;
    
    mapping(uint256 => Dispute) public disputes;
    mapping(uint256 => bool) public exchangeHasDispute;  // exchangeId => hasDispute
    
    mapping(address => MediatorProfile) public mediatorProfiles;
    address[] public mediatorPool;
    
    address[] public councilPool;  // Champions eligible for council
    
    uint256 public nextDisputeId;
    uint256 public totalDisputes;
    uint256 public resolvedDisputes;
    
    // ============ Events ============
    
    event DisputeRaised(
        uint256 indexed disputeId,
        uint256 indexed exchangeId,
        address indexed raisedBy,
        DisputeType disputeType
    );
    
    event StatementSubmitted(
        uint256 indexed disputeId,
        address indexed submitter,
        bool isRespondent
    );
    
    event DisputeEscalated(
        uint256 indexed disputeId,
        uint8 fromLevel,
        uint8 toLevel
    );
    
    event MediatorAssigned(
        uint256 indexed disputeId,
        address indexed mediator
    );
    
    event MediatorProposalSubmitted(
        uint256 indexed disputeId,
        string proposal
    );
    
    event ProposalResponse(
        uint256 indexed disputeId,
        address indexed responder,
        bool accepted
    );
    
    event CouncilMemberAssigned(
        uint256 indexed disputeId,
        address indexed member,
        uint8 seat
    );
    
    event CouncilVoteSubmitted(
        uint256 indexed disputeId,
        address indexed member,
        Resolution resolution,
        Sanction sanction
    );
    
    event DisputeResolved(
        uint256 indexed disputeId,
        Resolution resolution,
        Sanction sanction,
        address sanctionedParticipant
    );
    
    event MediatorRegistered(address indexed mediator);
    event ChampionRegistered(address indexed champion);
    
    // ============ Constructor ============
    
    constructor(address _registryAddress, address _exchangeAddress) {
        registry = ParticipantRegistry(_registryAddress);
        exchangeProtocol = ExchangeProtocol(_exchangeAddress);
        nextDisputeId = 1;
    }
    
    // ============ Modifiers ============
    
    modifier onlyRegistered() {
        require(registry.isRegistered(msg.sender), "Not registered");
        _;
    }
    
    modifier disputeExists(uint256 _disputeId) {
        require(_disputeId > 0 && _disputeId < nextDisputeId, "Dispute not found");
        _;
    }
    
    modifier onlyParty(uint256 _disputeId) {
        Dispute storage d = disputes[_disputeId];
        require(
            msg.sender == d.raisedBy || msg.sender == d.respondent,
            "Not a party to this dispute"
        );
        _;
    }
    
    modifier onlyMediator(uint256 _disputeId) {
        require(disputes[_disputeId].mediator == msg.sender, "Not the mediator");
        _;
    }
    
    modifier onlyCouncil(uint256 _disputeId) {
        Dispute storage d = disputes[_disputeId];
        require(
            msg.sender == d.councilMembers[0] ||
            msg.sender == d.councilMembers[1] ||
            msg.sender == d.councilMembers[2],
            "Not on the council"
        );
        _;
    }
    
    modifier inStatus(uint256 _disputeId, DisputeStatus _status) {
        require(disputes[_disputeId].status == _status, "Invalid dispute status");
        _;
    }
    
    // ============ Dispute Lifecycle ============
    
    /**
     * @notice Raise a dispute against an exchange
     */
    function raiseDispute(
        uint256 _exchangeId,
        DisputeType _type,
        string calldata _description,
        string calldata _statement
    ) external onlyRegistered returns (uint256) {
        // Verify exchange exists and caller is a party
        ExchangeProtocol.Exchange memory exchange = exchangeProtocol.getExchange(_exchangeId);
        require(
            exchange.state == ExchangeProtocol.ExchangeState.Accepted ||
            exchange.state == ExchangeProtocol.ExchangeState.ProviderCompleted,
            "Exchange not in disputable state"
        );
        require(
            msg.sender == exchange.provider || msg.sender == exchange.receiver,
            "Not a party to this exchange"
        );
        require(!exchangeHasDispute[_exchangeId], "Dispute already exists");
        
        address respondent = msg.sender == exchange.provider ? 
            exchange.receiver : exchange.provider;
        
        uint256 disputeId = nextDisputeId++;
        
        disputes[disputeId] = Dispute({
            id: disputeId,
            exchangeId: _exchangeId,
            raisedBy: msg.sender,
            respondent: respondent,
            disputeType: _type,
            description: _description,
            raisedByStatement: _statement,
            respondentStatement: "",
            status: DisputeStatus.SelfResolution,
            level: 1,
            mediator: address(0),
            mediatorProposal: "",
            raisedByAccepts: false,
            respondentAccepts: false,
            councilMembers: [address(0), address(0), address(0)],
            councilVotes: [Resolution.None, Resolution.None, Resolution.None],
            councilSanctions: [Sanction.None, Sanction.None, Sanction.None],
            councilVoteCount: 0,
            resolution: Resolution.None,
            creditAdjustment: 0,
            sanction: Sanction.None,
            sanctionedParticipant: address(0),
            createdAt: block.timestamp,
            level1Deadline: block.timestamp + LEVEL_1_DURATION,
            level2Deadline: 0,
            level3Deadline: 0,
            resolvedAt: 0
        });
        
        exchangeHasDispute[_exchangeId] = true;
        totalDisputes++;
        
        // Mark exchange as disputed
        exchangeProtocol.disputeExchange(_exchangeId, _description);
        
        emit DisputeRaised(disputeId, _exchangeId, msg.sender, _type);
        
        return disputeId;
    }
    
    /**
     * @notice Respondent submits their statement
     */
    function submitStatement(uint256 _disputeId, string calldata _statement)
        external
        disputeExists(_disputeId)
    {
        Dispute storage d = disputes[_disputeId];
        require(msg.sender == d.respondent, "Only respondent");
        require(bytes(d.respondentStatement).length == 0, "Already submitted");
        
        d.respondentStatement = _statement;
        
        emit StatementSubmitted(_disputeId, msg.sender, true);
    }
    
    /**
     * @notice Parties agree to resolve the dispute themselves
     */
    function markSelfResolved(uint256 _disputeId, Resolution _resolution)
        external
        disputeExists(_disputeId)
        onlyParty(_disputeId)
        inStatus(_disputeId, DisputeStatus.SelfResolution)
    {
        Dispute storage d = disputes[_disputeId];
        
        if (msg.sender == d.raisedBy) {
            d.raisedByAccepts = true;
        } else {
            d.respondentAccepts = true;
        }
        
        // Both must agree
        if (d.raisedByAccepts && d.respondentAccepts) {
            _resolveDispute(_disputeId, _resolution, Sanction.None, address(0), 0);
        }
    }
    
    /**
     * @notice Escalate to mediation (Level 2)
     */
    function escalateToMediation(uint256 _disputeId)
        external
        disputeExists(_disputeId)
        onlyParty(_disputeId)
        inStatus(_disputeId, DisputeStatus.SelfResolution)
    {
        Dispute storage d = disputes[_disputeId];
        require(block.timestamp >= d.level1Deadline, "Level 1 not expired");
        
        d.status = DisputeStatus.Mediation;
        d.level = 2;
        d.level2Deadline = block.timestamp + LEVEL_2_DURATION;
        
        // Auto-assign mediator from pool
        _assignMediator(_disputeId);
        
        emit DisputeEscalated(_disputeId, 1, 2);
    }
    
    /**
     * @notice Mediator submits resolution proposal
     */
    function submitMediatorProposal(
        uint256 _disputeId,
        string calldata _proposal
    )
        external
        disputeExists(_disputeId)
        onlyMediator(_disputeId)
        inStatus(_disputeId, DisputeStatus.Mediation)
    {
        Dispute storage d = disputes[_disputeId];
        require(bytes(d.mediatorProposal).length == 0, "Proposal already submitted");
        
        d.mediatorProposal = _proposal;
        d.raisedByAccepts = false;
        d.respondentAccepts = false;
        
        emit MediatorProposalSubmitted(_disputeId, _proposal);
    }
    
    /**
     * @notice Party responds to mediator proposal
     */
    function respondToProposal(uint256 _disputeId, bool _accept)
        external
        disputeExists(_disputeId)
        onlyParty(_disputeId)
        inStatus(_disputeId, DisputeStatus.Mediation)
    {
        Dispute storage d = disputes[_disputeId];
        require(bytes(d.mediatorProposal).length > 0, "No proposal yet");
        
        if (msg.sender == d.raisedBy) {
            d.raisedByAccepts = _accept;
        } else {
            d.respondentAccepts = _accept;
        }
        
        emit ProposalResponse(_disputeId, msg.sender, _accept);
        
        // If both accept, resolve
        if (d.raisedByAccepts && d.respondentAccepts) {
            _resolveDispute(_disputeId, Resolution.PartialCredit, Sanction.None, address(0), 0);
            
            // Update mediator stats
            mediatorProfiles[d.mediator].successfulResolutions++;
        }
    }
    
    /**
     * @notice Escalate to council (Level 3)
     */
    function escalateToCouncil(uint256 _disputeId)
        external
        disputeExists(_disputeId)
        onlyParty(_disputeId)
        inStatus(_disputeId, DisputeStatus.Mediation)
    {
        Dispute storage d = disputes[_disputeId];
        require(
            block.timestamp >= d.level2Deadline ||
            (!d.raisedByAccepts || !d.respondentAccepts),
            "Cannot escalate yet"
        );
        
        d.status = DisputeStatus.CouncilReview;
        d.level = 3;
        d.level3Deadline = block.timestamp + LEVEL_3_DURATION;
        
        // Assign 3 council members
        _assignCouncil(_disputeId);
        
        emit DisputeEscalated(_disputeId, 2, 3);
    }
    
    /**
     * @notice Council member submits vote
     */
    function submitCouncilVote(
        uint256 _disputeId,
        Resolution _resolution,
        Sanction _sanction,
        address _sanctionTarget,
        int256 _creditAdjustment
    )
        external
        disputeExists(_disputeId)
        onlyCouncil(_disputeId)
        inStatus(_disputeId, DisputeStatus.CouncilReview)
    {
        Dispute storage d = disputes[_disputeId];
        
        // Find council member's seat
        uint8 seat = 255;
        for (uint8 i = 0; i < 3; i++) {
            if (d.councilMembers[i] == msg.sender) {
                seat = i;
                break;
            }
        }
        require(seat < 3, "Not on council");
        require(d.councilVotes[seat] == Resolution.None, "Already voted");
        
        d.councilVotes[seat] = _resolution;
        d.councilSanctions[seat] = _sanction;
        d.councilVoteCount++;
        
        emit CouncilVoteSubmitted(_disputeId, msg.sender, _resolution, _sanction);
        
        // If all 3 voted, finalize
        if (d.councilVoteCount == 3) {
            _finalizeCouncilDecision(_disputeId);
        }
    }
    
    // ============ Mediator / Council Registration ============
    
    /**
     * @notice Register as a mediator (requires verified tier)
     */
    function registerAsMediator() external onlyRegistered {
        ParticipantRegistry.Participant memory p = registry.getParticipant(msg.sender);
        // TODO: Add proper tier check from reputation
        require(p.endorsements >= 5, "Need verified tier");
        require(!mediatorProfiles[msg.sender].isActive, "Already registered");
        
        mediatorProfiles[msg.sender] = MediatorProfile({
            mediator: msg.sender,
            disputesMediated: 0,
            successfulResolutions: 0,
            lastActiveAt: block.timestamp,
            isActive: true
        });
        
        mediatorPool.push(msg.sender);
        
        emit MediatorRegistered(msg.sender);
    }
    
    /**
     * @notice Register as council member (requires champion tier)
     */
    function registerAsCouncil() external onlyRegistered {
        ParticipantRegistry.Participant memory p = registry.getParticipant(msg.sender);
        // TODO: Add proper tier check
        require(p.endorsements >= 10, "Need champion tier");
        
        // Check not already in pool
        for (uint i = 0; i < councilPool.length; i++) {
            require(councilPool[i] != msg.sender, "Already registered");
        }
        
        councilPool.push(msg.sender);
        
        emit ChampionRegistered(msg.sender);
    }
    
    // ============ Internal Functions ============
    
    function _assignMediator(uint256 _disputeId) internal {
        Dispute storage d = disputes[_disputeId];
        
        // Find eligible mediator (not involved with either party)
        for (uint i = 0; i < mediatorPool.length; i++) {
            address candidate = mediatorPool[i];
            if (
                candidate != d.raisedBy &&
                candidate != d.respondent &&
                mediatorProfiles[candidate].isActive
            ) {
                d.mediator = candidate;
                mediatorProfiles[candidate].disputesMediated++;
                mediatorProfiles[candidate].lastActiveAt = block.timestamp;
                
                emit MediatorAssigned(_disputeId, candidate);
                return;
            }
        }
        
        // If no mediator available, auto-escalate to council
        d.status = DisputeStatus.CouncilReview;
        d.level = 3;
        d.level3Deadline = block.timestamp + LEVEL_3_DURATION;
        _assignCouncil(_disputeId);
    }
    
    function _assignCouncil(uint256 _disputeId) internal {
        Dispute storage d = disputes[_disputeId];
        
        uint8 assigned = 0;
        for (uint i = 0; i < councilPool.length && assigned < 3; i++) {
            address candidate = councilPool[i];
            if (
                candidate != d.raisedBy &&
                candidate != d.respondent &&
                candidate != d.mediator
            ) {
                d.councilMembers[assigned] = candidate;
                emit CouncilMemberAssigned(_disputeId, candidate, assigned);
                assigned++;
            }
        }
        
        require(assigned == 3, "Not enough council members");
    }
    
    function _finalizeCouncilDecision(uint256 _disputeId) internal {
        Dispute storage d = disputes[_disputeId];
        
        // Count votes for each resolution
        uint8[6] memory resolutionCounts;
        uint8[5] memory sanctionCounts;
        
        for (uint8 i = 0; i < 3; i++) {
            resolutionCounts[uint8(d.councilVotes[i])]++;
            sanctionCounts[uint8(d.councilSanctions[i])]++;
        }
        
        // Find majority resolution (at least 2 votes)
        Resolution finalResolution = Resolution.Voided; // Default
        for (uint8 i = 1; i < 6; i++) {
            if (resolutionCounts[i] >= 2) {
                finalResolution = Resolution(i);
                break;
            }
        }
        
        // Find majority sanction
        Sanction finalSanction = Sanction.None;
        for (uint8 i = 1; i < 5; i++) {
            if (sanctionCounts[i] >= 2) {
                finalSanction = Sanction(i);
                break;
            }
        }
        
        // Determine who gets sanctioned (if applicable)
        address sanctioned = address(0);
        if (finalSanction != Sanction.None) {
            // If resolution favors one party, sanction the other
            if (finalResolution == Resolution.ProviderFavor) {
                sanctioned = d.respondent;
            } else if (finalResolution == Resolution.ReceiverFavor) {
                // Need to know who is provider/receiver from exchange
                ExchangeProtocol.Exchange memory exchange = 
                    exchangeProtocol.getExchange(d.exchangeId);
                sanctioned = d.raisedBy == exchange.provider ? 
                    d.raisedBy : d.respondent;
            }
        }
        
        _resolveDispute(_disputeId, finalResolution, finalSanction, sanctioned, 0);
    }
    
    function _resolveDispute(
        uint256 _disputeId,
        Resolution _resolution,
        Sanction _sanction,
        address _sanctioned,
        int256 _creditAdjustment
    ) internal {
        Dispute storage d = disputes[_disputeId];
        
        d.status = DisputeStatus.Resolved;
        d.resolution = _resolution;
        d.sanction = _sanction;
        d.sanctionedParticipant = _sanctioned;
        d.creditAdjustment = _creditAdjustment;
        d.resolvedAt = block.timestamp;
        
        resolvedDisputes++;
        
        // Apply credit adjustments if needed
        if (_creditAdjustment != 0) {
            ExchangeProtocol.Exchange memory exchange = 
                exchangeProtocol.getExchange(d.exchangeId);
            
            // Adjust credits based on resolution
            registry.updateCreditBalance(
                exchange.provider,
                _creditAdjustment,
                string(abi.encodePacked("Dispute #", _uint2str(d.id), " resolution"))
            );
            registry.updateCreditBalance(
                exchange.receiver,
                -_creditAdjustment,
                string(abi.encodePacked("Dispute #", _uint2str(d.id), " resolution"))
            );
        }
        
        emit DisputeResolved(_disputeId, _resolution, _sanction, _sanctioned);
    }
    
    function _uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bstr[k] = bytes1(temp);
            _i /= 10;
        }
        return string(bstr);
    }
    
    // ============ View Functions ============
    
    function getDispute(uint256 _disputeId) external view returns (Dispute memory) {
        return disputes[_disputeId];
    }
    
    function getMediatorProfile(address _mediator) external view returns (MediatorProfile memory) {
        return mediatorProfiles[_mediator];
    }
    
    function getMediatorPoolSize() external view returns (uint256) {
        return mediatorPool.length;
    }
    
    function getCouncilPoolSize() external view returns (uint256) {
        return councilPool.length;
    }
    
    function getDisputeStats() external view returns (
        uint256 total,
        uint256 resolved,
        uint256 pending
    ) {
        return (totalDisputes, resolvedDisputes, totalDisputes - resolvedDisputes);
    }
}
