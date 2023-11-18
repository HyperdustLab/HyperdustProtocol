pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./Hyperdust_Roles_Cfg.sol";

import "./utils/StrUtil.sol";

contract Hyperdust_Space is Ownable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;

    using Counters for Counters.Counter;
    Counters.Counter private _id;

    struct Space {
        uint256 id;
        string name;
        string downloadLink;
        string description;
        string spaceId;
        string deploymentPath;
        string status;
        string currentVersion;
        string lastVersion;
        address accout;
        string coverImage;
    }

    event eveSpaceSave(uint256 id);
    event eveDeleteSave(uint256 id);

    Space[] public _spaces;

    function setHyperdustRolesCfgAddress(
        address HyperdustRolesCfgAddress
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    function addSpace(
        string memory name,
        string memory downloadLink,
        string memory description,
        string memory currentVersion,
        string memory coverImage
    ) public {
        _id.increment();

        _spaces.push(
            Space(
                _id.current(),
                name,
                downloadLink,
                description,
                "",
                "",
                "0",
                currentVersion,
                "",
                msg.sender,
                coverImage
            )
        );
        emit eveSpaceSave(_id.current());
    }

    function updateSpace(
        uint256 id,
        string memory name,
        string memory coverImage,
        string memory description
    ) public {
        for (uint i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                require(_spaces[i].accout == msg.sender, "not owner");

                _spaces[i].name = name;
                _spaces[i].coverImage = coverImage;
                _spaces[i].description = description;

                emit eveSpaceSave(id);

                return;
            }
        }

        revert("space not found");
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
            string memory
        )
    {
        for (uint256 i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                return (
                    _spaces[i].id,
                    _spaces[i].name,
                    _spaces[i].downloadLink,
                    _spaces[i].description,
                    _spaces[i].spaceId,
                    _spaces[i].deploymentPath,
                    _spaces[i].status,
                    _spaces[i].currentVersion,
                    _spaces[i].lastVersion,
                    _spaces[i].accout,
                    _spaces[i].coverImage
                );
            }
        }

        revert("space not found");
    }

    function release(
        uint256 id,
        string memory lastVersion,
        string memory downloadLink
    ) public {
        for (uint i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                require(_spaces[i].accout == msg.sender, "not owner");

                _spaces[i].lastVersion = lastVersion;
                _spaces[i].downloadLink = downloadLink;
                _spaces[i].status = "1";

                emit eveSpaceSave(id);

                return;
            }
        }

        revert("space not found");
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

        for (uint i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                _spaces[i].status = status;
                _spaces[i].deploymentPath = deploymentPath;
                _spaces[i].spaceId = spaceId;

                emit eveSpaceSave(_spaces[i].id);

                return;
            }
        }

        revert("space not found");
    }

    function reviewRelease(uint256 id, string memory status) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        for (uint i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                _spaces[i].status = status;

                emit eveSpaceSave(id);

                return;
            }
        }

        revert("space not found");
    }

    function delSpace(uint256 id) public {
        for (uint i = 0; i < _spaces.length; i++) {
            if (_spaces[i].id == id) {
                _spaces[i] = _spaces[_spaces.length - 1];
                _spaces.pop();

                emit eveDeleteSave(id);
                return;
            }
        }

        revert("space not found");
    }
}
