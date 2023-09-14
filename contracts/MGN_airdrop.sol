pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
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
}

contract MGN_airdrop is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _id;

    using Strings for *;
    using StrUtil for *;

    address public _erc20Address;

    mapping(address => bool) public _airdrop;

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function airdrop(
        address[] memory addressList,
        uint256 num
    ) public onlyOwner {
        for (uint256 i = 0; i < addressList.length; i++) {
            if (!_airdrop[addressList[i]]) {
                IERC20(_erc20Address).transfer(addressList[i], num);
                _airdrop[addressList[i]] = true;
            }
        }
    }
}
