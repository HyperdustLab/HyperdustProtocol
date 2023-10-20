pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "./utils/StrUtil.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_Transaction_Cfg is Ownable {
    address public _rolesCfgAddress;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    mapping(string => uint256) public _transactionProceduresMap;

    function add(string memory func, uint256 rate) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        _transactionProceduresMap[func] = rate;
    }

    function del(string memory func) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        delete _transactionProceduresMap[func];
    }

    function get(string memory func) public view returns (uint256) {
        return _transactionProceduresMap[func];
    }
}
