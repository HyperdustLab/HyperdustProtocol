// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../Hyperdust_Roles_Cfg.sol";

import "../utils/StrUtil.sol";

contract Hyperdust_Node_Product is Ownable {
    using Strings for *;
    using StrUtil for *;

    address public _HyperdustRolesCfgAddress;

    function setHyperdustRolesCfgAddress(
        address HyperdustRolesCfgAddress
    ) public onlyOwner {
        _HyperdustRolesCfgAddress = HyperdustRolesCfgAddress;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _id;

    struct HNodeProduct {
        uint256 id;
        string name;
        uint32 day;
        uint256 price;
        string coverImage;
        string remark;
    }

    event eveHNodeProductSave(uint256 id);

    event eveDeleteProductSave(uint256 id);

    HNodeProduct[] public _nodeProducts;

    function add(
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

        _id.increment();

        _nodeProducts.push(
            HNodeProduct(_id.current(), name, day, price, coverImage, remark)
        );

        emit eveHNodeProductSave(_id.current());
    }

    function get(
        uint256 id
    )
        public
        view
        returns (
            uint256,
            string memory,
            uint32,
            uint256,
            string memory,
            string memory
        )
    {
        for (uint256 i = 0; i < _nodeProducts.length; i++) {
            if (_nodeProducts[i].id == id) {
                return (
                    _nodeProducts[i].id,
                    _nodeProducts[i].name,
                    _nodeProducts[i].day,
                    _nodeProducts[i].price,
                    _nodeProducts[i].coverImage,
                    _nodeProducts[i].remark
                );
            }
        }

        revert("id not exist");
    }

    function list() public view returns (HNodeProduct[] memory) {
        return _nodeProducts;
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

        for (uint256 i = 0; i < _nodeProducts.length; i++) {
            if (_nodeProducts[i].id == id) {
                _nodeProducts[i].name = name;
                _nodeProducts[i].day = day;
                _nodeProducts[i].price = price;
                _nodeProducts[i].coverImage = coverImage;
                _nodeProducts[i].remark = remark;

                emit eveHNodeProductSave(id);

                return;
            }
        }

        revert("id not exist");
    }

    function del(uint256 id) public {
        require(
            Hyperdust_Roles_Cfg(_HyperdustRolesCfgAddress).hasAdminRole(
                msg.sender
            ),
            "not admin role"
        );

        for (uint256 i = 0; i < _nodeProducts.length; i++) {
            if (_nodeProducts[i].id == id) {
                delete _nodeProducts[i];

                _nodeProducts[i] = _nodeProducts[_nodeProducts.length - 1];
                _nodeProducts.pop();

                emit eveDeleteProductSave(id);

                return;
            }
        }

        revert("id not exist");
    }
}
