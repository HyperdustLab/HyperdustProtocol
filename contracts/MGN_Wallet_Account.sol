pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "./utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Wallet_Account is Ownable {
    AmountConfInfo[] public _amountConfInfos;
    address public _erc20Address;

    address public _rolesCfgAddress;

    address public admin;

    enum AccountType {
        TVL,
        PLATFORM_RESERVE,
        TEAM,
        BURN
    }

    struct AmountConfInfo {
        AccountType accountType;
        uint256 allocateAmount;
        uint256 useAmount;
        uint8 proportion;
        bool allowSettlement;
        address contractAddress;
    }

    constructor() {
        admin = msg.sender;
        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.TVL,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 40,
                allowSettlement: true,
                contractAddress: address(0)
            })
        );

        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.PLATFORM_RESERVE,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 20,
                allowSettlement: true,
                contractAddress: address(0)
            })
        );

        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.TEAM,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 23,
                allowSettlement: true,
                contractAddress: address(0)
            })
        );

        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.BURN,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 17,
                allowSettlement: true,
                contractAddress: address(0)
            })
        );
    }

    function setErc20Address(address erc20Address) public {
        require(admin == msg.sender, "No permission to modify");
        _erc20Address = erc20Address;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function list() public view returns (AmountConfInfo[] memory) {
        return _amountConfInfos;
    }

    function get(
        AccountType accountType
    ) public view returns (AmountConfInfo memory) {
        for (uint i = 0; i < _amountConfInfos.length; i++) {
            if (_amountConfInfos[i].accountType == accountType) {
                AmountConfInfo memory amountConfInfo = _amountConfInfos[i];

                return amountConfInfo;
            }
        }

        revert("not found");
    }

    function addAmount(uint256 amount) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint i = 0; i < _amountConfInfos.length; i++) {
            _amountConfInfos[i].allocateAmount +=
                (amount * _amountConfInfos[i].proportion) /
                100;
        }
    }

    function settlementAmount(
        AccountType accountType,
        uint256 amount,
        address account
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint i = 0; i < _amountConfInfos.length; i++) {
            if (_amountConfInfos[i].accountType == accountType) {
                AmountConfInfo memory amountConfInfo = _amountConfInfos[i];

                require(
                    msg.sender == amountConfInfo.contractAddress,
                    "No permission"
                );

                require(amountConfInfo.allowSettlement, "Billing not allowed");

                require(
                    amountConfInfo.allocateAmount -
                        amountConfInfo.useAmount -
                        amount >=
                        0,
                    "invalid amount"
                );

                _amountConfInfos[i].useAmount += amount;

                return;
            }
        }

        revert("not found");
    }
}
