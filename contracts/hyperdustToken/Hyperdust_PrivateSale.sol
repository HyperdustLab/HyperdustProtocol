import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";
import "./Hyperdust_Token.sol";

contract Hyperdust_PrivateSale is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public TGE_timestamp;

    uint256 public _monthTime;

    uint256 public _PrivateSaleTotalAward;
    uint256 public _PrivateSaleCurrAward;
    uint256 private _PrivateSaleReleaseInterval;
    uint256 public _PrivateSaleReleaseTime;
    uint256 private _PrivateSaleReleaseTotalAward;
    uint256 private _PrivateSaleMonthReleaseAward;

    address public _HyperdustTokenAddress;

    address public _MintAccountAddress;

    function initialize(
        address onlyOwner,
        uint256 monthTime
    ) public initializer {
        __Ownable_init(onlyOwner);
        _monthTime = monthTime;
        _PrivateSaleTotalAward = (200000000 ether * 3) / 100;
        _PrivateSaleReleaseInterval = monthTime;
        _PrivateSaleReleaseTotalAward = (_PrivateSaleTotalAward * 75) / 1000;
        _PrivateSaleMonthReleaseAward =
            (_PrivateSaleTotalAward - _PrivateSaleReleaseTotalAward) /
            12;
    }

    function setHyperdustTokenAddress(
        address HyperdustTokenAddress
    ) public onlyOwner {
        _HyperdustTokenAddress = HyperdustTokenAddress;
    }

    function setMintAccountAddress(
        address MintAccountAddress
    ) public onlyOwner {
        _MintAccountAddress = MintAccountAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _HyperdustTokenAddress = contractaddressArray[0];
        _MintAccountAddress = contractaddressArray[1];
    }

    function getPrivateSaleCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _PrivateSaleReleaseTime > 0,
            "The commencement of the release of private sale has not yet commenced"
        );

        if (block.timestamp < _PrivateSaleReleaseTime) {
            return (0, 0);
        }

        uint256 PrivateSaleReleaseTotalAward = _PrivateSaleReleaseTotalAward;

        uint256 time = block.timestamp - _PrivateSaleReleaseTime;

        time = time - (time % _PrivateSaleReleaseInterval);

        uint256 num = time / _PrivateSaleReleaseInterval;

        if (num > 0) {
            uint256 addAward = _PrivateSaleMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (
                _PrivateSaleTotalAward <
                _PrivateSaleCurrAward + _PrivateSaleReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _PrivateSaleTotalAward -
                    _PrivateSaleCurrAward -
                    _PrivateSaleReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            PrivateSaleReleaseTotalAward += addAward;
        }

        return (
            PrivateSaleReleaseTotalAward - _PrivateSaleCurrAward,
            PrivateSaleReleaseTotalAward
        );
    }

    function mint(address account) public {
        require(msg.sender == _MintAccountAddress, "msg.sender is not allowed");

        require(
            _PrivateSaleReleaseTime > 0,
            "The commencement of the release of private sale has not yet commenced"
        );

        require(block.timestamp >= _PrivateSaleReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _PrivateSaleReleaseTime;

        time = time - (time % _PrivateSaleReleaseInterval);

        uint256 num = time / _PrivateSaleReleaseInterval;

        if (num > 0) {
            uint256 addAward = _PrivateSaleMonthReleaseAward * num;

            uint256 totalMintAward = 0;

            if (
                _PrivateSaleTotalAward <
                _PrivateSaleCurrAward + _PrivateSaleReleaseTotalAward
            ) {
                totalMintAward = 0;
            } else {
                totalMintAward =
                    _PrivateSaleTotalAward -
                    _PrivateSaleCurrAward -
                    _PrivateSaleReleaseTotalAward;
            }

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _PrivateSaleReleaseTotalAward += addAward;
            _PrivateSaleReleaseTime += num * _PrivateSaleReleaseInterval;
        }

        uint256 mintNum = _PrivateSaleReleaseTotalAward - _PrivateSaleCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _PrivateSaleCurrAward += mintNum;

        require(
            _PrivateSaleTotalAward >= _PrivateSaleCurrAward,
            "_PrivateSaleTotalAward is not enough"
        );

        Hyperdust_Token(_HyperdustTokenAddress).mint(mintNum);

        IERC20(_HyperdustTokenAddress).transfer(account, mintNum);
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
        _PrivateSaleReleaseTime = TGE_timestamp;
    }
}
