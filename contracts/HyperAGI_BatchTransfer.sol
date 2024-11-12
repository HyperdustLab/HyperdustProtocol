// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HyperAGI_BatchTransfer {
    // Contract owner address
    address public owner;

    // Constructor, sets the contract deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to ensure only the owner can call
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function batchTransferETH(address[] calldata recipients, uint256 amount) external payable onlyOwner {
        require(recipients.length > 0, "Recipient address list cannot be empty");
        require(msg.value >= amount * recipients.length, "Insufficient total transfer amount");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Cannot transfer to the zero address");

            payable(recipients[i]).transfer(amount);
        }

        // If there is excess ETH, return it to the sender
        uint256 remaining = msg.value - (amount * recipients.length);
        if (remaining > 0) {
            payable(msg.sender).transfer(remaining);
        }
    }

    // Query contract ETH balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
