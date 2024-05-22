pragma solidity ^0.8.2;

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import {StrUtil} from "../utils/StrUtil.sol";

contract Hyperdust_Node_Mgr_Stub is Ownable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;

    uint32 public _totalNum;
    uint32 public _activeNum;

    constructor(address ownable) Ownable(ownable) {}

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function getStatisticalIndex()
        public
        view
        returns (uint256, uint256, uint256)
    {
        return (0, _totalNum, _activeNum);
    }

    function setStatisticalIndex(uint256 totalNum, uint256 activeNum) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        _totalNum = uint32(totalNum);
        _activeNum = uint32(activeNum);
    }
}
