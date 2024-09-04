// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";

import "./utils/StrUtil.sol";

import "./HyperAGI_Storage.sol";
import "./HyperAGI_Roles_Cfg.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract HyperAGI_GYM_Space is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _storageAddress;

    address public _rolesCfgAddress;

    event eveSave(bytes32 sid);

    event eveDelete(bytes32 sid);

    function initialize(address ownable) public initializer {
        __Ownable_init(ownable);
    }

    function setStorageAddress(address storageAddress) public onlyOwner {
        _storageAddress = storageAddress;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _storageAddress = contractaddressArray[0];
        _rolesCfgAddress = contractaddressArray[1];
    }

    function add(string memory name, string memory coverImage, string memory image, string memory remark) public returns (bytes32) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);
        uint256 id = storageAddress.getNextId();

        bytes32 sid = generateUniqueHash(id);

        storageAddress.setBytes32Uint(sid, id);
        storageAddress.setAddress(storageAddress.genKey("account", id), msg.sender);
        storageAddress.setString(storageAddress.genKey("name", id), name);
        storageAddress.setString(storageAddress.genKey("coverImage", id), coverImage);

        storageAddress.setString(storageAddress.genKey("image", id), image);

        storageAddress.setString(storageAddress.genKey("remark", id), remark);

        emit eveSave(sid);

        return sid;
    }

    function get(bytes32 sid) public view returns (bytes32, address, string memory, string memory, string memory, string memory) {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 id = storageAddress.getBytes32Uint(sid);

        require(id > 0, "not found");

        string memory name = storageAddress.getString(storageAddress.genKey("name", id));

        address account = storageAddress.getAddress(storageAddress.genKey("account", id));

        string memory coverImage = storageAddress.getString(storageAddress.genKey("coverImage", id));

        string memory remark = storageAddress.getString(storageAddress.genKey("remark", id));

        string memory image = storageAddress.getString(storageAddress.genKey("image", id));

        return (sid, account, name, coverImage, image, remark);
    }

    function edit(bytes32 sid, string memory name, string memory coverImage, string memory image, string memory remark) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 id = storageAddress.getBytes32Uint(sid);

        require(id > 0, "not found");

        address account = storageAddress.getAddress(storageAddress.genKey("account", id));

        require(account == msg.sender || HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "You don't have permission to operate");

        storageAddress.setString(storageAddress.genKey("name", id), name);
        storageAddress.setString(storageAddress.genKey("coverImage", id), coverImage);

        storageAddress.setString(storageAddress.genKey("image", id), image);

        storageAddress.setString(storageAddress.genKey("remark", id), remark);

        emit eveSave(sid);
    }

    function del(bytes32 sid) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        uint256 id = storageAddress.getBytes32Uint(sid);

        require(id > 0, "not found");

        address account = storageAddress.getAddress(storageAddress.genKey("account", id));

        require(account == msg.sender || HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "You don't have permission to operate");

        storageAddress.setBytes32Uint(sid, 0);

        emit eveDelete(sid);
    }

    function generateUniqueHash(uint256 nextId) private view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, block.difficulty, nextId));
    }
}
