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
import "./../node/HyperAGI_Node_Mgr.sol";

contract HyperAGI_Ecpoch_Awards is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;

    address public _nodeMgrAddress;

    address public _securityDepositAddress;

    address public _baseRewardReleaseAddress;

    address public _GPUMiningAddress;

    uint256 private _rand;

    event eveRewards(uint256 nodeId, uint256 epochAward, uint256 rand, uint256 nonce);

    function initialize(address onlyOwner) public initializer {
        _rand = 1;
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setNodeMgrAddress(address nodeMgrAddress) public onlyOwner {
        _nodeMgrAddress = nodeMgrAddress;
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

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _nodeMgrAddress = contractaddressArray[1];
        _securityDepositAddress = contractaddressArray[2];
        _baseRewardReleaseAddress = contractaddressArray[3];
        _GPUMiningAddress = contractaddressArray[4];
    }

    function rewards(bytes32[] memory nodeStatus, uint256 nonce) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        (uint256[] memory activeNodes, uint256 _totalNum, uint256 _activeNum) = countActiveNode(nodeStatus);

        HyperAGI_Node_Mgr nodeMgrAddress = HyperAGI_Node_Mgr(_nodeMgrAddress);
        HyperAGI_GPUMining GPUMiningAddress = HyperAGI_GPUMining(_GPUMiningAddress);
        HyperAGI_Security_Deposit securityDepositAddress = HyperAGI_Security_Deposit(_securityDepositAddress);
        HyperAGI_BaseReward_Release baseRewardReleaseAddress = HyperAGI_BaseReward_Release(_baseRewardReleaseAddress);

        uint256 epochAward = GPUMiningAddress._epochAward();

        if (_totalNum < 10) {
            _totalNum = 10;
        }

        if (_activeNum == 0 || epochAward == 0) {
            return;
        }

        uint index = _getRandom(0, _activeNum);

        uint256 nodeId = activeNodes[index];

        uint32 accuracy = 1000000;

        uint256 difficulty = (_totalNum * accuracy) / _activeNum;

        uint256 actualEpochAward = (epochAward * accuracy) / difficulty;
        uint256 securityDeposit = actualEpochAward / 10;
        uint256 baseRewardReleaseAward = actualEpochAward - securityDeposit;

        GPUMiningAddress.mint(payable(address(this)), actualEpochAward);

        transferETH(payable(_baseRewardReleaseAddress), baseRewardReleaseAward);
        transferETH(payable(_securityDepositAddress), securityDeposit);
        securityDepositAddress.addSecurityDeposit(nodeId, securityDeposit);

        (address incomeAddress, , , ) = nodeMgrAddress.getNode(nodeId);

        baseRewardReleaseAddress.addBaseRewardReleaseRecord(baseRewardReleaseAward, incomeAddress);

        emit eveRewards(nodeId, actualEpochAward, index, nonce);
    }

    function countActiveNode(bytes32[] memory nodeStatus) private returns (uint256[] memory, uint256, uint256) {
        HyperAGI_Node_Mgr nodeMgrAddress = HyperAGI_Node_Mgr(_nodeMgrAddress);

        uint256 activeNum = 0;
        uint256 totalNum = 0;

        (uint256 totalSize, , ) = nodeMgrAddress.getStatisticalIndex();

        uint256[] memory activeNodes = new uint256[](totalSize);

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < nodeStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                uint256 nodeId = nodeMgrAddress.getIdByIndex(index);

                if (nodeId == 0) {
                    break;
                }

                bytes1 status = bytes1(nodeStatus[i][j]);

                if (status != 0x00) {
                    totalNum++;

                    if (status == 0x11) {
                        activeNum++;
                        activeNodes[activeIndex] = nodeId;
                        activeIndex++;
                    }
                }
                index++;
            }
        }

        nodeMgrAddress.setStatisticalIndex(totalNum, activeNum);

        return (activeNodes, totalNum, activeNum);
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
