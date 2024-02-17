import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/utils/math/Math.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../utils/StrUtil.sol";
import "./Hyperdust_Token.sol";

contract Hyperdust_GPUMining is OwnableUpgradeable {
    using Strings for *;
    using StrUtil for *;

    using Math for uint256;

    uint256 public TGE_timestamp;

    uint256 public _yearTime;

    uint256 public _GPUMiningTotalAward;

    uint256 private _GPUMiningCurrMiningRatio;

    uint256 constant FACTOR = 10 ** 18 * 100;

    uint256 private _GPUMiningCurrYearTotalSupply;

    uint256 public _epochAward;

    uint256 private _GPUMiningCurrYearTotalAward;

    uint256 private _GPUMiningReleaseInterval;

    uint256 private _GPUMiningRateInterval;

    uint256 private _GPUMiningAllowReleaseTime;

    uint256 private _lastGPUMiningRateTime;

    uint256 public _lastGPUMiningMintTime;

    uint256 public _GPUMiningCurrAward;

    address public _HyperdustTokenAddress;

    address public _HyperdustEcpochAwardsAddress;

    function getGPUMiningCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256, uint256)
    {
        require(
            _GPUMiningAllowReleaseTime > 0,
            "The commencement of the release of GPU mining has not yet commenced"
        );

        uint256 GPUMiningCurrMiningRatio = _GPUMiningCurrMiningRatio;
        uint256 GPUMiningCurrYearTotalAward = _GPUMiningCurrYearTotalAward;

        uint256 GPUMiningCurrYearTotalSupply = _GPUMiningCurrYearTotalSupply;

        uint256 epochAward = _epochAward;

        if (
            block.timestamp >= _lastGPUMiningRateTime + _GPUMiningRateInterval
        ) {
            GPUMiningCurrMiningRatio = Math.mulDiv(
                GPUMiningCurrMiningRatio,
                FACTOR,
                2 * FACTOR
            );

            require(GPUMiningCurrMiningRatio > 0, "currMiningRatio is 0");
        }

        if (
            block.timestamp >=
            _GPUMiningAllowReleaseTime + _GPUMiningReleaseInterval
        ) {
            GPUMiningCurrYearTotalAward = 0;

            GPUMiningCurrYearTotalSupply = Math.mulDiv(
                _GPUMiningTotalAward - _GPUMiningCurrAward,
                GPUMiningCurrMiningRatio,
                FACTOR
            );

            epochAward = GPUMiningCurrYearTotalSupply / 365 / 225;
        }

        if (block.timestamp >= _GPUMiningAllowReleaseTime) {
            if (block.timestamp - _lastGPUMiningMintTime >= 384) {
                return (
                    GPUMiningCurrYearTotalSupply - GPUMiningCurrYearTotalAward,
                    GPUMiningCurrYearTotalSupply,
                    epochAward
                );
            } else {
                return (0, GPUMiningCurrYearTotalSupply, epochAward);
            }
        } else {
            return (0, 0, epochAward);
        }
    }

    function initialize(
        address onlyOwner,
        uint256 yearTime
    ) public initializer {
        __Ownable_init(onlyOwner);
        _yearTime = yearTime;
        _GPUMiningTotalAward = (200000000 ether * 68) / 100;
        _GPUMiningCurrMiningRatio = 10 * 10 ** 18;
        _GPUMiningCurrYearTotalSupply = Math.mulDiv(
            _GPUMiningTotalAward,
            _GPUMiningCurrMiningRatio,
            FACTOR
        );

        _epochAward = _GPUMiningCurrYearTotalSupply / 365 / 225;

        _GPUMiningReleaseInterval = yearTime;
        _GPUMiningRateInterval = 4 * _yearTime;
    }

    function setHyperdustTokenAddress(
        address HyperdustTokenAddress
    ) public onlyOwner {
        _HyperdustTokenAddress = HyperdustTokenAddress;
    }

    function setHyperdustEcpochAwardsAddress(
        address HyperdustEcpochAwardsAddress
    ) public onlyOwner {
        _HyperdustEcpochAwardsAddress = HyperdustEcpochAwardsAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _HyperdustTokenAddress = contractaddressArray[0];
        _HyperdustEcpochAwardsAddress = contractaddressArray[1];
    }

    function startTGETimestamp() public onlyOwner {
        require(TGE_timestamp == 0, "TGE_timestamp is not 0");

        TGE_timestamp = block.timestamp;
        _GPUMiningAllowReleaseTime = TGE_timestamp;
        _lastGPUMiningRateTime = TGE_timestamp;
    }

    function mint(address account, uint256 mintNum) public {
        require(
            msg.sender == _HyperdustEcpochAwardsAddress,
            "msg.sender is not allowed"
        );

        if (
            block.timestamp >= _lastGPUMiningRateTime + _GPUMiningRateInterval
        ) {
            _GPUMiningCurrMiningRatio = _GPUMiningCurrMiningRatio / 2;
            require(_GPUMiningCurrMiningRatio > 0, "currMiningRatio is 0");

            _lastGPUMiningRateTime += _GPUMiningRateInterval;
        }

        if (
            block.timestamp >=
            _GPUMiningAllowReleaseTime + _GPUMiningReleaseInterval
        ) {
            _GPUMiningCurrYearTotalAward = 0;

            _GPUMiningAllowReleaseTime += _GPUMiningReleaseInterval;

            _GPUMiningCurrYearTotalSupply = Math.mulDiv(
                _GPUMiningTotalAward - _GPUMiningCurrAward,
                _GPUMiningCurrMiningRatio,
                FACTOR
            );

            _epochAward = _GPUMiningCurrYearTotalSupply / 365 / 225;
        }

        require(
            _GPUMiningCurrYearTotalSupply -
                _GPUMiningCurrYearTotalAward -
                mintNum >=
                0,
            "currYearTotalSupply is not enough"
        );

        require(
            _GPUMiningTotalAward - _GPUMiningCurrAward - mintNum >= 0,
            "GPUMiningTotalAward is not enough"
        );

        // require(_epochAward >= mintNum, "epochAward is not enough");

        _GPUMiningCurrYearTotalAward += mintNum;
        _GPUMiningCurrAward += mintNum;

        _lastGPUMiningMintTime = block.timestamp;

        Hyperdust_Token(_HyperdustTokenAddress).mint(mintNum);

        IERC20(_HyperdustTokenAddress).transfer(account, mintNum);
    }
}
