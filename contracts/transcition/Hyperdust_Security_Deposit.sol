pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "../utils/StrUtil.sol";

abstract contract IHyperdustNodeMgr {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {}

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {}

    function balanceOf(address account) external view returns (uint256) {}

    function approve(address spender, uint256 amount) external returns (bool) {}

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {}

    function mint(address to, uint256 amount) public {}
}

contract Hyperdust_Security_Deposit is Ownable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _erc20Address;

    mapping(uint256 => uint256) public _securityDepositMap;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setERC20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
    }

    function addSecurityDeposit(uint256 nodeId, uint256 amount) public {
        require(
            IHyperdustNodeMgr(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        _securityDepositMap[nodeId] += amount;
    }

    function transfer(address to, uint256 amount, uint256 nodeId) public {
        require(
            IHyperdustNodeMgr(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        require(
            _securityDepositMap[nodeId] >= amount,
            "not enough security deposit"
        );

        IERC20(_erc20Address).mint(to, amount);
    }

    function getSecurityDeposit(uint256 nodeId) public view returns (uint256) {
        return _securityDepositMap[nodeId];
    }
}
