import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./HyperAGI_Token.sol";
import "../utils/StrUtil.sol";

contract HyperAGI_VestingWallet is OwnableUpgradeable, AccessControlUpgradeable {
    using Strings for *;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(address => uint256) private _accountTotalAllocation;
    mapping(address => uint256) private _accountReleased;

    address public _HyperdustTokenAddress;

    uint256 public _releaseInterval;

    uint256 public _start;
    uint256 public _end;

    uint256 public _totalAllocation;
    uint256 public _totalReleased;

    uint256 public _delayVestingNum;

    uint256 public _firestRate;

    uint256 public _linearVestingNum;

    bytes32 public _businessName;

    event eveUpdate(bytes32 businessName, address[] accounts, uint256[] totalAllocations, uint256[] releaseds);

    function initialize(address onlyOwner, uint256 releaseInterval, uint256 delayVestingNum, uint256 firestRate, uint256 linearVestingNum, bytes32 businessName) public initializer {
        __Ownable_init(onlyOwner);
        _grantRole(MINTER_ROLE, onlyOwner);
        _grantRole(DEFAULT_ADMIN_ROLE, onlyOwner);
        _releaseInterval = releaseInterval;
        _delayVestingNum = delayVestingNum;
        _firestRate = firestRate;
        _linearVestingNum = linearVestingNum;
        _businessName = businessName;
    }

    function totalAllocation(address account) public view returns (uint256) {
        return _accountTotalAllocation[account];
    }

    function released(address account) public view returns (uint256) {
        return _accountReleased[account];
    }

    function releasableTime(address account) public view returns (uint256) {
        uint256 accountTotalAllocation = totalAllocation(account);

        if (accountTotalAllocation == 0) {
            return 0;
        }

        HyperAGI_Token hyperdust_Token = HyperAGI_Token(_HyperdustTokenAddress);

        uint256 start = _start;
        uint256 end = _end;

        uint256 TGE_timestamp = hyperdust_Token.tgeTimestamp();

        if (TGE_timestamp == 0) {
            return 0;
        } else {
            if (start == 0) {
                start = TGE_timestamp + _delayVestingNum * _releaseInterval;
                end = start + _linearVestingNum * _releaseInterval;
            }
        }

        uint256 _released = released(account);

        if (_released == 0) {
            return start;
        }

        if (accountTotalAllocation == _released) {
            return 0;
        }

        if (block.timestamp >= end) {
            return end;
        }

        uint256 _releasable = releasable(account);

        if (_releasable > 0) {
            uint256 elapsed = (block.timestamp - start) % _releaseInterval;

            return block.timestamp - elapsed;
        } else {
            uint256 elapsed = (block.timestamp - start) % _releaseInterval;

            return block.timestamp + _releaseInterval - elapsed;
        }
    }

    function releasable(address account) public view returns (uint256) {
        HyperAGI_Token hyperdust_Token = HyperAGI_Token(_HyperdustTokenAddress);

        uint256 start = _start;
        uint256 end = _end;

        uint256 accountTotalAllocation = totalAllocation(account);

        if (accountTotalAllocation == 0) {
            return 0;
        }

        uint256 TGE_timestamp = hyperdust_Token.tgeTimestamp();

        if (TGE_timestamp == 0) {
            return 0;
        } else {
            if (start == 0) {
                start = TGE_timestamp + _delayVestingNum * _releaseInterval;
                end = start + _linearVestingNum * _releaseInterval;
            }
        }

        uint256 _released = released(account);

        if (block.timestamp < start) {
            return 0;
        }

        if (block.timestamp >= end) {
            return accountTotalAllocation - _released;
        }

        uint256 elapsed = block.timestamp - start;

        uint256 active = elapsed / _releaseInterval;
        if (elapsed % _releaseInterval > 0) {
            active += 1;
        } else {
            active++;
        }

        if (active == 0) {
            return 0;
        }

        uint256 firestRateAmount = 0;

        uint256 linearVestingNum = _linearVestingNum;

        if (_firestRate > 0) {
            active--;
            linearVestingNum--;
            firestRateAmount = (accountTotalAllocation * _firestRate) / 10000;
        }

        uint256 releaseIntervalAmount = (accountTotalAllocation - firestRateAmount) / linearVestingNum;

        uint256 activeAmount = releaseIntervalAmount * active + firestRateAmount;

        return activeAmount - _released;
    }

    function release() public {
        HyperAGI_Token hyperdust_Token = HyperAGI_Token(_HyperdustTokenAddress);

        uint256 TGE_timestamp = hyperdust_Token.tgeTimestamp();

        require(TGE_timestamp > 0, "TGE_timestamp is not started");

        if (_start == 0) {
            _start = TGE_timestamp + _delayVestingNum * _releaseInterval;
            _end = _start + _linearVestingNum * _releaseInterval;
        }

        uint256 amount = releasable(msg.sender);

        require(amount > 0, "amount is 0");

        hyperdust_Token.mint(amount);

        _totalReleased += amount;

        _accountReleased[msg.sender] += amount;

        IERC20(hyperdust_Token).transfer(msg.sender, amount);

        address[] memory accounts = new address[](1);
        uint256[] memory totalAllocations = new uint256[](1);
        uint256[] memory releaseds = new uint256[](1);

        accounts[0] = msg.sender;
        totalAllocations[0] = _accountTotalAllocation[msg.sender];
        releaseds[0] = _accountReleased[msg.sender];

        emit eveUpdate(_businessName, accounts, totalAllocations, releaseds);
    }

    function setHyperdustTokenAddress(address HyperdustTokenAddress) public onlyOwner {
        _HyperdustTokenAddress = HyperdustTokenAddress;
    }

    function appendAccountTotalAllocation(address[] memory accounts, uint256[] memory amounts) public onlyRole(MINTER_ROLE) {
        require(accounts.length == amounts.length, "accounts.length != amounts.length");
        uint256[] memory totalAllocations = new uint256[](accounts.length);
        uint256[] memory releaseds = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; i++) {
            address account = accounts[i];
            uint256 amount = amounts[i];

            _accountTotalAllocation[account] = _accountTotalAllocation[account] + amount;
            _totalAllocation = _totalAllocation + amount;

            totalAllocations[i] = _accountTotalAllocation[account];
            releaseds[i] = _accountReleased[account];
        }

        HyperAGI_Token hyperdust_Token = HyperAGI_Token(_HyperdustTokenAddress);

        uint256 totalAward = hyperdust_Token.getTotalAward(_businessName);

        require(_totalAllocation <= totalAward, "totalAward is not enough");

        emit eveUpdate(_businessName, accounts, totalAllocations, releaseds);
    }

    function revokeAccountTotalAllocation(address account, uint256 amount) public onlyRole(MINTER_ROLE) {
        uint256 accountReleased = released(account);
        uint256 accountTotalAllocation = totalAllocation(account);

        require(accountTotalAllocation >= accountReleased + amount, "accountTotalAllocation is not enough");

        _accountTotalAllocation[account] = accountTotalAllocation - amount;

        _totalAllocation -= amount;

        address[] memory accounts = new address[](1);
        uint256[] memory totalAllocations = new uint256[](1);
        uint256[] memory releaseds = new uint256[](1);

        accounts[0] = account;
        totalAllocations[0] = _accountTotalAllocation[account];
        releaseds[0] = _accountReleased[account];

        emit eveUpdate(_businessName, accounts, totalAllocations, releaseds);
    }
}
