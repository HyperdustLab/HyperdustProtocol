pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Space_Airdrop is Ownable {
    address public _rolesCfgAddress;

    mapping(uint256 => uint256) spaceAirdropAmount;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function addSpaceAirdrop(uint256 spaceId, uint256 amount) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        spaceAirdropAmount[spaceId] += amount;
    }

    function reduceSpaceAirdrop(uint256 spaceId, uint256 amount) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        require(
            spaceAirdropAmount[spaceId] - amount >= 0,
            "Insufficient amount"
        );

        spaceAirdropAmount[spaceId] -= amount;
    }
}
