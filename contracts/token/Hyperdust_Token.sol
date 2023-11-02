// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_Token is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Hyperdust", "HYPT Private Test") {}

    address public _rolesCfgAddress;

    uint256 public _totalSupply = 2000000000 ether;

    uint256 public _mintNum = 0;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function mint(address to, uint256 amount) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        require(
            _mintNum + amount <= _totalSupply,
            "mint amount over totalSupply"
        );

        _mint(to, amount);

        _mintNum += amount;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
}
