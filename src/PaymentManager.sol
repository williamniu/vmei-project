// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IPaymentManager.sol"; [cite_start]// [cite: 61]

contract PaymentManager {
    // Correct Checksummed Base Sepolia USDC Address
    address immutable public USDC_ADDRESS = 0x036CBd538d61B463c70D189d04D2e7208c3DCf7E; [cite_start]// [cite: 65]

    // Store which attestation IDs have a reward attached
    mapping(uint256 => uint256) public attestationRewards; [cite_start]// [cite: 66]

    // The interface instance to interact with the USDC contract
    IERC20 public usdcToken;

    constructor() {
        usdcToken = IERC20(USDC_ADDRESS); [cite_start]// [cite: 70]
    }

    // Function 1: Attaches a reward to an attestation ID
    // NOTE: The caller must FIRST approve this contract to spend the USDC!
    function depositReward(uint256 attestationId, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero."); [cite_start]// [cite: 75]

        // 1. Pull the USDC from the sender's wallet to THIS contract's balance
        bool success = usdcToken.transferFrom(msg.sender, address(this), amount); [cite_start]// [cite: 77]
        require(success, "USDC transferFrom failed."); [cite_start]// [cite: 79]

        attestationRewards[attestationId] = amount; [cite_start]// [cite: 80]
    }

    // Function 2: Pays the reward to the winner (the attestation recipient)
    function claimReward(address recipient, uint256 attestationId) external {
        uint256 rewardAmount = attestationRewards[attestationId];
        require(rewardAmount > 0, "No reward available for this ID."); [cite_start]// [cite: 83]

        // 1. Send the USDC from THIS contract's balance to the recipient
        bool success = usdcToken.transfer(recipient, rewardAmount); [cite_start]// [cite: 84]
        require(success, "USDC transfer failed."); [cite_start]// [cite: 85]

        // 2. Clear the reward so it cannot be claimed again
        delete attestationRewards[attestationId]; [cite_start]// [cite: 87]
    }
}