// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ParticipantRegistry
 * @notice Core registry for OpenEconomy participants
 * @dev Manages participant profiles, value baselines, and skill tags
 * 
 * PHILOSOPHY:
 * - Self-sovereign: Users control their own data
 * - Transparent: All baselines visible for fair exchange
 * - Inclusive: No barriers to registration
 */
contract ParticipantRegistry {
    
    // ============ Structs ============
    
    struct Participant {
        address wallet;
        string displayName;
        uint256 hourlyBaselineCents;  // In cents (2000 = $20.00)
        uint256 endorsements;
        int256 creditBalanceCents;    // Can be negative
        uint256 createdAt;
        uint256 updatedAt;
        bool isActive;
    }
    
    // ============ State Variables ============
    
    mapping(address => Participant) public participants;
    mapping(address => string[]) public participantSkills;
    mapping(address => mapping(address => bool)) public hasEndorsed;
    
    address[] public allParticipants;
    uint256 public totalParticipants;
    
    // ============ Events ============
    
    event ParticipantRegistered(
        address indexed wallet,
        string displayName,
        uint256 hourlyBaselineCents
    );
    
    event BaselineUpdated(
        address indexed wallet,
        uint256 oldBaseline,
        uint256 newBaseline
    );
    
    event SkillAdded(
        address indexed wallet,
        string skill
    );
    
    event ParticipantEndorsed(
        address indexed endorser,
        address indexed endorsed
    );
    
    event CreditBalanceUpdated(
        address indexed wallet,
        int256 oldBalance,
        int256 newBalance,
        string reason
    );
    
    // ============ Modifiers ============
    
    modifier onlyRegistered() {
        require(participants[msg.sender].isActive, "Not registered");
        _;
    }
    
    modifier validParticipant(address _wallet) {
        require(participants[_wallet].isActive, "Participant not found");
        _;
    }
    
    // ============ Registration ============
    
    /**
     * @notice Register as a new participant
     * @param _displayName Human-readable name
     * @param _hourlyBaselineCents Self-declared hourly value in cents
     * @param _skills Initial skill tags
     */
    function register(
        string calldata _displayName,
        uint256 _hourlyBaselineCents,
        string[] calldata _skills
    ) external {
        require(!participants[msg.sender].isActive, "Already registered");
        require(bytes(_displayName).length > 0, "Name required");
        require(_hourlyBaselineCents >= 100, "Minimum baseline: $1.00");
        require(_hourlyBaselineCents <= 100000, "Maximum baseline: $1000.00");
        
        participants[msg.sender] = Participant({
            wallet: msg.sender,
            displayName: _displayName,
            hourlyBaselineCents: _hourlyBaselineCents,
            endorsements: 0,
            creditBalanceCents: 0,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            isActive: true
        });
        
        // Add initial skills
        for (uint i = 0; i < _skills.length && i < 10; i++) {
            if (bytes(_skills[i]).length > 0) {
                participantSkills[msg.sender].push(_skills[i]);
                emit SkillAdded(msg.sender, _skills[i]);
            }
        }
        
        allParticipants.push(msg.sender);
        totalParticipants++;
        
        emit ParticipantRegistered(msg.sender, _displayName, _hourlyBaselineCents);
    }
    
    // ============ Profile Management ============
    
    /**
     * @notice Update hourly baseline
     * @param _newBaselineCents New hourly value in cents
     */
    function updateBaseline(uint256 _newBaselineCents) external onlyRegistered {
        require(_newBaselineCents >= 100, "Minimum baseline: $1.00");
        require(_newBaselineCents <= 100000, "Maximum baseline: $1000.00");
        
        uint256 oldBaseline = participants[msg.sender].hourlyBaselineCents;
        participants[msg.sender].hourlyBaselineCents = _newBaselineCents;
        participants[msg.sender].updatedAt = block.timestamp;
        
        emit BaselineUpdated(msg.sender, oldBaseline, _newBaselineCents);
    }
    
    /**
     * @notice Add a skill tag
     * @param _skill Skill description
     */
    function addSkill(string calldata _skill) external onlyRegistered {
        require(bytes(_skill).length > 0, "Skill cannot be empty");
        require(participantSkills[msg.sender].length < 20, "Max 20 skills");
        
        participantSkills[msg.sender].push(_skill);
        participants[msg.sender].updatedAt = block.timestamp;
        
        emit SkillAdded(msg.sender, _skill);
    }
    
    /**
     * @notice Endorse another participant's value
     * @param _participant Address to endorse
     */
    function endorse(address _participant) external onlyRegistered validParticipant(_participant) {
        require(_participant != msg.sender, "Cannot endorse self");
        require(!hasEndorsed[msg.sender][_participant], "Already endorsed");
        
        hasEndorsed[msg.sender][_participant] = true;
        participants[_participant].endorsements++;
        
        emit ParticipantEndorsed(msg.sender, _participant);
    }
    
    // ============ Credit Balance (Called by ExchangeProtocol) ============
    
    /**
     * @notice Update credit balance after exchange
     * @param _wallet Participant wallet
     * @param _delta Amount to add (can be negative)
     * @param _reason Description of the adjustment
     * @dev Only callable by authorized contracts (ExchangeProtocol)
     */
    function updateCreditBalance(
        address _wallet,
        int256 _delta,
        string calldata _reason
    ) external validParticipant(_wallet) {
        // TODO: Add access control for ExchangeProtocol only
        
        int256 oldBalance = participants[_wallet].creditBalanceCents;
        participants[_wallet].creditBalanceCents += _delta;
        
        emit CreditBalanceUpdated(
            _wallet,
            oldBalance,
            participants[_wallet].creditBalanceCents,
            _reason
        );
    }
    
    // ============ View Functions ============
    
    function getParticipant(address _wallet) external view returns (Participant memory) {
        return participants[_wallet];
    }
    
    function getSkills(address _wallet) external view returns (string[] memory) {
        return participantSkills[_wallet];
    }
    
    function getAllParticipants() external view returns (address[] memory) {
        return allParticipants;
    }
    
    function isRegistered(address _wallet) external view returns (bool) {
        return participants[_wallet].isActive;
    }
}
