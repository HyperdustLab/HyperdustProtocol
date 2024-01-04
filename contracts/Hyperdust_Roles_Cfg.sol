pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./utils/StrUtil.sol";

contract Hyperdust_Roles_Cfg is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    mapping(address => bool) public _adminRole;
    mapping(address => bool) public _superAsdminRole;

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        _adminRole[msg.sender] = true;
    }

    function addAdmin(address account) public onlyOwner {
        require(!_adminRole[account], "administrator already exists");
        _adminRole[account] = true;
    }

    function addSuperAdmin(address account) public onlyOwner {
        require(!_superAsdminRole[account], "administrator already exists");
        _superAsdminRole[account] = true;
    }

    function addAdmin2(address account) public {
        require(_superAsdminRole[msg.sender], "not super admin role");
        require(!_adminRole[account], "administrator already exists");
        _adminRole[account] = true;
    }

    function hasAdminRole(address account) public view returns (bool) {
        return _adminRole[account];
    }

    function deleteAdmin(address account) public onlyOwner {
        _adminRole[account] = false;
    }
}
