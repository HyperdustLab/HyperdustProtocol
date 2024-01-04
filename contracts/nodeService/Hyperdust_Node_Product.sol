// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

import "./../Hyperdust_Storage.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Hyperdust_Node_Product is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;

    address public _HyperdustStorageAddress;

    function setHyperdustRolesCfgAddress(
        address HyperdustRolesCfgAddress
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    event eveHNodeProductSave(uint256 id);

    event eveDeleteProductSave(uint256 id);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function setHyperdustStorageAddress(
        address hyperdustStorageAddress
    ) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function add(
        string memory name,
        uint256 day,
        uint256 price,
        string memory coverImage,
        string memory remark
    ) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256 id = hyperdustStorage.getNextId();

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setUint(hyperdustStorage.genKey("day", id), day);
        hyperdustStorage.setUint(hyperdustStorage.genKey("price", id), price);

        hyperdustStorage.setString(
            hyperdustStorage.genKey("coverImage", id),
            coverImage
        );
        hyperdustStorage.setString(
            hyperdustStorage.genKey("remark", id),
            remark
        );

        emit eveHNodeProductSave(id);
    }

    function get(
        uint256 id
    )
        public
        view
        returns (
            uint256,
            string memory,
            uint256,
            uint256,
            string memory,
            string memory
        )
    {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory name = hyperdustStorage.getString(
            hyperdustStorage.genKey("name", id)
        );

        require(bytes(name).length > 0, "not found");

        uint256 day = hyperdustStorage.getUint(
            hyperdustStorage.genKey("day", id)
        );
        uint256 price = hyperdustStorage.getUint(
            hyperdustStorage.genKey("price", id)
        );

        string memory coverImage = hyperdustStorage.getString(
            hyperdustStorage.genKey("coverImage", id)
        );
        string memory remark = hyperdustStorage.getString(
            hyperdustStorage.genKey("remark", id)
        );

        return (id, name, day, price, coverImage, remark);
    }

    function edit(
        uint256 id,
        string memory name,
        uint32 day,
        uint256 price,
        string memory coverImage,
        string memory remark
    ) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory name = hyperdustStorage.getString(
            hyperdustStorage.genKey("name", id)
        );

        require(bytes(name).length > 0, "not found");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setUint(hyperdustStorage.genKey("day", id), day);
        hyperdustStorage.setUint(hyperdustStorage.genKey("price", id), price);

        hyperdustStorage.setString(
            hyperdustStorage.genKey("coverImage", id),
            coverImage
        );
        hyperdustStorage.setString(
            hyperdustStorage.genKey("remark", id),
            remark
        );
        emit eveHNodeProductSave(id);
    }

    function del(uint256 id) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory name = hyperdustStorage.getString(
            hyperdustStorage.genKey("name", id)
        );

        require(bytes(name).length > 0, "not found");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), "");
    }
}
