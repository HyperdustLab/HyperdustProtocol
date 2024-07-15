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

    receive() external payable {}

    event eveRewards(address agentAccount, uint256 epochAward, uint256 rand, uint256 nonce, uint256 gasFee, uint256 groundRodLevel);

    function initialize(address onlyOwner) public initializer {
        _rand = 1;
        __Ownable_init(onlyOwner);
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

        (address[] memory activeAgent, uint256 activeNumIndex, uint256 _totalNum) = countActiveAgent(agentStatus);

        HyperAGI_AgentWallet agentWalletAddress = HyperAGI_AgentWallet(payable(_agentWalletAddress));
        HyperAGI_BaseReward_Release baseRewardReleaseAddress = HyperAGI_BaseReward_Release(payable(_baseRewardReleaseAddress));
        HyperAGI_Wallet_Account walletAccountAddress = HyperAGI_Wallet_Account(_walletAccountAddress);
        HyperAGI_Agent agentAddress = HyperAGI_Agent(_agentAddress);

        address _GasFeeCollectionWallet = walletAccountAddress._GasFeeCollectionWallet();

        uint256 epochAward = agentWalletAddress._epochAward();

        if (_totalNum < 1000) {
            _totalNum = 1000;
        }

        if (epochAward == 0) {
            return;
        }

        if (_totalNum == 0) {
            return;
        }

        uint256 index = _getRandom(0, activeNumIndex);

        address account = activeAgent[index];

        uint256 groundRodLevel = agentAddress.getGroundRodLevel(account);

        uint256 actualEpochAward = Math.mulDiv(groundRodLevel, epochAward, 5).mulDiv(1, Math.mulDiv(_totalNum, 1, activeNumIndex + 1));

        agentWalletAddress.mint(payable(address(this)), actualEpochAward);

        uint256 baseRewardReleaseAward = actualEpochAward - gasFee;

        baseRewardReleaseAddress.addBaseRewardReleaseRecord{value: baseRewardReleaseAward}(baseRewardReleaseAward, account);

        transferETH(payable(_GasFeeCollectionWallet), gasFee);

        walletAccountAddress.addAmount(gasFee);

        emit eveRewards(account, actualEpochAward, index, nonce, gasFee, groundRodLevel);
    }

    function countActiveAgent(bytes32[] memory agentStatus) private view returns (address[] memory, uint256, uint256) {
        HyperAGI_Agent agentAddress = HyperAGI_Agent(_agentAddress);

        uint256 totalSize = agentAddress.getAgentAccountLen();

        address[] memory activeAgents = new address[](totalSize);

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < agentStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                if (index + 1 > totalSize) {
                    break;
                }

                bytes1 status = bytes1(agentStatus[i][j]);

                if (status == 0x11) {
                    activeIndex++;

                    activeAgents[activeIndex - 1] = agentAddress.getAgentAccount(index);
                }

                index++;
            }
        }

        return (activeAgents, activeIndex == 0 ? activeIndex : activeIndex - 1, totalSize);
    }

    function _getRandom(uint256 _start, uint256 _end) private returns (uint256) {
        if (_start == _end) {
            return _start;
        }
        uint256 _length = _end - _start;
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _rand)));
        random = (random % _length) + _start;
        _rand++;
        return random;
    }

    function transferETH(address payable recipient, uint256 amount) private {
        require(address(this).balance >= amount, "Insufficient balance in contract");
        recipient.transfer(amount);
    }
}
