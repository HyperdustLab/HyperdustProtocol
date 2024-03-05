// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "./utils/StrUtil.sol";

import "./Hyperdust_Storage.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Hyperdust_Space is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustStorageAddress;

    event eveSave(bytes32 sid);

    event eveDelete(bytes32 sid);

    function initialize(address ownable) public initializer {
        __Ownable_init(ownable);
    }

    function setHyperdustStorageAddress(
        address hyperdustStorageAddress
    ) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function add(
        string memory name,
        string memory coverImage,
        string memory remark
    ) public returns (bytes32) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256 id = hyperdustStorage.getNextId();

        bytes32 sid = generateUniqueHash(id);

        string memory sidStr = bytes32ToString(sid);

        hyperdustStorage.setUint(sidStr, id);
        hyperdustStorage.setAddress(
            hyperdustStorage.genKey("account", id),
            msg.sender
        );
        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setString(
            hyperdustStorage.genKey("coverImage", id),
            coverImage
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("remark", id),
            remark
        );

        emit eveSave(sid);

        return sid;
    }

    function get(
        bytes32 sid
    )
        public
        view
        returns (
            bytes32 _sid,
            address,
            string memory,
            string memory,
            string memory
        )
    {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory sidStr = bytes32ToString(sid);

        uint256 id = hyperdustStorage.getUint(sidStr);

        require(id > 0, "not found");

        string memory name = hyperdustStorage.getString(
            hyperdustStorage.genKey("name", id)
        );

        address account = hyperdustStorage.getAddress(
            hyperdustStorage.genKey("account", id)
        );

        string memory coverImage = hyperdustStorage.getString(
            hyperdustStorage.genKey("coverImage", id)
        );

        string memory remark = hyperdustStorage.getString(
            hyperdustStorage.genKey("remark", id)
        );

        return (sid, account, name, coverImage, remark);
    }

    function edit(
        bytes32 sid,
        string memory name,
        string memory coverImage,
        string memory remark
    ) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory sidStr = bytes32ToString(sid);

        uint256 id = hyperdustStorage.getUint(sidStr);

        require(id > 0, "not found");

        address account = hyperdustStorage.getAddress(
            hyperdustStorage.genKey("account", id)
        );

        require(account == msg.sender, "You don't have permission to operate");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setString(
            hyperdustStorage.genKey("coverImage", id),
            coverImage
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("remark", id),
            remark
        );

        emit eveSave(sid);
    }

    function del(bytes32 sid) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory sidStr = bytes32ToString(sid);

        uint256 id = hyperdustStorage.getUint(sidStr);

        require(id > 0, "not found");

        address account = hyperdustStorage.getAddress(
            hyperdustStorage.genKey("account", id)
        );

        require(account == msg.sender, "You don't have permission to operate");

        hyperdustStorage.setUint(sidStr, 0);

        emit eveDelete(sid);
    }

    function generateUniqueHash(uint256 nextId) private view returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, nextId)
            );
    }

    function bytes32ToString(
        bytes32 _bytes32
    ) private pure returns (string memory) {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
}
