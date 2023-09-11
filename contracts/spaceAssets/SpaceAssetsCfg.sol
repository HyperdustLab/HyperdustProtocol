pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract SpaceAssetsCfg is Ownable {
    using Strings for *;
    using StrUtil for *;
    address public _transactionCfgAddress;

    address public _erc20Address;

    address public _walletAccountAddres;

    address public _rolesCfgAddress;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setWalletAccountAddres(
        address walletAccountAddres
    ) public onlyOwner {
        _walletAccountAddres = walletAccountAddres;
    }

    function setTransactionCfgAddress(
        address transactionCfgAddress
    ) public onlyOwner {
        _transactionCfgAddress = transactionCfgAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _transactionCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _walletAccountAddres = contractaddressArray[2];
        _rolesCfgAddress = contractaddressArray[3];
    }

    function getAddressConfList()
        public
        view
        returns (
            address transactionCfgAddress,
            address erc20Address,
            address walletAccountAddres,
            address rolesCfgAddress
        )
    {
        return (
            _transactionCfgAddress,
            _erc20Address,
            _walletAccountAddres,
            _rolesCfgAddress
        );
    }
}
