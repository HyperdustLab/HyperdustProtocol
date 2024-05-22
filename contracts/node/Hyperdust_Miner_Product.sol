// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";

contract Hyperdust_Miner_Product is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;
    address public _HyperdustStorageAddress;

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setHyperdustRolesCfgAddress(address HyperdustRolesCfgAddress) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function setHyperdustStorageAddress(address HyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = HyperdustStorageAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _HyperdustRolesCfgAddress = contractaddressArray[0];
        _HyperdustStorageAddress = contractaddressArray[1];
    }

    event eveSave(uint256 id);

    event eveDelete(uint256 id);

    function add(string memory name, uint256 price, uint256 limitNum, bytes1 status, string memory coverImage, uint256 putawayNum) public {
        require(Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        require(status == 0x01 || status == 0x00, "status error");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        uint256 id = hyperdustStorage.getNextId();

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setUint(hyperdustStorage.genKey("price", id), price);
        hyperdustStorage.setUint(hyperdustStorage.genKey("limitNum", id), limitNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("putawayNum", id), putawayNum);
        hyperdustStorage.setBytes1(hyperdustStorage.genKey("status", id), status);

        hyperdustStorage.setString(hyperdustStorage.genKey("coverImage", id), coverImage);

        emit eveSave(id);
    }

    function edit(uint256 id, string memory name, uint256 price, uint256 limitNum, bytes1 status, string memory coverImage, uint256 putawayNum) public {
        require(Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        string memory _name = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        require(bytes(_name).length > 0, "not found");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setString(hyperdustStorage.genKey("coverImage", id), coverImage);
        hyperdustStorage.setUint(hyperdustStorage.genKey("price", id), price);
        hyperdustStorage.setUint(hyperdustStorage.genKey("limitNum", id), limitNum);
        hyperdustStorage.setUint(hyperdustStorage.genKey("putawayNum", id), putawayNum);
        hyperdustStorage.setBytes1(hyperdustStorage.genKey("status", id), status);

        emit eveSave(id);
    }

    function del(uint256 id) public {
        require(Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        string memory name = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        require(bytes(name).length > 0, "not found");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), "");

        emit eveDelete(id);
    }

    function get(uint256 id) public view returns (string memory, uint256, uint256, bytes1, string memory, uint256 sellNum, uint256 putawayNum) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        string memory name = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        require(bytes(name).length > 0, "not found");

        uint256 price = hyperdustStorage.getUint(hyperdustStorage.genKey("price", id));
        uint256 limitNum = hyperdustStorage.getUint(hyperdustStorage.genKey("limitNum", id));
        bytes1 status = hyperdustStorage.getBytes1(hyperdustStorage.genKey("status", id));
        string memory coverImage = hyperdustStorage.getString(hyperdustStorage.genKey("coverImage", id));
        uint256 sellNum = hyperdustStorage.getUint(hyperdustStorage.genKey("sellNum", id));
        uint256 putawayNum = hyperdustStorage.getUint(hyperdustStorage.genKey("putawayNum", id));

        return (name, price, limitNum, status, coverImage, sellNum, putawayNum);
    }

    function addSellNum(uint256 id, uint256 num) public {
        require(Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        string memory name = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        require(bytes(name).length > 0, "not found");

        uint256 sellNum = hyperdustStorage.getUint(hyperdustStorage.genKey("sellNum", id));

        uint256 putawayNum = hyperdustStorage.getUint(hyperdustStorage.genKey("putawayNum", id));

        require(sellNum + num <= putawayNum, "Insufficient stock");

        hyperdustStorage.setUint(hyperdustStorage.genKey("sellNum", id), sellNum + num);

        if (sellNum + num == putawayNum) {
            hyperdustStorage.setBytes1(hyperdustStorage.genKey("status", id), 0x00);
            hyperdustStorage.setUint(hyperdustStorage.genKey("sellNum", id), 0);
        }

        emit eveSave(id);
    }
}
