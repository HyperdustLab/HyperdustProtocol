pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../utils/StrUtil.sol";

import "../Hyperdust_Storage.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract Hyperdust_BaseReward_Release is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;
    address public _erc20Address;

    uint256 public _intervalTime;

    uint256 public _intervalCount;

    address public _HyperdustStorageAddress;

    uint256 public _dayTime;

    event eveSave(uint256[] amounts, uint256[] releaseAmounts, uint256[] releaseTimes, address account);

    function initialize(address onlyOwner) public initializer {
        _intervalTime = 30 days;
        _intervalCount = 12;
        _dayTime = 1 days;
        __Ownable_init(onlyOwner);
    }

    mapping(string => uint256[] amount) public _baseRewardReleaseRecordsMap;

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setERC20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setHyperdustStorageAddress(address hyperdustStorageAddress) public onlyOwner {
        _HyperdustStorageAddress = hyperdustStorageAddress;
    }

    function setIntervalTime(uint256 intervalTime) public onlyOwner {
        _intervalTime = intervalTime;
    }

    function setIntervalCount(uint256 intervalCount) public onlyOwner {
        _intervalCount = intervalCount;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _HyperdustStorageAddress = contractaddressArray[2];
    }

    function addBaseRewardReleaseRecord(uint256 amount, address account) public {
        require(IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        uint256 time = getStartOfToday();

        uint256 avgAmount = amount / _intervalCount;

        if (avgAmount == 0) {
            return;
        }

        uint256[] memory amounts = new uint256[](_intervalCount);
        uint256[] memory releaseTimes = new uint256[](_intervalCount);
        uint256[] memory releaseAmounts = new uint256[](_intervalCount);

        for (uint256 i = 0; i < _intervalCount; i++) {
            string memory key = account.toHexString().toSlice().concat(time.toString().toSlice());

            string memory amountKey = key.toSlice().concat("_amount".toSlice());
            string memory releaseAmountKey = key.toSlice().concat("_releaseAmount".toSlice());

            uint256 _amount = hyperdustStorage.getUint(amountKey) + avgAmount;

            hyperdustStorage.setUint(amountKey, _amount);

            uint256 releaseAmount = hyperdustStorage.getUint(releaseAmountKey);

            releaseTimes[i] = time;
            amounts[i] = _amount;
            releaseAmounts[i] = releaseAmount;

            time += _intervalTime;
        }

        emit eveSave(amounts, releaseAmounts, releaseTimes, account);
    }

    function release(uint256[] memory times) public {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        uint256 totalReleaseAmount = 0;

        uint256[] memory amounts = new uint256[](times.length);
        uint256[] memory releaseTimes = new uint256[](times.length);
        uint256[] memory releaseAmounts = new uint256[](times.length);

        for (uint i = 0; i < times.length; i++) {
            uint256 time = times[i];

            require(block.timestamp >= time, "time error");

            string memory key = msg.sender.toHexString().toSlice().concat(time.toString().toSlice());

            string memory amountKey = key.toSlice().concat("_amount".toSlice());
            string memory releaseAmountKey = key.toSlice().concat("_releaseAmount".toSlice());

            uint256 amount = hyperdustStorage.getUint(amountKey);

            uint256 releaseAmount = hyperdustStorage.getUint(releaseAmountKey);
            if (amount == releaseAmount) {
                continue;
            }

            totalReleaseAmount += (amount - releaseAmount);

            hyperdustStorage.setUint(releaseAmountKey, amount);

            amounts[i] = amount;
            releaseTimes[i] = time;
            releaseAmounts[i] = amount;
        }

        IERC20(_erc20Address).transfer(msg.sender, totalReleaseAmount);

        emit eveSave(amounts, releaseAmounts, releaseTimes, msg.sender);
    }

    function getStartOfToday() private view returns (uint256) {
        uint256 currentTime = block.timestamp;
        if (_dayTime == 0) {
            return currentTime;
        }
        uint256 startOfDay = currentTime - (currentTime % _dayTime);
        return startOfDay;
    }

    function findAmount(address account, uint256 time) public view returns (uint256, uint256) {
        Hyperdust_Storage hyperdustStorage = Hyperdust_Storage(_HyperdustStorageAddress);

        string memory key = account.toHexString().toSlice().concat(time.toString().toSlice());

        string memory amountKey = key.toSlice().concat("_amount".toSlice());
        string memory releaseAmountKey = key.toSlice().concat("_releaseAmount".toSlice());

        uint256 amount = hyperdustStorage.getUint(amountKey);
        uint256 releaseAmount = hyperdustStorage.getUint(releaseAmountKey);

        return (amount, releaseAmount);
    }

    function setDayTime(uint256 dayTime) public onlyOwner {
        _dayTime = dayTime;
    }
}
