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

import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../finance/Hyperdust_GPUMining.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IHyperdustNodeMgr {
    function getNode(uint256 id) public view returns (address, string memory, uint256[] memory) {}

    function getIdByIndex(uint256 index) public view returns (uint256) {}

    function getStatisticalIndex() public view returns (uint256, uint256, uint256) {}

    function setStatisticalIndex(uint256 totalNum, uint256 activeNum) public {}
}

abstract contract IHyperdustSecurityDeposit {
    function addSecurityDeposit(uint256 nodeId, uint256 amount) public {}
}

abstract contract IHyperdustBaseRewardRelease {
    function addBaseRewardReleaseRecord(uint256 amount, address account) public {}
}

abstract contract IHyperdustRenderTranscitionAddress {
    function updateEpoch() public {}
}

contract Hyperdust_Epoch_Awards is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;

    address public _hyperdustNodeMgrAddress;

    address public _hyperdustSecurityDeposit;

    address public _hyperdustBaseRewardRelease;

    address public _HyperdustGPUMiningAddress;

    address public _erc20Address;

    uint256 private _rand;

    event eveRewards(uint256 nodeId, uint256 epochAward, uint256 rand, uint256 nonce);

    function initialize(address onlyOwner) public initializer {
        _rand = 1;
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setHyperdustNodeMgrAddress(address hyperdustNodeMgrAddress) public onlyOwner {
        _hyperdustNodeMgrAddress = hyperdustNodeMgrAddress;
    }

    function setHyperdustSecurityDeposit(address hyperdustSecurityDeposit) public onlyOwner {
        _hyperdustSecurityDeposit = hyperdustSecurityDeposit;
    }

    function setHyperdustBaseRewardRelease(address hyperdustBaseRewardRelease) public onlyOwner {
        _hyperdustBaseRewardRelease = hyperdustBaseRewardRelease;
    }

    function setHyperdustGPUMiningAddress(address HyperdustGPUMiningAddress) public onlyOwner {
        _HyperdustGPUMiningAddress = HyperdustGPUMiningAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _hyperdustNodeMgrAddress = contractaddressArray[1];
        _hyperdustSecurityDeposit = contractaddressArray[2];
        _hyperdustBaseRewardRelease = contractaddressArray[3];
        _HyperdustGPUMiningAddress = contractaddressArray[4];
        _erc20Address = contractaddressArray[5];
    }

    function rewards(bytes32[] memory nodeStatus, uint256 nonce) public {
        require(IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        (uint256[] memory activeNodes, uint256[] memory onlineNodes, uint256 _totalNum, uint256 _activeNum) = countActiveNode(nodeStatus);

        IHyperdustNodeMgr hyperdustNodeMgrAddress = IHyperdustNodeMgr(_hyperdustNodeMgrAddress);

        Hyperdust_GPUMining hyperdust_GPUMining = Hyperdust_GPUMining(_HyperdustGPUMiningAddress);

        uint256 epochAward = hyperdust_GPUMining._epochAward();

        uint256 totalNum = _totalNum;

        if (_totalNum < 10) {
            _totalNum = 10;
        }

        if (epochAward == 0) {
            return;
        }

        uint256 nodeId;
        uint256 index;

        if (_activeNum == 0) {
            _activeNum = 1;

            index = _getRandom(0, totalNum);

            nodeId = onlineNodes[index];
        } else {
            index = _getRandom(0, _activeNum);
            nodeId = activeNodes[index];
        }

        uint32 accuracy = 1000000;

        uint256 difficulty = (_totalNum * accuracy) / _activeNum;

        uint256 actualEpochAward = epochAward / 2 + (epochAward * accuracy) / difficulty / 2;
        uint256 securityDeposit = actualEpochAward / 10;
        uint256 baseRewardReleaseAward = actualEpochAward - securityDeposit;

        hyperdust_GPUMining.mint(address(this), actualEpochAward);

        IERC20 erc20 = IERC20(_erc20Address);

        erc20.transfer(_hyperdustBaseRewardRelease, baseRewardReleaseAward);

        erc20.transfer(_hyperdustSecurityDeposit, securityDeposit);

        IHyperdustSecurityDeposit(_hyperdustSecurityDeposit).addSecurityDeposit(nodeId, securityDeposit);

        console.log("nodeId:%s,securityDeposit:%s", nodeId.toString(), securityDeposit.toString());

        (address incomeAddress, , ) = hyperdustNodeMgrAddress.getNode(nodeId);

        console.log("_hyperdustBaseRewardRelease:%s,baseRewardReleaseAward:%s,incomeAddress:%s", _hyperdustBaseRewardRelease.toHexString(), baseRewardReleaseAward.toString(), incomeAddress.toHexString());

        IHyperdustBaseRewardRelease(_hyperdustBaseRewardRelease).addBaseRewardReleaseRecord(baseRewardReleaseAward, incomeAddress);

        emit eveRewards(nodeId, actualEpochAward, index, nonce);
    }

    function countActiveNode(bytes32[] memory nodeStatus) private returns (uint256[] memory, uint256[] memory, uint256, uint256) {
        IHyperdustNodeMgr hyperdustNodeMgrAddress = IHyperdustNodeMgr(_hyperdustNodeMgrAddress);

        uint256 activeNum = 0;
        uint256 totalNum = 0;

        (uint256 totalSize, , ) = hyperdustNodeMgrAddress.getStatisticalIndex();

        uint256[] memory activeNodes = new uint256[](totalSize);
        uint256[] memory onlineNodes = new uint256[](totalSize);

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < nodeStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                uint256 nodeId = hyperdustNodeMgrAddress.getIdByIndex(index);

                if (nodeId == 0) {
                    break;
                }

                bytes1 status = bytes1(nodeStatus[i][j]);

                if (status != 0x00) {
                    onlineNodes[totalNum] = nodeId;

                    totalNum++;

                    console.log(totalNum.toString());

                    if (status == 0x11) {
                        activeNum++;
                        activeNodes[activeIndex] = nodeId;
                        activeIndex++;
                    }
                }
                index++;
            }
        }

        hyperdustNodeMgrAddress.setStatisticalIndex(totalNum, activeNum);

        return (activeNodes, onlineNodes, totalNum, activeNum);
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
}
