pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./Hyperdust_Roles_Cfg.sol";

import "./utils/StrUtil.sol";

import "./Hyperdust_Storage.sol";

contract Hyperdust_Space is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;
    address public _HyperdustStorageAddress;

    event eveSpaceSave(uint256 id);
    event eveDeleteSave(uint256 id);

    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    function setHyperdustRolesCfgAddress(
        address HyperdustRolesCfgAddress
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function setHyperdustStorageAddress(
        address hyperdustStorageAddress
    ) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function addSpace(
        string memory name,
        string memory downloadLink,
        string memory description,
        string memory currentVersion,
        string memory coverImage,
        string memory image,
        string memory parameters
    ) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        uint256 id = hyperdustStorage.getNextId();

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setString(
            hyperdustStorage.genKey("downloadLink", id),
            downloadLink
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("description", id),
            description
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("currentVersion", id),
            currentVersion
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("coverImage", id),
            coverImage
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("coverImage", id),
            coverImage
        );

        hyperdustStorage.setString(hyperdustStorage.genKey("image", id), image);
        hyperdustStorage.setString(
            hyperdustStorage.genKey("parameters", id),
            parameters
        );

        hyperdustStorage.setString(hyperdustStorage.genKey("status", id), "0");

        hyperdustStorage.setAddress(
            hyperdustStorage.genKey("accout", id),
            msg.sender
        );

        emit eveSpaceSave(id);
    }

    function updateSpace(
        uint256 id,
        string memory name,
        string memory coverImage,
        string memory image,
        string memory description,
        string memory parameters
    ) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory name = hyperdustStorage.getString(
            hyperdustStorage.genKey("name", id)
        );

        require(bytes(name).length > 0, "not found");

        hyperdustStorage.setString(hyperdustStorage.genKey("name", id), name);
        hyperdustStorage.setString(
            hyperdustStorage.genKey("coverImage", id),
            coverImage
        );
        hyperdustStorage.setString(
            hyperdustStorage.genKey("description", id),
            description
        );

        hyperdustStorage.setString(hyperdustStorage.genKey("image", id), image);
        hyperdustStorage.setString(
            hyperdustStorage.genKey("parameters", id),
            parameters
        );

        emit eveSpaceSave(id);
    }

    function getSpace(
        uint256 id
    )
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            address,
            string memory,
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

        return (
            id,
            name,
            hyperdustStorage.getString(
                hyperdustStorage.genKey("downloadLink", id)
            ),
            hyperdustStorage.getString(
                hyperdustStorage.genKey("description", id)
            ),
            hyperdustStorage.getString(hyperdustStorage.genKey("spaceId", id)),
            hyperdustStorage.getString(
                hyperdustStorage.genKey("deploymentPath", id)
            ),
            hyperdustStorage.getString(hyperdustStorage.genKey("status", id)),
            hyperdustStorage.getString(
                hyperdustStorage.genKey("currentVersion", id)
            ),
            hyperdustStorage.getString(
                hyperdustStorage.genKey("lastVersion", id)
            ),
            hyperdustStorage.getAddress(hyperdustStorage.genKey("accout", id)),
            hyperdustStorage.getString(
                hyperdustStorage.genKey("coverImage", id)
            ),
            hyperdustStorage.getString(hyperdustStorage.genKey("image", id)),
            hyperdustStorage.getString(
                hyperdustStorage.genKey("parameters", id)
            )
        );
    }

    function release(
        uint256 id,
        string memory lastVersion,
        string memory downloadLink
    ) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(
            _HyperdustStorageAddress
        );

        string memory name = hyperdustStorage.getString(
            hyperdustStorage.genKey("name", id)
        );

        require(bytes(name).length > 0, "not found");

        address accout = hyperdustStorage.getAddress(
            hyperdustStorage.genKey("accout", id)
        );

        require(accout == msg.sender, "not owner");

        hyperdustStorage.setString(
            hyperdustStorage.genKey("lastVersion", id),
            lastVersion
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("downloadLink", id),
            downloadLink
        );

        hyperdustStorage.setString(hyperdustStorage.genKey("status", id), "1");

        emit eveSpaceSave(id);
    }

    function reviewAdd(
        uint256 id,
        string memory status,
        string memory deploymentPath,
        string memory spaceId
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

        hyperdustStorage.setString(
            hyperdustStorage.genKey("status", id),
            status
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("deploymentPath", id),
            deploymentPath
        );

        hyperdustStorage.setString(
            hyperdustStorage.genKey("spaceId", id),
            spaceId
        );

        emit eveSpaceSave(id);
    }

    function reviewRelease(uint256 id, string memory status) public {
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

        hyperdustStorage.setString(
            hyperdustStorage.genKey("status", id),
            status
        );
    }

    function delSpace(uint256 id) public {
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
