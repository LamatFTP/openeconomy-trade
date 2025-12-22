// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ParticipantRegistry.sol";

/**
 * @title ExchangeProtocol
 * @notice Manages skill/service exchanges between participants
 * @dev Handles full exchange lifecycle: propose → accept → complete → confirm
 * 
 * PHILOSOPHY:
 * - Fair: Value calculated from provider's baseline
 * - Trustless: Blockchain records all exchanges
 * - Flexible: No strict timelines, community-based trust
 */
contract ExchangeProtocol {
    
    // ============ Enums ============
    
    enum ExchangeState {
        Proposed,           // Provider proposed, waiting for receiver
        Accepted,           // Receiver accepted, exchange in progress
        ProviderCompleted,  // Provider marked as done
        Confirmed,          // Receiver confirmed, exchange complete
        Cancelled,          // Cancelled before completion
        Disputed            // In dispute resolution
    }
    
    // ============ Structs ============
    
    struct Exchange {
        uint256 id;
        address provider;           // Who provides the service
        address receiver;           // Who receives the service
        string serviceDescription;  // What's being exchanged
        uint256 hoursEstimate;      // Estimated hours (× 100 for decimals)
        uint256 valueCents;         // Total value (hours × provider baseline)
        ExchangeState state;
        uint256 createdAt;
        uint256 acceptedAt;
        uint256 completedAt;
        uint256 confirmedAt;
        string disputeReason;
    }
    
    // ============ State Variables ============
    
    ParticipantRegistry public registry;
    
    mapping(uint256 => Exchange) public exchanges;
    mapping(address => uint256[]) public participantExchanges;
    
    uint256 public nextExchangeId;
    uint256 public totalExchangesCompleted;
    uint256 public totalValueExchanged;
    
    // ============ Events ============
    
    event ExchangeProposed(
        uint256 indexed exchangeId,
        address indexed provider,
        address indexed receiver,
        string serviceDescription,
        uint256 valueCents
    );
    
    event ExchangeAccepted(
        uint256 indexed exchangeId,
        address indexed receiver
    );
    
    event ExchangeCompleted(
        uint256 indexed exchangeId,
        address indexed provider
    );
    
    event ExchangeConfirmed(
        uint256 indexed exchangeId,
        address indexed receiver,
        uint256 valueCents
    );
    
    event ExchangeCancelled(
        uint256 indexed exchangeId,
        address indexed cancelledBy,
        string reason
    );
    
    event ExchangeDisputed(
        uint256 indexed exchangeId,
        address indexed disputedBy,
        string reason
    );
    
    // ============ Constructor ============
    
    constructor(address _registryAddress) {
        registry = ParticipantRegistry(_registryAddress);
        nextExchangeId = 1;
    }
    
    // ============ Modifiers ============
    
    modifier onlyRegistered() {
        require(registry.isRegistered(msg.sender), "Not registered");
        _;
    }
    
    modifier exchangeExists(uint256 _exchangeId) {
        require(_exchangeId > 0 && _exchangeId < nextExchangeId, "Exchange not found");
        _;
    }
    
    modifier inState(uint256 _exchangeId, ExchangeState _state) {
        require(exchanges[_exchangeId].state == _state, "Invalid exchange state");
        _;
    }
    
    // ============ Core Functions ============
    
    /**
     * @notice Propose a new exchange
     * @param _receiver Who will receive the service
     * @param _serviceDescription What you'll provide
     * @param _hoursEstimate Estimated hours (× 100, e.g., 250 = 2.5 hours)
     */
    function proposeExchange(
        address _receiver,
        string calldata _serviceDescription,
        uint256 _hoursEstimate
    ) external onlyRegistered returns (uint256) {
        require(registry.isRegistered(_receiver), "Receiver not registered");
        require(_receiver != msg.sender, "Cannot exchange with self");
        require(bytes(_serviceDescription).length > 0, "Description required");
        require(_hoursEstimate >= 25, "Minimum 0.25 hours");
        require(_hoursEstimate <= 10000, "Maximum 100 hours");
        
        // Calculate value based on provider's baseline
        ParticipantRegistry.Participant memory provider = registry.getParticipant(msg.sender);
        uint256 valueCents = (_hoursEstimate * provider.hourlyBaselineCents) / 100;
        
        uint256 exchangeId = nextExchangeId++;
        
        exchanges[exchangeId] = Exchange({
            id: exchangeId,
            provider: msg.sender,
            receiver: _receiver,
            serviceDescription: _serviceDescription,
            hoursEstimate: _hoursEstimate,
            valueCents: valueCents,
            state: ExchangeState.Proposed,
            createdAt: block.timestamp,
            acceptedAt: 0,
            completedAt: 0,
            confirmedAt: 0,
            disputeReason: ""
        });
        
        participantExchanges[msg.sender].push(exchangeId);
        participantExchanges[_receiver].push(exchangeId);
        
        emit ExchangeProposed(
            exchangeId,
            msg.sender,
            _receiver,
            _serviceDescription,
            valueCents
        );
        
        return exchangeId;
    }
    
    /**
     * @notice Accept a proposed exchange
     * @param _exchangeId Exchange to accept
     */
    function acceptExchange(uint256 _exchangeId) 
        external 
        onlyRegistered 
        exchangeExists(_exchangeId)
        inState(_exchangeId, ExchangeState.Proposed)
    {
        Exchange storage exchange = exchanges[_exchangeId];
        require(msg.sender == exchange.receiver, "Only receiver can accept");
        
        exchange.state = ExchangeState.Accepted;
        exchange.acceptedAt = block.timestamp;
        
        emit ExchangeAccepted(_exchangeId, msg.sender);
    }
    
    /**
     * @notice Provider marks exchange as completed
     * @param _exchangeId Exchange to mark complete
     */
    function markCompleted(uint256 _exchangeId)
        external
        onlyRegistered
        exchangeExists(_exchangeId)
        inState(_exchangeId, ExchangeState.Accepted)
    {
        Exchange storage exchange = exchanges[_exchangeId];
        require(msg.sender == exchange.provider, "Only provider can mark complete");
        
        exchange.state = ExchangeState.ProviderCompleted;
        exchange.completedAt = block.timestamp;
        
        emit ExchangeCompleted(_exchangeId, msg.sender);
    }
    
    /**
     * @notice Receiver confirms exchange completion
     * @param _exchangeId Exchange to confirm
     * @dev This finalizes the exchange and updates credit balances
     */
    function confirmCompletion(uint256 _exchangeId)
        external
        onlyRegistered
        exchangeExists(_exchangeId)
        inState(_exchangeId, ExchangeState.ProviderCompleted)
    {
        Exchange storage exchange = exchanges[_exchangeId];
        require(msg.sender == exchange.receiver, "Only receiver can confirm");
        
        exchange.state = ExchangeState.Confirmed;
        exchange.confirmedAt = block.timestamp;
        
        // Update credit balances
        // Provider: +value (gave service)
        // Receiver: -value (received service)
        registry.updateCreditBalance(
            exchange.provider,
            int256(exchange.valueCents),
            string(abi.encodePacked("Exchange #", _uint2str(exchange.id), " completed"))
        );
        
        registry.updateCreditBalance(
            exchange.receiver,
            -int256(exchange.valueCents),
            string(abi.encodePacked("Exchange #", _uint2str(exchange.id), " received"))
        );
        
        totalExchangesCompleted++;
        totalValueExchanged += exchange.valueCents;
        
        emit ExchangeConfirmed(_exchangeId, msg.sender, exchange.valueCents);
    }
    
    /**
     * @notice Cancel an exchange before completion
     * @param _exchangeId Exchange to cancel
     * @param _reason Reason for cancellation
     */
    function cancelExchange(uint256 _exchangeId, string calldata _reason)
        external
        onlyRegistered
        exchangeExists(_exchangeId)
    {
        Exchange storage exchange = exchanges[_exchangeId];
        require(
            exchange.state == ExchangeState.Proposed || 
            exchange.state == ExchangeState.Accepted,
            "Cannot cancel at this stage"
        );
        require(
            msg.sender == exchange.provider || msg.sender == exchange.receiver,
            "Not a participant"
        );
        
        exchange.state = ExchangeState.Cancelled;
        
        emit ExchangeCancelled(_exchangeId, msg.sender, _reason);
    }
    
    /**
     * @notice Dispute an exchange
     * @param _exchangeId Exchange to dispute
     * @param _reason Reason for dispute
     */
    function disputeExchange(uint256 _exchangeId, string calldata _reason)
        external
        onlyRegistered
        exchangeExists(_exchangeId)
    {
        Exchange storage exchange = exchanges[_exchangeId];
        require(
            exchange.state == ExchangeState.Accepted ||
            exchange.state == ExchangeState.ProviderCompleted,
            "Cannot dispute at this stage"
        );
        require(
            msg.sender == exchange.provider || msg.sender == exchange.receiver,
            "Not a participant"
        );
        require(bytes(_reason).length > 0, "Reason required");
        
        exchange.state = ExchangeState.Disputed;
        exchange.disputeReason = _reason;
        
        emit ExchangeDisputed(_exchangeId, msg.sender, _reason);
    }
    
    // ============ View Functions ============
    
    function getExchange(uint256 _exchangeId) external view returns (Exchange memory) {
        return exchanges[_exchangeId];
    }
    
    function getParticipantExchanges(address _participant) external view returns (uint256[] memory) {
        return participantExchanges[_participant];
    }
    
    function getExchangesByState(
        address _participant, 
        ExchangeState _state
    ) external view returns (uint256[] memory) {
        uint256[] memory allIds = participantExchanges[_participant];
        uint256 count = 0;
        
        // Count matching
        for (uint i = 0; i < allIds.length; i++) {
            if (exchanges[allIds[i]].state == _state) count++;
        }
        
        // Build result array
        uint256[] memory result = new uint256[](count);
        uint256 j = 0;
        for (uint i = 0; i < allIds.length; i++) {
            if (exchanges[allIds[i]].state == _state) {
                result[j++] = allIds[i];
            }
        }
        
        return result;
    }
    
    // ============ Internal Helpers ============
    
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
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
