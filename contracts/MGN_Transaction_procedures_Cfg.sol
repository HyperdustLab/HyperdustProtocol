pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "./utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Transaction_procedures_Cfg is Ownable {
    address public _rolesCfgAddress;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    mapping(string => uint32) public _transactionProceduresMap;

    constructor() {}

    function add(string memory func, uint32 rate) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        _transactionProceduresMap[func] = rate;
    }

    function del(string memory func, uint32 rate) {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        delete _transactionProceduresMap[func];
    }

    function get(string memory func) public view returns (uint32) {
        return _transactionProceduresMap[func];
    }
}
