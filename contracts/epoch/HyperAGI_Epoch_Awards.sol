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

import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";
import {StrUtil} from "../utils/StrUtil.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./../HyperAGI_Roles_Cfg.sol";
import "./HyperAGI_BaseReward_Release.sol";
import "./HyperAGI_Security_Deposit.sol";
import "./../finance/HyperAGI_GPUMining.sol";
import "./../HyperAGI_Wallet_Account.sol";
import "./../node/HyperAGI_Node_Pool.sol";
import "./../HyperAGI_Pool_Level.sol";

import "hardhat/console.sol";

contract HyperAGI_Epoch_Awards is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;

    address public _securityDepositAddress;

    address public _baseRewardReleaseAddress;

    address public _GPUMiningAddress;

    address public _walletAccountAddress;

    address public _nodePoolAddress;

    address public _poolLevelAddress;

    uint256 public _difficulty;

    uint256 public _epochCount;

    bytes32 public constant INFERENCE_NODE = keccak256("inference_node");

    receive() external payable {}

    event evePoolRewards(uint256[] poolIds, uint256[] baseRewardRates, uint256[] pledgeKeyNums, uint256[] actualRewardRates, uint256[] rewardRateRatios, uint256[] inferenceTokenNums, uint256[] tokenNumRatios, uint256[] distributionRatios, uint256[] epochAward);
    
    event eveAccountRewards(uint256[] poolIds, address[] accounts, uint256[] pledgeKeyNums, uint256[] pledgeAmounts, uint256[] distributionRatios, uint256[] distributionAmounts);

    event eveDifficulty(uint256 difficulty, uint256 epochCount, uint256 inferenceTokenNum);

    function initialize(address onlyOwner, uint256 difficulty) public initializer {
        __Ownable_init(onlyOwner);
        _difficulty = difficulty;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setSecurityDepositAddress(address securityDepositAddress) public onlyOwner {
        _securityDepositAddress = securityDepositAddress;
    }

    function setBaseRewardReleaseAddress(address baseRewardReleaseAddress) public onlyOwner {
        _baseRewardReleaseAddress = baseRewardReleaseAddress;
    }

    function setGPUMiningAddress(address GPUMiningAddress) public onlyOwner {
        _GPUMiningAddress = GPUMiningAddress;
    }

    function setWalletAccountAddress(address walletAccountAddress) public onlyOwner {
        _walletAccountAddress = walletAccountAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _securityDepositAddress = contractaddressArray[1];
        _baseRewardReleaseAddress = contractaddressArray[2];
        _GPUMiningAddress = contractaddressArray[3];
        _walletAccountAddress = contractaddressArray[4];
        _nodePoolAddress = contractaddressArray[5];
        _poolLevelAddress = contractaddressArray[6];
    }

    function rewards(uint256[] memory poolIds, uint256[] memory tokenNums) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");




    }
}
