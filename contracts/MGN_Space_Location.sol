pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IRole {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Space_Location is Ownable {
    address _roleAddress;

    using Counters for Counters.Counter;
    using Strings for *;
    using StrUtil for *;

    SpaceLocation[] public _spaceLocations;

    mapping(uint256 => bool) public _coordinateMap;

    struct SpaceLocation {
        uint256 spaceTypeId; //空间分类ID
        uint256 coordinate; //场景坐标编号
        bool isMint; //是否已经铸造
    }

    event eveAdd(uint256[] spaceTypeIds, uint256[] coordinates, bool[] isMints);

    event eveDelete(uint256[] coordinates);

    event eveUpdate(uint256 coordinate, bool isMint);

    function setRoleAddress(address roleAddress) public onlyOwner {
        _roleAddress = roleAddress;
    }

    function add(
        uint256[] memory spaceTypeIds,
        uint256[] memory coordinates
    ) public {
        require(
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );

        bool[] memory isMints = new bool[](spaceTypeIds.length);

        for (uint256 i = 0; i < spaceTypeIds.length; i++) {
            if (_coordinateMap[coordinates[i]]) {
                revert(
                    coordinates[i].toString().toSlice().concat(
                        " coordinate already exists".toSlice()
                    )
                );
            }

            _spaceLocations.push(
                SpaceLocation(spaceTypeIds[i], coordinates[i], false)
            );
            _coordinateMap[coordinates[i]] = true;

            isMints[i] = false;
        }

        emit eveAdd(spaceTypeIds, coordinates, isMints);
    }

    function del(uint256[] memory coordinates) public {
        require(
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );

        for (uint256 i = 0; i < coordinates.length; i++) {
            require(
                _coordinateMap[coordinates[i]],
                coordinates[i].toString().toSlice().concat(
                    " coordinate does not exist".toSlice()
                )
            );

            for (uint256 j = 0; j < _spaceLocations.length; j++) {
                if (_spaceLocations[j].coordinate == coordinates[i]) {
                    _spaceLocations[i] = _spaceLocations[
                        _spaceLocations.length - 1
                    ];
                    _spaceLocations.pop();
                    _coordinateMap[coordinates[i]] = false;
                }
            }
        }
        emit eveDelete(coordinates);
    }

    function updateMintStatus(uint256 coordinate, bool isMint) public {
        require(
            IRole(_roleAddress).hasAdminRole(msg.sender),
            "Does not have admin role"
        );

        require(
            _coordinateMap[coordinate],
            coordinate.toString().toSlice().concat(
                " coordinate does not exist".toSlice()
            )
        );

        for (uint256 i = 0; i < _spaceLocations.length; i++) {
            if (
                keccak256(abi.encodePacked(_spaceLocations[i].coordinate)) ==
                keccak256(abi.encodePacked(coordinate))
            ) {
                _spaceLocations[i].isMint = isMint;
            }
        }

        emit eveUpdate(coordinate, isMint);
    }

    function getSpaceLocation(
        uint256 id
    ) public view returns (SpaceLocation memory) {
        for (uint256 i = 0; i < _spaceLocations.length; i++) {
            if (_spaceLocations[i].coordinate == id) {
                return _spaceLocations[i];
            }
        }

        revert("not found");
    }
}
