// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ParticipantRegistry.sol";

/**
 * @title CommunityGovernance
 * @notice Manages communities, membership, and governance
 * @dev Supports multiple governance models from founder-led to democratic
 * 
 * PHILOSOPHY:
 * - Communities self-govern
 * - Roles are earned, not bought
 * - Transparency in all decisions
 */
contract CommunityGovernance {
    
    // ============ Enums ============
    
    enum CommunityType {
        Geographic,
        Professional,
        Interest,
        Organization,
        Cause
    }
    
    enum Visibility {
        Public,
        Unlisted,
        Private
    }
    
    enum JoinPolicy {
        Open,
        Approval,
        InviteOnly
    }
    
    enum GovernanceModel {
        FounderLed,
        AdminCouncil,
        Democratic,
        Consensus,
        Delegated
    }
    
    enum MemberRole {
        Member,
        Moderator,
        Admin,
        Founder
    }
    
    enum MemberStanding {
        Good,
        Warning,
        Suspended
    }
    
    enum ProposalStatus {
        Active,
        Passed,
        Rejected,
        Expired,
        Executed
    }
    
    // ============ Structs ============
    
    struct Community {
        uint256 id;
        string name;
        CommunityType communityType;
        Visibility visibility;
        JoinPolicy joinPolicy;
        GovernanceModel governance;
        
        // Governance params
        uint256 votingPeriodHours;
        uint256 quorumPercentage;      // 0-100
        uint256 approvalThreshold;      // 0-100
        
        // Stats
        uint256 memberCount;
        uint256 exchangeCount;
        
        // Cross-community
        bool allowExternalExchanges;
        
        // Meta
        address founder;
        uint256 createdAt;
        bool isActive;
    }
    
    struct Membership {
        uint256 communityId;
        address participant;
        MemberRole role;
        MemberStanding standing;
        uint256 exchangesInCommunity;
        uint256 warningCount;
        uint256 suspendedUntil;
        uint256 joinedAt;
        address invitedBy;
    }
    
    struct Proposal {
        uint256 id;
        uint256 communityId;
        string proposalType;      // 'settings', 'role', 'removal', 'policy'
        string description;
        address proposedBy;
        
        ProposalStatus status;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        
        uint256 createdAt;
        uint256 endsAt;
    }
    
    struct JoinRequest {
        uint256 communityId;
        address applicant;
        string message;
        uint256 requestedAt;
        bool processed;
        bool approved;
        address processedBy;
    }
    
    // ============ State Variables ============
    
    ParticipantRegistry public registry;
    
    // Communities
    mapping(uint256 => Community) public communities;
    uint256 public nextCommunityId;
    
    // Memberships: communityId => participant => Membership
    mapping(uint256 => mapping(address => Membership)) public memberships;
    mapping(uint256 => address[]) public communityMembers;
    
    // Join requests: communityId => applicant => JoinRequest
    mapping(uint256 => mapping(address => JoinRequest)) public joinRequests;
    mapping(uint256 => address[]) public pendingRequests;
    
    // Proposals
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public nextProposalId;
    
    // ============ Events ============
    
    event CommunityCreated(
        uint256 indexed communityId,
        string name,
        address indexed founder,
        CommunityType communityType
    );
    
    event MemberJoined(
        uint256 indexed communityId,
        address indexed participant,
        MemberRole role
    );
    
    event MemberLeft(
        uint256 indexed communityId,
        address indexed participant
    );
    
    event RoleChanged(
        uint256 indexed communityId,
        address indexed participant,
        MemberRole oldRole,
        MemberRole newRole,
        address changedBy
    );
    
    event StandingChanged(
        uint256 indexed communityId,
        address indexed participant,
        MemberStanding oldStanding,
        MemberStanding newStanding,
        string reason
    );
    
    event JoinRequestSubmitted(
        uint256 indexed communityId,
        address indexed applicant
    );
    
    event JoinRequestProcessed(
        uint256 indexed communityId,
        address indexed applicant,
        bool approved,
        address processedBy
    );
    
    event ProposalCreated(
        uint256 indexed proposalId,
        uint256 indexed communityId,
        string proposalType,
        address proposedBy
    );
    
    event VoteCast(
        uint256 indexed proposalId,
        address indexed voter,
        uint8 vote  // 0=against, 1=for, 2=abstain
    );
    
    event ProposalFinalized(
        uint256 indexed proposalId,
        ProposalStatus status
    );
    
    // ============ Constructor ============
    
    constructor(address _registryAddress) {
        registry = ParticipantRegistry(_registryAddress);
        nextCommunityId = 1;
        nextProposalId = 1;
    }
    
    // ============ Modifiers ============
    
    modifier onlyRegistered() {
        require(registry.isRegistered(msg.sender), "Not registered");
        _;
    }
    
    modifier communityExists(uint256 _communityId) {
        require(communities[_communityId].isActive, "Community not found");
        _;
    }
    
    modifier onlyMember(uint256 _communityId) {
        require(
            memberships[_communityId][msg.sender].role != MemberRole(0) ||
            memberships[_communityId][msg.sender].joinedAt > 0,
            "Not a member"
        );
        _;
    }
    
    modifier onlyModerator(uint256 _communityId) {
        MemberRole role = memberships[_communityId][msg.sender].role;
        require(
            role == MemberRole.Moderator ||
            role == MemberRole.Admin ||
            role == MemberRole.Founder,
            "Moderator access required"
        );
        _;
    }
    
    modifier onlyAdmin(uint256 _communityId) {
        MemberRole role = memberships[_communityId][msg.sender].role;
        require(
            role == MemberRole.Admin ||
            role == MemberRole.Founder,
            "Admin access required"
        );
        _;
    }
    
    modifier onlyFounder(uint256 _communityId) {
        require(
            memberships[_communityId][msg.sender].role == MemberRole.Founder,
            "Founder access required"
        );
        _;
    }
    
    modifier inGoodStanding(uint256 _communityId) {
        require(
            memberships[_communityId][msg.sender].standing == MemberStanding.Good,
            "Not in good standing"
        );
        _;
    }
    
    // ============ Community Management ============
    
    /**
     * @notice Create a new community
     * @param _name Community name
     * @param _communityType Type of community
     * @param _visibility Public/unlisted/private
     * @param _joinPolicy How members join
     * @param _governance Governance model
     */
    function createCommunity(
        string calldata _name,
        CommunityType _communityType,
        Visibility _visibility,
        JoinPolicy _joinPolicy,
        GovernanceModel _governance
    ) external onlyRegistered returns (uint256) {
        // Check if participant has 'create_communities' privilege (trusted+)
        ParticipantRegistry.Participant memory participant = registry.getParticipant(msg.sender);
        require(participant.endorsements >= 0, "Must be trusted tier"); // TODO: proper tier check
        
        uint256 communityId = nextCommunityId++;
        
        communities[communityId] = Community({
            id: communityId,
            name: _name,
            communityType: _communityType,
            visibility: _visibility,
            joinPolicy: _joinPolicy,
            governance: _governance,
            votingPeriodHours: 72,      // Default 3 days
            quorumPercentage: 20,       // Default 20%
            approvalThreshold: 51,      // Default simple majority
            memberCount: 1,
            exchangeCount: 0,
            allowExternalExchanges: true,
            founder: msg.sender,
            createdAt: block.timestamp,
            isActive: true
        });
        
        // Add founder as first member
        memberships[communityId][msg.sender] = Membership({
            communityId: communityId,
            participant: msg.sender,
            role: MemberRole.Founder,
            standing: MemberStanding.Good,
            exchangesInCommunity: 0,
            warningCount: 0,
            suspendedUntil: 0,
            joinedAt: block.timestamp,
            invitedBy: address(0)
        });
        
        communityMembers[communityId].push(msg.sender);
        
        emit CommunityCreated(communityId, _name, msg.sender, _communityType);
        emit MemberJoined(communityId, msg.sender, MemberRole.Founder);
        
        return communityId;
    }
    
    /**
     * @notice Join an open community directly
     */
    function joinCommunity(uint256 _communityId) 
        external 
        onlyRegistered 
        communityExists(_communityId) 
    {
        Community storage community = communities[_communityId];
        require(community.joinPolicy == JoinPolicy.Open, "Community requires approval");
        require(memberships[_communityId][msg.sender].joinedAt == 0, "Already a member");
        
        _addMember(_communityId, msg.sender, address(0));
    }
    
    /**
     * @notice Request to join a community that requires approval
     */
    function requestJoin(uint256 _communityId, string calldata _message)
        external
        onlyRegistered
        communityExists(_communityId)
    {
        Community storage community = communities[_communityId];
        require(
            community.joinPolicy == JoinPolicy.Approval ||
            community.joinPolicy == JoinPolicy.InviteOnly,
            "Community is open"
        );
        require(memberships[_communityId][msg.sender].joinedAt == 0, "Already a member");
        require(!joinRequests[_communityId][msg.sender].processed, "Request already exists");
        
        joinRequests[_communityId][msg.sender] = JoinRequest({
            communityId: _communityId,
            applicant: msg.sender,
            message: _message,
            requestedAt: block.timestamp,
            processed: false,
            approved: false,
            processedBy: address(0)
        });
        
        pendingRequests[_communityId].push(msg.sender);
        
        emit JoinRequestSubmitted(_communityId, msg.sender);
    }
    
    /**
     * @notice Approve or reject a join request
     */
    function processJoinRequest(
        uint256 _communityId,
        address _applicant,
        bool _approve
    ) 
        external 
        onlyModerator(_communityId)
        inGoodStanding(_communityId)
    {
        JoinRequest storage request = joinRequests[_communityId][_applicant];
        require(!request.processed, "Already processed");
        require(request.requestedAt > 0, "Request not found");
        
        request.processed = true;
        request.approved = _approve;
        request.processedBy = msg.sender;
        
        if (_approve) {
            _addMember(_communityId, _applicant, msg.sender);
        }
        
        emit JoinRequestProcessed(_communityId, _applicant, _approve, msg.sender);
    }
    
    /**
     * @notice Leave a community
     */
    function leaveCommunity(uint256 _communityId) 
        external 
        onlyMember(_communityId) 
    {
        Membership storage membership = memberships[_communityId][msg.sender];
        require(membership.role != MemberRole.Founder, "Founder must transfer ownership first");
        
        _removeMember(_communityId, msg.sender);
    }
    
    // ============ Role Management ============
    
    /**
     * @notice Change a member's role
     */
    function changeRole(
        uint256 _communityId,
        address _member,
        MemberRole _newRole
    )
        external
        communityExists(_communityId)
    {
        Membership storage targetMembership = memberships[_communityId][_member];
        require(targetMembership.joinedAt > 0, "Not a member");
        
        MemberRole callerRole = memberships[_communityId][msg.sender].role;
        MemberRole targetCurrentRole = targetMembership.role;
        
        // Only admins can promote to moderator
        // Only founders can promote to admin
        // Cannot demote someone of equal or higher rank
        if (_newRole == MemberRole.Moderator) {
            require(callerRole == MemberRole.Admin || callerRole == MemberRole.Founder, "Need admin");
        } else if (_newRole == MemberRole.Admin) {
            require(callerRole == MemberRole.Founder, "Need founder");
        } else if (_newRole == MemberRole.Founder) {
            revert("Use transferFoundership");
        }
        
        require(uint8(callerRole) > uint8(targetCurrentRole), "Cannot change equal/higher rank");
        
        emit RoleChanged(_communityId, _member, targetCurrentRole, _newRole, msg.sender);
        
        targetMembership.role = _newRole;
    }
    
    /**
     * @notice Transfer founder role to another admin
     */
    function transferFoundership(uint256 _communityId, address _newFounder)
        external
        onlyFounder(_communityId)
    {
        Membership storage newFounderMembership = memberships[_communityId][_newFounder];
        require(newFounderMembership.role == MemberRole.Admin, "Must be admin");
        require(newFounderMembership.standing == MemberStanding.Good, "Must be in good standing");
        
        MemberRole oldRole = newFounderMembership.role;
        newFounderMembership.role = MemberRole.Founder;
        memberships[_communityId][msg.sender].role = MemberRole.Admin;
        
        communities[_communityId].founder = _newFounder;
        
        emit RoleChanged(_communityId, _newFounder, oldRole, MemberRole.Founder, msg.sender);
        emit RoleChanged(_communityId, msg.sender, MemberRole.Founder, MemberRole.Admin, msg.sender);
    }
    
    // ============ Moderation ============
    
    /**
     * @notice Issue a warning to a member
     */
    function warnMember(
        uint256 _communityId,
        address _member,
        string calldata _reason
    )
        external
        onlyModerator(_communityId)
        inGoodStanding(_communityId)
    {
        Membership storage membership = memberships[_communityId][_member];
        require(membership.joinedAt > 0, "Not a member");
        require(uint8(membership.role) < uint8(memberships[_communityId][msg.sender].role), "Cannot warn equal/higher rank");
        
        MemberStanding oldStanding = membership.standing;
        membership.warningCount++;
        
        if (membership.warningCount >= 3) {
            membership.standing = MemberStanding.Warning;
        }
        
        emit StandingChanged(_communityId, _member, oldStanding, membership.standing, _reason);
    }
    
    /**
     * @notice Suspend a member
     */
    function suspendMember(
        uint256 _communityId,
        address _member,
        uint256 _durationDays,
        string calldata _reason
    )
        external
        onlyAdmin(_communityId)
        inGoodStanding(_communityId)
    {
        Membership storage membership = memberships[_communityId][_member];
        require(membership.joinedAt > 0, "Not a member");
        require(membership.role == MemberRole.Member, "Can only suspend members");
        
        MemberStanding oldStanding = membership.standing;
        membership.standing = MemberStanding.Suspended;
        membership.suspendedUntil = block.timestamp + (_durationDays * 1 days);
        
        emit StandingChanged(_communityId, _member, oldStanding, MemberStanding.Suspended, _reason);
    }
    
    /**
     * @notice Remove a member from community
     */
    function removeMember(
        uint256 _communityId,
        address _member,
        string calldata _reason
    )
        external
        onlyAdmin(_communityId)
        inGoodStanding(_communityId)
    {
        Membership storage membership = memberships[_communityId][_member];
        require(membership.joinedAt > 0, "Not a member");
        require(membership.role == MemberRole.Member, "Can only remove members");
        
        _removeMember(_communityId, _member);
    }
    
    // ============ Governance / Proposals ============
    
    /**
     * @notice Create a governance proposal
     */
    function createProposal(
        uint256 _communityId,
        string calldata _proposalType,
        string calldata _description
    )
        external
        onlyMember(_communityId)
        inGoodStanding(_communityId)
        returns (uint256)
    {
        Community storage community = communities[_communityId];
        
        // Check if caller can propose based on governance model
        MemberRole callerRole = memberships[_communityId][msg.sender].role;
        if (community.governance == GovernanceModel.FounderLed) {
            require(callerRole == MemberRole.Founder, "Only founder can propose");
        } else if (community.governance == GovernanceModel.AdminCouncil) {
            require(uint8(callerRole) >= uint8(MemberRole.Admin), "Only admins can propose");
        }
        // Democratic and Consensus: any member can propose
        
        uint256 proposalId = nextProposalId++;
        
        proposals[proposalId] = Proposal({
            id: proposalId,
            communityId: _communityId,
            proposalType: _proposalType,
            description: _description,
            proposedBy: msg.sender,
            status: ProposalStatus.Active,
            votesFor: 0,
            votesAgainst: 0,
            votesAbstain: 0,
            createdAt: block.timestamp,
            endsAt: block.timestamp + (community.votingPeriodHours * 1 hours)
        });
        
        emit ProposalCreated(proposalId, _communityId, _proposalType, msg.sender);
        
        return proposalId;
    }
    
    /**
     * @notice Vote on a proposal
     * @param _vote 0=against, 1=for, 2=abstain
     */
    function vote(uint256 _proposalId, uint8 _vote) external {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.status == ProposalStatus.Active, "Proposal not active");
        require(block.timestamp < proposal.endsAt, "Voting ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");
        
        uint256 communityId = proposal.communityId;
        Membership storage membership = memberships[communityId][msg.sender];
        require(membership.joinedAt > 0, "Not a member");
        require(membership.standing == MemberStanding.Good, "Not in good standing");
        
        Community storage community = communities[communityId];
        
        // Check voting rights based on governance model
        if (community.governance == GovernanceModel.AdminCouncil) {
            require(uint8(membership.role) >= uint8(MemberRole.Admin), "Only admins vote");
        }
        // Democratic and Consensus: all members vote
        
        hasVoted[_proposalId][msg.sender] = true;
        
        if (_vote == 0) {
            proposal.votesAgainst++;
        } else if (_vote == 1) {
            proposal.votesFor++;
        } else {
            proposal.votesAbstain++;
        }
        
        emit VoteCast(_proposalId, msg.sender, _vote);
    }
    
    /**
     * @notice Finalize a proposal after voting period
     */
    function finalizeProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.status == ProposalStatus.Active, "Not active");
        require(block.timestamp >= proposal.endsAt, "Voting not ended");
        
        Community storage community = communities[proposal.communityId];
        
        uint256 totalVotes = proposal.votesFor + proposal.votesAgainst + proposal.votesAbstain;
        uint256 requiredQuorum = (community.memberCount * community.quorumPercentage) / 100;
        
        if (totalVotes < requiredQuorum) {
            proposal.status = ProposalStatus.Expired;
        } else {
            uint256 approvalPercent = (proposal.votesFor * 100) / (proposal.votesFor + proposal.votesAgainst);
            
            uint256 threshold = community.approvalThreshold;
            if (community.governance == GovernanceModel.Consensus) {
                threshold = 80; // Consensus requires 80%
            }
            
            if (approvalPercent >= threshold) {
                proposal.status = ProposalStatus.Passed;
            } else {
                proposal.status = ProposalStatus.Rejected;
            }
        }
        
        emit ProposalFinalized(_proposalId, proposal.status);
    }
    
    // ============ Internal Functions ============
    
    function _addMember(
        uint256 _communityId,
        address _participant,
        address _invitedBy
    ) internal {
        memberships[_communityId][_participant] = Membership({
            communityId: _communityId,
            participant: _participant,
            role: MemberRole.Member,
            standing: MemberStanding.Good,
            exchangesInCommunity: 0,
            warningCount: 0,
            suspendedUntil: 0,
            joinedAt: block.timestamp,
            invitedBy: _invitedBy
        });
        
        communityMembers[_communityId].push(_participant);
        communities[_communityId].memberCount++;
        
        emit MemberJoined(_communityId, _participant, MemberRole.Member);
    }
    
    function _removeMember(uint256 _communityId, address _participant) internal {
        delete memberships[_communityId][_participant];
        communities[_communityId].memberCount--;
        
        // Remove from array (gas expensive but necessary for enumeration)
        address[] storage members = communityMembers[_communityId];
        for (uint i = 0; i < members.length; i++) {
            if (members[i] == _participant) {
                members[i] = members[members.length - 1];
                members.pop();
                break;
            }
        }
        
        emit MemberLeft(_communityId, _participant);
    }
    
    // ============ View Functions ============
    
    function getCommunity(uint256 _communityId) external view returns (Community memory) {
        return communities[_communityId];
    }
    
    function getMembership(uint256 _communityId, address _participant) 
        external view returns (Membership memory) 
    {
        return memberships[_communityId][_participant];
    }
    
    function getCommunityMembers(uint256 _communityId) external view returns (address[] memory) {
        return communityMembers[_communityId];
    }
    
    function getProposal(uint256 _proposalId) external view returns (Proposal memory) {
        return proposals[_proposalId];
    }
    
    function isMember(uint256 _communityId, address _participant) external view returns (bool) {
        return memberships[_communityId][_participant].joinedAt > 0;
    }
    
    function getJoinRequest(uint256 _communityId, address _applicant) 
        external view returns (JoinRequest memory) 
    {
        return joinRequests[_communityId][_applicant];
    }
}
