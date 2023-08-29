pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Space_TVL is Ownable {
    address public _rolesCfgAddress;

    using Counters for Counters.Counter;
    Counters.Counter private _id;
    using Strings for *;
    using StrUtil for *;

    SpaceTVL[] public _spaceTVLs;

    struct SpaceTVL {
        uint256 id;
        uint256 orderNum;
        string name;
        string coverImage;
        string remark;
        uint256 payPrice;
        uint256 pledgePrice;
        uint256 airdropPrice;
    }

    event eveAdd(
        uint256 id,
        uint256 orderNum,
        string name,
        string coverImage,
        string remark,
        uint256 payPrice,
        uint256 pledgePrice,
        uint256 airdropPrice
    );

    event eveUpdate(
        uint256 id,
        uint256 orderNum,
        string name,
        string coverImage,
        string remark,
        uint payPrice,
        uint pledgePrice,
        uint256 airdropPrice
    );

    event eveDelete(uint256 id);

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function add(
        uint256 orderNum,
        string memory name,
        string memory coverImage,
        string memory remark,
        uint256 payPrice,
        uint256 pledgePrice,
        uint256 airdropPrice
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        _id.increment();
        uint256 id = _id.current();
        _spaceTVLs.push(
            SpaceTVL({
                id: id,
                orderNum: orderNum,
                name: name,
                coverImage: coverImage,
                remark: remark,
                payPrice: payPrice,
                pledgePrice: pledgePrice,
                airdropPrice: airdropPrice
            })
        );
        emit eveAdd(
            id,
            orderNum,
            name,
            coverImage,
            remark,
            payPrice,
            pledgePrice,
            airdropPrice
        );
    }

    function update(
        uint256 id,
        uint256 orderNum,
        string memory name,
        string memory coverImage,
        string memory remark,
        uint256 payPrice,
        uint256 pledgePrice,
        uint256 airdropPrice
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );
        for (uint256 i = 0; i < _spaceTVLs.length; i++) {
            if (_spaceTVLs[i].id == id) {
                _spaceTVLs[i].orderNum = orderNum;
                _spaceTVLs[i].name = name;
                _spaceTVLs[i].coverImage = coverImage;
                _spaceTVLs[i].remark = remark;
                _spaceTVLs[i].payPrice = payPrice;
                _spaceTVLs[i].pledgePrice = pledgePrice;
                _spaceTVLs[i].airdropPrice = airdropPrice;
                break;
            }
        }
        emit eveUpdate(
            id,
            orderNum,
            name,
            coverImage,
            remark,
            payPrice,
            pledgePrice,
            airdropPrice
        );
    }

    function deleteSpaceTVL(uint256 id) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        uint256 index = 0;

        for (uint i = 0; i < _spaceTVLs.length; i++) {
            if (_spaceTVLs[i].id == id) {
                index = i + 1;
                break;
            }
        }

        require(index > 0, "not found");
        _spaceTVLs[index - 1] = _spaceTVLs[_spaceTVLs.length - 1];
        _spaceTVLs.pop();

        emit eveDelete(id);
    }

    function getSpaceTVL(uint256 id) public view returns (SpaceTVL memory) {
        for (uint256 i = 0; i < _spaceTVLs.length; i++) {
            if (_spaceTVLs[i].id == id) {
                return _spaceTVLs[i];
            }
        }
    }
}
