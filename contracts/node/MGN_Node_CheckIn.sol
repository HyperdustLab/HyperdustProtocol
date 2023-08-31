pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "../utils/StrUtil.sol";

contract MGN_Node_CheckIn is Ownable {
    using Strings for *;
    using StrUtil for *;

    function check(address incomeAddress) public view returns (bool) {
        return true;
    }
}
