/**
 * @title Hyperdust_Render_Awards
 * @dev This contract is responsible for distributing rewards to active nodes in the Hyperdust Protocol.
 * It uses a random selection process to choose a node and distributes an epoch award to it.
 * The epoch award is calculated based on the total supply of the protocol and the number of active nodes.
 * A portion of the epoch award is kept as security deposit and the rest is released as base reward to the node.
 * The contract also keeps track of the total award and residue total award available for distribution.
 * Only the admin role can trigger the rewards distribution.
 */
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {StrUtil} from "../utils/StrUtil.sol";

contract HyperAGI_Payment_Wallet is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    struct User {
        uint256 balance;
        mapping(address => uint256) allowances;
    }

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    mapping(address => User) private users;

    function getBalance(address user) public view returns (uint256) {
        return users[user].balance;
    }

    function authorize(address spender, uint256 amount) public payable {
        require(msg.value > 0, "HYPT required");
        users[msg.sender].allowances[spender] = amount;
        users[msg.sender].balance += msg.value;
    }

    // Function to revoke authorization and refund remaining ETH
    function revokeAuthorization(address spender) public {
        uint256 remainingAllowance = users[msg.sender].allowances[spender];
        require(remainingAllowance > 0, "No allowance to revoke");

        users[msg.sender].allowances[spender] = 0;

        // Refund remaining allowance
        if (remainingAllowance <= users[msg.sender].balance) {
            users[msg.sender].balance -= remainingAllowance;
            payable(msg.sender).transfer(remainingAllowance);
        } else {
            uint256 refundAmount = users[msg.sender].balance;
            users[msg.sender].balance = 0;
            payable(msg.sender).transfer(refundAmount);
        }
    }

    function deduct(address from, uint256 amount) public {
        require(users[from].allowances[msg.sender] >= amount, "Not authorized or amount exceeds allowance");
        require(users[from].balance >= amount, "Insufficient balance");

        require(address(this).balance >= amount, "Insufficient balance in contract");

        users[from].balance -= amount;
        users[from].allowances[msg.sender] -= amount;

        payable(msg.sender).transfer(amount);
    }

    function withdraw(uint256 amount) public {
        require(users[msg.sender].balance >= amount, "Insufficient balance");

        users[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getAllowance(address owner, address spender) public view returns (uint256) {
        return users[owner].allowances[spender];
    }
}
