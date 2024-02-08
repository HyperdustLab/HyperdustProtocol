// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Hyperdust_Mining_Release is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;

    address public _FromAddress;

    address public _ERC20Address;

    function setHyperdustRolesCfgAddress(
        address HyperdustRolesCfgAddress
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function setFromAddress(address FromAddress) public onlyOwner {
        _FromAddress = FromAddress;
    }

    function setERC20Address(address ERC20Address) public onlyOwner {
        _ERC20Address = ERC20Address;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = contractaddressArray[0];
        _FromAddress = contractaddressArray[1];
        _ERC20Address = contractaddressArray[2];
    }

    event eveSave(
        address[] accounts,
        uint256[] releaseTimes,
        uint256[] amounts
    );

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function release(
        address[] memory accounts,
        uint256[] memory releaseTimes,
        uint256[] memory amounts
    ) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        IERC20 erc20 = IERC20(_ERC20Address);

        address[] memory _accounts = new address[](accounts.length);
        uint256[] memory _amounts = new uint256[](accounts.length);
        uint256 len = 0;

        for (uint256 i = 0; i < accounts.length; i++) {
            uint256 index = 0;
            for (uint256 j = 0; j < len; j++) {
                if (_accounts[j] == accounts[i]) {
                    index = j + 1;
                    break;
                }
            }

            if (index == 0) {
                _accounts[len] = accounts[i];
                _amounts[len] = amounts[i];
                len++;
            } else {
                _amounts[index - 1] += amounts[i];
            }
        }

        for (uint256 i = 0; i < len; i++) {
            erc20.transferFrom(_FromAddress, _accounts[i], _amounts[i]);
        }

        emit eveSave(accounts, releaseTimes, amounts);
    }
}
