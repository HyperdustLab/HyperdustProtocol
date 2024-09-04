// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

<<<<<<<< HEAD:contracts/token/Hyperdust_20.sol
contract Hyperdust_20 is ERC20, ERC20Burnable, Ownable {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) Ownable(msg.sender) {}
========
contract HyperAGI_20 is ERC20, ERC20Burnable, Ownable {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) Ownable(msg.sender) {}
>>>>>>>> dev:contracts/token/HyperAGI_20.sol

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
