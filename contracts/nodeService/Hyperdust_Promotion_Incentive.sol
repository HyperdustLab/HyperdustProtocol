// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Hyperdust_Promotion_Incentive is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;

    address public _HyperdustStorageAddress;

    address public _FromAddress;

    address public _ERC20Address;

    function setHyperdustRolesCfgAddress(address HyperdustRolesCfgAddress) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function setHyperdustStorageAddress(address hyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setFromAddress(address FromAddress) public onlyOwner {
        _FromAddress = FromAddress;
    }

    function setERC20Address(address ERC20Address) public onlyOwner {
        _ERC20Address = ERC20Address;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _HyperdustRolesCfgAddress = contractaddressArray[0];
        _HyperdustStorageAddress = contractaddressArray[1];
        _FromAddress = contractaddressArray[2];
        _ERC20Address = contractaddressArray[3];
    }

    event eveSave(uint256[] nodeServiceIds, address[] users);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function release(uint256[] memory nodeServiceIds, address[] memory users, uint256[] memory amounts) public {
        require(Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        IERC20 erc20 = IERC20(_ERC20Address);

        for (uint256 i = 0; i < nodeServiceIds.length; i++) {
            string memory key = string(abi.encodePacked(users[i].toHexString(), "_", nodeServiceIds[i].toString()));
            bool b = hyperdustStorage.getBool(key);

            require(!b, string(abi.encodePacked(key, " already release")));

            hyperdustStorage.setBool(key, true);

            erc20.transferFrom(_FromAddress, users[i], amounts[i]);
        }

        emit eveSave(nodeServiceIds, users);
    }
}
