pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_World_Map is Ownable {
    address _rolesCfgAddress;

    using Counters for Counters.Counter;
    using Strings for *;
    using StrUtil for *;

    WorldMap[] public _worldMaps;

    mapping(uint256 => bool) public _coordinateMap;

    struct WorldMap {
        uint256 spaceTVLId;
        uint256 coordinate;
        bool isMint;
    }

    event eveAdd(uint256[] spaceTVLIds, uint256[] coordinates, bool[] isMints);

    event eveDelete(uint256[] coordinates);

    event eveUpdate(uint256 coordinate, bool isMint);

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function add(
        uint256[] memory spaceTVLIds,
        uint256[] memory coordinates
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        bool[] memory isMints = new bool[](spaceTVLIds.length);

        for (uint256 i = 0; i < spaceTVLIds.length; i++) {
            if (_coordinateMap[coordinates[i]]) {
                revert(
                    coordinates[i].toString().toSlice().concat(
                        " coordinate already exists".toSlice()
                    )
                );
            }

            _worldMaps.push(WorldMap(spaceTVLIds[i], coordinates[i], false));
            _coordinateMap[coordinates[i]] = true;

            isMints[i] = false;
        }

        emit eveAdd(spaceTVLIds, coordinates, isMints);
    }

    function del(uint256[] memory coordinates) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint256 i = 0; i < coordinates.length; i++) {
            require(
                _coordinateMap[coordinates[i]],
                coordinates[i].toString().toSlice().concat(
                    " coordinate does not exist".toSlice()
                )
            );

            for (uint256 j = 0; j < _worldMaps.length; j++) {
                if (_worldMaps[j].coordinate == coordinates[i]) {
                    _worldMaps[i] = _worldMaps[_worldMaps.length - 1];
                    _worldMaps.pop();
                    _coordinateMap[coordinates[j]] = false;
                }
            }
        }
        emit eveDelete(coordinates);
    }

    function updateMintStatus(uint256 coordinate, bool isMint) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        require(
            _coordinateMap[coordinate],
            coordinate.toString().toSlice().concat(
                " coordinate does not exist".toSlice()
            )
        );

        for (uint256 i = 0; i < _worldMaps.length; i++) {
            if (
                keccak256(abi.encodePacked(_worldMaps[i].coordinate)) ==
                keccak256(abi.encodePacked(coordinate))
            ) {
                _worldMaps[i].isMint = isMint;
            }
        }

        emit eveUpdate(coordinate, isMint);
    }

    function getWorldMap(uint256 id) public view returns (WorldMap memory) {
        for (uint256 i = 0; i < _worldMaps.length; i++) {
            if (_worldMaps[i].coordinate == id) {
                return _worldMaps[i];
            }
        }

        revert("not found");
    }
}
