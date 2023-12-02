pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_BaseReward_Release is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _id;

    struct BaseRewardReleaseRecord {
        uint256 id;
        uint256 amount;
        uint256 releaseTime;
        address account;
        uint256 nodeId;
    }

    address public _rolesCfgAddress;
    address public _erc20Address;

    uint256 public _intervalTime = 30 days;

    uint256 public _intervalCount = 12;

    event eveSave(
        uint256[] ids,
        uint256 amount,
        uint256[] releaseTimes,
        address account,
        uint256 nodeId,
        uint256 nonce
    );

    event eveRelease(uint256[] ids);

    mapping(address => BaseRewardReleaseRecord[])
        public _baseRewardReleaseRecordsMap;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setERC20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setIntervalTime(uint256 intervalTime) public onlyOwner {
        _intervalTime = intervalTime;
    }

    function setIntervalCount(uint256 intervalCount) public onlyOwner {
        _intervalCount = intervalCount;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
    }

    function addBaseRewardReleaseRecord(
        uint256 amount,
        address account,
        uint256 nodeId,
        uint256 nonce
    ) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        uint256 time = block.timestamp;

        uint256 avgAmount = amount / _intervalCount;

        if (avgAmount == 0) {
            return;
        }

        uint256[] memory ids = new uint256[](_intervalCount);
        uint256[] memory releaseTimes = new uint256[](_intervalCount);

        for (uint256 i = 0; i < _intervalCount; i++) {
            _id.increment();

            ids[i] = _id.current();
            releaseTimes[i] = time + _intervalTime * i;

            _baseRewardReleaseRecordsMap[account].push(
                BaseRewardReleaseRecord(
                    _id.current(),
                    avgAmount,
                    releaseTimes[i],
                    account,
                    nodeId
                )
            );
        }

        emit eveSave(ids, avgAmount, releaseTimes, account, nodeId, nonce);
    }

    function release(uint256[] memory ids) public {
        uint256 amount = 0;

        for (uint256 i = 0; i < ids.length; i++) {
            amount += release(ids[i]);
        }

        IERC20(_erc20Address).transfer(msg.sender, amount);
        emit eveRelease(ids);
    }

    function release(uint256 id) private returns (uint256) {
        BaseRewardReleaseRecord[]
            memory baseRewardReleaseRecords = _baseRewardReleaseRecordsMap[
                msg.sender
            ];

        uint256 totalSize = baseRewardReleaseRecords.length;

        uint256 currTime = block.timestamp;

        for (uint256 i = 0; i < totalSize; i++) {
            if (baseRewardReleaseRecords[i].id == id) {
                if (currTime >= baseRewardReleaseRecords[i].releaseTime) {
                    uint256 amount = baseRewardReleaseRecords[i].amount;

                    _baseRewardReleaseRecordsMap[msg.sender][
                        i
                    ] = baseRewardReleaseRecords[totalSize - 1];
                    _baseRewardReleaseRecordsMap[msg.sender].pop();

                    return amount;
                } else {
                    revert(
                        id.toString().toSlice().concat(
                            " not release time".toSlice()
                        )
                    );
                }
            }
        }

        revert(id.toString().toSlice().concat(" not found".toSlice()));
    }

    function getBaseRewardReleaseRecords(
        address account
    )
        public
        view
        returns (uint256[] memory, uint256[] memory, uint256[] memory)
    {
        BaseRewardReleaseRecord[]
            memory baseRewardReleaseRecords = _baseRewardReleaseRecordsMap[
                account
            ];
        uint256[] memory ids = new uint256[](baseRewardReleaseRecords.length);
        uint256[] memory amounts = new uint256[](
            baseRewardReleaseRecords.length
        );
        uint256[] memory releaseTime = new uint256[](
            baseRewardReleaseRecords.length
        );

        for (uint256 i = 0; i < baseRewardReleaseRecords.length; i++) {
            ids[i] = baseRewardReleaseRecords[i].id;
            amounts[i] = baseRewardReleaseRecords[i].amount;
            releaseTime[i] = baseRewardReleaseRecords[i].releaseTime;
        }

        return (ids, amounts, releaseTime);
    }
}
