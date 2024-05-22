pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../utils/StrUtil.sol";

contract Hyperdust_Node_CheckIn is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function check(address incomeAddress) public view returns (bool) {
        return true;
    }
}
