// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";

import "./utils/StrUtil.sol";

import "./Hyperdust_Storage.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_Space is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustStorageAddress;

    address public _HyperdustRolesCfgAddress;

    event eveSave(bytes32 sid);

    event eveDelete(bytes32 sid);

    function initialize(address ownable) public initializer {
        __Ownable_init(ownable);
    }

    function setHyperdustStorageAddress(address hyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _HyperdustRolesCfgAddress = rolesCfgAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _HyperdustStorageAddress = contractaddressArray[0];
        _HyperdustRolesCfgAddress = contractaddressArray[1];
    }

    function add(string memory name, string memory coverImage, string memory image, string memory remark) public returns (bytes32) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        uint256 id = hyperdustStorage.getNextId();

        bytes32 sid = generateUniqueHash(id);

        hyperdustStorage.setBytes32Uint(sid, id);
        hyperdustStorage.setAddress(hyperdustStorage.genKey("account", id), msg.sender);
        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setString(hyperdustStorage.genKey("coverImage", id), coverImage);

        hyperdustStorage.setString(hyperdustStorage.genKey("image", id), image);

        hyperdustStorage.setString(hyperdustStorage.genKey("remark", id), remark);

        emit eveSave(sid);

        return sid;
    }

    function get(bytes32 sid) public view returns (bytes32, address, string memory, string memory, string memory, string memory) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        uint256 id = hyperdustStorage.getBytes32Uint(sid);

        require(id > 0, "not found");

        string memory name = hyperdustStorage.getString(hyperdustStorage.genKey("name", id));

        address account = hyperdustStorage.getAddress(hyperdustStorage.genKey("account", id));

        string memory coverImage = hyperdustStorage.getString(hyperdustStorage.genKey("coverImage", id));

        string memory remark = hyperdustStorage.getString(hyperdustStorage.genKey("remark", id));

        string memory image = hyperdustStorage.getString(hyperdustStorage.genKey("image", id));

        return (sid, account, name, coverImage, image, remark);
    }

    function edit(bytes32 sid, string memory name, string memory coverImage, string memory image, string memory remark) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);
        uint256 id = hyperdustStorage.getBytes32Uint(sid);

        require(id > 0, "not found");

        address account = hyperdustStorage.getAddress(hyperdustStorage.genKey("account", id));

        require(account == msg.sender || IHyperdustRolesCfg(_HyperdustRolesCfgAddress).hasAdminRole(msg.sender), "You don't have permission to operate");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setString(hyperdustStorage.genKey("coverImage", id), coverImage);

        hyperdustStorage.setString(hyperdustStorage.genKey("image", id), image);

        hyperdustStorage.setString(hyperdustStorage.genKey("remark", id), remark);

        emit eveSave(sid);
    }

    function del(bytes32 sid) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        uint256 id = hyperdustStorage.getBytes32Uint(sid);

        require(id > 0, "not found");

        address account = hyperdustStorage.getAddress(hyperdustStorage.genKey("account", id));

        require(account == msg.sender || IHyperdustRolesCfg(_HyperdustRolesCfgAddress).hasAdminRole(msg.sender), "You don't have permission to operate");

        hyperdustStorage.setBytes32Uint(sid, 0);

        emit eveDelete(sid);
    }

    function generateUniqueHash(uint256 nextId) private view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, block.difficulty, nextId));
    }
}
