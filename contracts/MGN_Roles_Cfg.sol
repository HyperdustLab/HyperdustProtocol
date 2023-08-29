pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "./utils/StrUtil.sol";

contract MGN_Roles_Cfg is Ownable {
    using Strings for *;
    using StrUtil for *;

    mapping(address => bool) public _adminRoleIndex;

    constructor() {
        _adminRoleIndex[msg.sender] = true;
    }

    function addAdmin(address account) public onlyOwner {
        require(!_adminRoleIndex[account], "administrator already exists");
        _adminRoleIndex[account] = true;
    }

    function hasAdminRole(address account) public view returns (bool) {
        return _adminRoleIndex[account];
    }

    function deleteAdmin(address account) public onlyOwner {
        _adminRoleIndex[account] = false;
    }
}
