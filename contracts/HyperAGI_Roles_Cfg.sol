pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract HyperAGI_Roles_Cfg is OwnableUpgradeable {
    using Strings for *;

    mapping(address => bool) public _adminRole;
    mapping(address => bool) public _superAdminRole;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
        _adminRole[onlyOwner] = true;
    }

    function addAdmin(address account) public onlyOwner {
        require(!_adminRole[account], "administrator already exists");
        _adminRole[account] = true;
    }

    function addSuperAdmin(address account) public onlyOwner {
        require(!_superAdminRole[account], "administrator already exists");
        _superAdminRole[account] = true;
    }

    function addAdmin2(address account) public {
        require(_superAdminRole[msg.sender], "not super admin role");
        require(!_adminRole[account], "administrator already exists");
        _adminRole[account] = true;
    }

    function addAdmin3(address account) public {
        require(_superAdminRole[msg.sender], "not super admin role");
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
