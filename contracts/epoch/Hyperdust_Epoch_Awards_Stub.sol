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

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IHyperdustNodeMgr {
    function setStatisticalIndex(uint256 totalNum, uint256 activeNum) public {}
}

contract Hyperdust_Epoch_Awards_Stub is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;

    address public _hyperdustNodeMgrAddress;

    uint256 private _rand;

    event eveRewards(
        uint256 nodeId,
        uint256 epochAward,
        uint256 rand,
        uint256 nonce
    );

    function initialize(address onlyOwner) public initializer {
        _rand = 1;
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setHyperdustNodeMgrAddress(
        address hyperdustNodeMgrAddress
    ) public onlyOwner {
        _hyperdustNodeMgrAddress = hyperdustNodeMgrAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _hyperdustNodeMgrAddress = contractaddressArray[1];
    }

    function rewards(bytes32[] memory nodeStatus, uint256 nonce) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        countActiveNode(nodeStatus);
    }

    function countActiveNode(
        bytes32[] memory nodeStatus
    ) private returns (uint256, uint256) {
        IHyperdustNodeMgr hyperdustNodeMgrAddress = IHyperdustNodeMgr(
            _hyperdustNodeMgrAddress
        );

        uint256 activeNum = 0;
        uint256 totalNum = 0;

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < nodeStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                bytes1 status = bytes1(nodeStatus[i][j]);

                if (status != 0x00) {
                    totalNum++;

                    if (status == 0x11) {
                        activeNum++;
                        activeIndex++;
                    }
                }
                index++;
            }
        }

        hyperdustNodeMgrAddress.setStatisticalIndex(totalNum, activeNum);

        return (totalNum, activeNum);
    }

    function _getRandom(
        uint256 _start,
        uint256 _end
    ) private returns (uint256) {
        if (_start == _end) {
            return _start;
        }
        uint256 _length = _end - _start;
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(block.difficulty, block.timestamp, _rand)
            )
        );
        random = (random % _length) + _start;
        _rand++;
        return random;
    }
}
