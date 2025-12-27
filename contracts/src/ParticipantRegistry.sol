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

    // Access control for credit balance updates
    mapping(address => bool) public authorizedContracts;
    address public owner;
    
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

    event ContractAuthorized(
        address indexed contractAddress,
        bool authorized
    );

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    // ============ Constructor ============

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedContracts[msg.sender], "Not authorized");
        _;
    }
    
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
    
    // ============ Access Control Management ============

    /**
     * @notice Authorize a contract to update credit balances
     * @param _contract Address of the contract to authorize
     * @dev Only callable by owner (typically set to governance contract later)
     */
    function authorizeContract(address _contract) external onlyOwner {
        require(_contract != address(0), "Invalid address");
        require(!authorizedContracts[_contract], "Already authorized");

        authorizedContracts[_contract] = true;
        emit ContractAuthorized(_contract, true);
    }

    /**
     * @notice Revoke a contract's authorization to update credit balances
     * @param _contract Address of the contract to unauthorize
     */
    function unauthorizeContract(address _contract) external onlyOwner {
        require(authorizedContracts[_contract], "Not authorized");

        authorizedContracts[_contract] = false;
        emit ContractAuthorized(_contract, false);
    }

    /**
     * @notice Transfer ownership to a new address
     * @param _newOwner Address of the new owner
     * @dev Can be used to transfer control to a governance contract
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        require(_newOwner != owner, "Already owner");

        address previousOwner = owner;
        owner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    // ============ Credit Balance (Called by ExchangeProtocol) ============

    /**
     * @notice Update credit balance after exchange
     * @param _wallet Participant wallet
     * @param _delta Amount to add (can be negative)
     * @param _reason Description of the adjustment
     * @dev Only callable by authorized contracts (ExchangeProtocol, DisputeResolution)
     */
    function updateCreditBalance(
        address _wallet,
        int256 _delta,
        string calldata _reason
    ) external onlyAuthorized validParticipant(_wallet) {
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

    function isAuthorized(address _contract) external view returns (bool) {
        return authorizedContracts[_contract];
    }
}
