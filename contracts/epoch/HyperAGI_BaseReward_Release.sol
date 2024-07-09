pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../utils/StrUtil.sol";

import "../HyperAGI_Storage.sol";

import "../HyperAGI_Roles_Cfg.sol";

contract HyperAGI_BaseReward_Release is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    address public _rolesCfgAddress;

    uint256 public _intervalTime;

    uint256 public _intervalCount;

    address public _storageAddress;

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

    function setStorageAddress(address storageAddress) public onlyOwner {
        _storageAddress = storageAddress;
    }

    function setIntervalTime(uint256 intervalTime) public onlyOwner {
        _intervalTime = intervalTime;
    }

    function setIntervalCount(uint256 intervalCount) public onlyOwner {
        _intervalCount = intervalCount;
    }

    function setContractAddress(address[] memory contractaddressArray) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];

        _storageAddress = contractaddressArray[1];
    }

    function addBaseRewardReleaseRecord(uint256 amount, address account) public payable {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");

        require(amount == msg.value, "amount error");

        transferETH(payable(0xE297ce296D00381b2341c7e78662BF18eDD683d2), amount);

        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

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

            uint256 _amount = storageAddress.getUint(amountKey) + avgAmount;

            storageAddress.setUint(amountKey, _amount);

            uint256 releaseAmount = storageAddress.getUint(releaseAmountKey);

            releaseTimes[i] = time;
            amounts[i] = _amount;
            releaseAmounts[i] = releaseAmount;

            time += _intervalTime;
        }

        emit eveSave(amounts, releaseAmounts, releaseTimes, account);
    }

    function release(uint256[] memory times) public {
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

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

            uint256 amount = storageAddress.getUint(amountKey);

            uint256 releaseAmount = storageAddress.getUint(releaseAmountKey);
            if (amount == releaseAmount) {
                continue;
            }

            totalReleaseAmount += (amount - releaseAmount);

            storageAddress.setUint(releaseAmountKey, amount);

            amounts[i] = amount;
            releaseTimes[i] = time;
            releaseAmounts[i] = amount;
        }

        transferETH(payable(msg.sender), totalReleaseAmount);

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
        HyperAGI_Storage storageAddress = HyperAGI_Storage(_storageAddress);

        string memory key = account.toHexString().toSlice().concat(time.toString().toSlice());

        string memory amountKey = key.toSlice().concat("_amount".toSlice());
        string memory releaseAmountKey = key.toSlice().concat("_releaseAmount".toSlice());

        uint256 amount = storageAddress.getUint(amountKey);
        uint256 releaseAmount = storageAddress.getUint(releaseAmountKey);

        return (amount, releaseAmount);
    }

    function setDayTime(uint256 dayTime) public onlyOwner {
        _dayTime = dayTime;
    }

    function transferETH(address payable recipient, uint256 amount) private {
        require(address(this).balance >= amount, "Insufficient balance in contract");
        recipient.transfer(amount);
    }
}
