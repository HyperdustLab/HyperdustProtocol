pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./utils/StrUtil.sol";
import "./HyperAGI_Roles_Cfg.sol";

contract HyperAGI_Faucet is OwnableUpgradeable {
    address public _rolesCfgAddress;
    using Strings for *;

    using StrUtil for *;

    event eveTransfer(address[]);

    receive() external payable {}

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function transfer(address[] memory accounts, uint256[] memory amounts) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        for (uint256 i = 0; i < accounts.length; i++) {
            transferETH(payable(accounts[i]), amounts[i]);
        }

        emit eveTransfer(accounts);
    }

    function transferETH(address payable recipient, uint256 amount) private {
        require(address(this).balance >= amount, "Insufficient balance in contract");
        recipient.transfer(amount);
    }
}
