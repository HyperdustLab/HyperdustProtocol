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

import "@openzeppelin/contracts/utils/math/Math.sol";

import "./../HyperAGI_Roles_Cfg.sol";
import "./HyperAGI_BaseReward_Release.sol";
import "./../finance/HyperAGI_AgentWallet.sol";

import "./../agent/HyperAGI_Agent.sol";
import "./../HyperAGI_Wallet_Account.sol";

import "hardhat/console.sol";

contract HyperAGI_Agent_Epoch_Awards is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;
    using Math for uint256;

    address public _rolesCfgAddress;

    address public _agentAddress;

    address public _baseRewardReleaseAddress;

    address public _agentWalletAddress;

    address public _walletAccountAddress;

    uint256 private _rand;

    uint256 public _difficulty;

    uint256 public _epochCount;

    receive() external payable {}

    event eveRewards(address agentAccount, uint256 epochAward, uint256 rand, uint256 epochCount);

    event eveDifficulty(uint256 difficulty, uint256 epochCount, uint256 inferenceTokenNum);

    function initialize(address onlyOwner, uint256 difficulty) public initializer {
        _rand = 1;
        __Ownable_init(onlyOwner);
        _difficulty = difficulty;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setAgentAddress(address agentAddress) public onlyOwner {
        _agentAddress = agentAddress;
    }

    function setBaseRewardReleaseAddress(address baseRewardReleaseAddress) public onlyOwner {
        _baseRewardReleaseAddress = baseRewardReleaseAddress;
    }

    function setWalletAccountAddress(address walletAccountAddress) public onlyOwner {
        _walletAccountAddress = walletAccountAddress;
    }

    function setAgentWalletAddress(address agentWalletAddress) public onlyOwner {
        _agentWalletAddress = agentWalletAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _agentAddress = contractaddressArray[1];
        _baseRewardReleaseAddress = contractaddressArray[2];
        _agentWalletAddress = contractaddressArray[3];
        _walletAccountAddress = contractaddressArray[4];
    }

    function rewards(bytes32[] memory agentStatus, uint256 nonce, uint256 gasFee) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
    }

    function countActiveAgent(bytes32[] memory agentStatus) private view returns (address[] memory, uint256, uint256) {
        HyperAGI_Agent agentAddress = HyperAGI_Agent(_agentAddress);

        uint256 totalSize = agentAddress.getAgentAccountLen();

        address[] memory activeAgents = new address[](totalSize);

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < agentStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                if (index >= totalSize) {
                    break;
                }

                bytes1 status = agentStatus[i][j];

                if (status == 0x11) {
                    activeAgents[activeIndex] = agentAddress.getAgentAccount(index);
                    activeIndex++;
                }

                index++;
            }
        }

        return (activeAgents, activeIndex, totalSize);
    }

    function _getRandom(uint256 _start, uint256 _end) private view returns (uint256) {
        require(_start < _end, "Invalid range");
        if (_start == _end) {
            return _start;
        }
        uint256 _length = _end - _start;
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, blockhash(block.number - 1), msg.sender, _rand)));
        random = (random % _length) + _start;
        return random;
    }

    function transferETH(address payable recipient, uint256 amount) private {
        require(address(this).balance >= amount, "Insufficient balance in contract");
        recipient.transfer(amount);
    }
}
