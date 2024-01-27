// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../utils/StrUtil.sol";

contract Hyperdust_Token_Test is ERC20, ERC20Burnable, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        address onlyOwner
    ) ERC20(name_, symbol_) Ownable(onlyOwner) {}

    using Strings for *;
    using StrUtil for *;

    uint256 public _monthTime = 30 days;
    uint256 public _yearTime = 365 days;

    uint256 public TGE_timestamp = 0;

    uint256 public _totalSupply = 200000000 ether;

    uint256 public _mintNum = 0;

    address public _GPUMiningAddress;

    uint256 public _GPUMiningTotalAward = (_totalSupply * 68) / 100;

    uint256 public _GPUMiningCurrAward = 0;

    uint256 private _GPUMiningCurrMiningRatio = 10 * 10 ** 18;

    uint256 constant FACTOR = 10 ** 18 * 100;

    uint256 private _GPUMiningCurrYearTotalSupply =
        Math.mulDiv(_GPUMiningTotalAward, _GPUMiningCurrMiningRatio, FACTOR);

    uint256 private _epochAward = _GPUMiningCurrYearTotalSupply / 365 / 225;

    uint256 private _GPUMiningCurrYearTotalAward = 0;

    uint256 private _GPUMiningReleaseInterval = _yearTime;

    uint256 private _GPUMiningRateInterval = 4 * _yearTime;

    uint256 public _GPUMiningAllowReleaseTime = 0;

    uint256 private _lastGPUMiningRateTime = 0;

    address public _CoreTeamAddeess;

    uint256 public _CoreTeamTotalAward = (_totalSupply * 115) / 1000;

    uint256 public _CoreTeamCurrAward = 0;

    uint256 public _CoreTeamAllowReleaseTime = 0;

    uint256 private _CoreTeamReleaseInterval = _monthTime;

    uint256 private _CoreTeamMonthReleaseAward = _CoreTeamTotalAward / 48;

    uint256 private _CoreTeamReleaseTotalAward = _CoreTeamMonthReleaseAward;

    address public _FoundationAddress;

    uint256 public _FoundationTotalAward = (_totalSupply * 1025) / 10000;

    uint256 public _FoundationCurrAward = 0;

    uint256 private _FoundationReleaseInterval = _monthTime;

    uint256 public _FoundationReleaseAllowReleaseTime = 0;

    uint256 private _FoundationMonthReleaseAward = _FoundationTotalAward / 48;

    uint256 private _FoundationReleaseTotalAward = _FoundationMonthReleaseAward;

    address public _AdvisorAddress;

    uint256 public _AdvisorAllowReleaseTime = 0;

    uint256 public _AdvisorTotalAward = (_totalSupply * 1) / 100;

    uint256 public _AdvisorCurrAward = 0;

    uint256 private _AdvisorReleaseInterval = _monthTime;

    uint256 private _AdvisorMonthReleaseAward = _AdvisorTotalAward / 12;

    uint256 private _AdvisorReleaseTotalAward = _AdvisorMonthReleaseAward;

    address public _SeedAddress;
    uint256 public _SeedAllowReleaseTime = 0;

    uint256 public _SeedTotalAward = (_totalSupply * 125) / 10000;

    uint256 public _SeedCurrAward = 0;

    uint256 private _SeedReleaseInterval = _monthTime;

    uint256 private _SeedReleaseTotalAward = (_SeedTotalAward * 5) / 100;

    uint256 private _SeedMonthReleaseAward =
        (_SeedTotalAward - _SeedReleaseTotalAward) / 18;

    address public _PrivateSaleAddress;

    uint256 public _PrivateSaleTotalAward = (_totalSupply * 3) / 100;
    uint256 public _PrivateSaleCurrAward = 0;

    uint256 private _PrivateSaleReleaseInterval = _monthTime;

    uint256 public _PrivateSaleReleaseTime = 0;
    uint256 private _PrivateSaleReleaseTotalAward =
        (_PrivateSaleTotalAward * 75) / 1000;

    uint256 private _PrivateSaleMonthReleaseAward =
        (_PrivateSaleTotalAward - _PrivateSaleReleaseTotalAward) / 12;

    address public _PublicSaleAddress;

    uint256 public _PublicSaleTotalAward = (_totalSupply * 3) / 100;
    uint256 public _PublicSaleCurrAward = 0;

    uint256 private _PublicSaleReleaseInterval = _monthTime;

    uint256 public _PublicSaleReleaseTime = 0;
    uint256 private _PublicSaleReleaseTotalAward =
        (_PublicSaleTotalAward * 25) / 100;

    uint256 private _PublicSaleMonthReleaseAward =
        (_PublicSaleTotalAward - _PublicSaleReleaseTotalAward) / 9;

    address public _AirdropAddress;

    uint256 public _AirdropTotalAward = (_totalSupply * 2) / 100;
    uint256 public _AirdropCurrAward = 0;

    uint256 private _AirdropReleaseInterval = _monthTime;

    uint256 public _AirdropReleaseTime = 0;
    uint256 private _AirdropReleaseMonthAward = _AirdropTotalAward / 12;

    uint256 private _AirdropReleaseTotalAward = _AirdropReleaseMonthAward;

    function setGPUMiningAddress(address GPUMiningAddress) public onlyOwner {
        _GPUMiningAddress = GPUMiningAddress;
    }

    function setCoreTeamAddress(address CoreTeamAddress) public onlyOwner {
        _CoreTeamAddeess = CoreTeamAddress;
    }

    function setFoundationAddress(address FoundationAddress) public onlyOwner {
        _FoundationAddress = FoundationAddress;
    }

    function setAdvisorAddress(address AdvisorAddress) public onlyOwner {
        _AdvisorAddress = AdvisorAddress;
    }

    function setSeedAddress(address SeedAddress) public onlyOwner {
        _SeedAddress = SeedAddress;
    }

    function setPrivateSaleAddress(
        address PrivateSaleAddress
    ) public onlyOwner {
        _PrivateSaleAddress = PrivateSaleAddress;
    }

    function setPublicSaleAddress(address PublicSaleAddress) public onlyOwner {
        _PublicSaleAddress = PublicSaleAddress;
    }

    function setAirdropAddress(address AirdropAddress) public onlyOwner {
        _AirdropAddress = AirdropAddress;
    }

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
            return (
                GPUMiningCurrYearTotalSupply - GPUMiningCurrYearTotalAward,
                GPUMiningCurrYearTotalSupply,
                epochAward
            );
        } else {
            return (0, 0, epochAward);
        }
    }

    function GPUMiningMint(uint256 mintNum) public {
        require(msg.sender == _GPUMiningAddress, "msg.sender is not allowed");
        require(
            _GPUMiningAllowReleaseTime > 0,
            "The commencement of the release of GPU mining has not yet commenced"
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

        require(_epochAward >= mintNum, "epochAward is not enough");

        _GPUMiningCurrYearTotalAward += mintNum;
        _GPUMiningCurrAward += mintNum;
        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_GPUMiningAddress, mintNum);
    }

    function getCoreTeamCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _CoreTeamAllowReleaseTime > 0,
            "The commencement of the release of core team has not yet commenced"
        );

        if (block.timestamp < _CoreTeamAllowReleaseTime) {
            return (0, 0);
        }

        uint256 CoreTeamReleaseTotalAward = _CoreTeamReleaseTotalAward;
        uint256 time = block.timestamp - _CoreTeamAllowReleaseTime;

        time = time - (time % _CoreTeamReleaseInterval);

        uint256 num = time / _AdvisorReleaseInterval;

        if (num > 0) {
            uint256 addAward = _CoreTeamMonthReleaseAward * (num);

            uint256 totalMintAward = _CoreTeamTotalAward -
                _CoreTeamCurrAward -
                _CoreTeamReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            CoreTeamReleaseTotalAward += addAward;
        }

        return (
            CoreTeamReleaseTotalAward - _CoreTeamCurrAward,
            CoreTeamReleaseTotalAward
        );
    }

    function CoreTeamMint() private {
        require(
            _CoreTeamAllowReleaseTime > 0,
            "The commencement of the release of core team has not yet commenced"
        );

        require(block.timestamp >= _CoreTeamAllowReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _CoreTeamAllowReleaseTime;

        time = time - (time % _CoreTeamReleaseInterval);

        uint256 num = time / _CoreTeamReleaseInterval;

        if (num > 0) {
            uint256 addAward = _CoreTeamMonthReleaseAward * num;

            uint256 totalMintAward = _CoreTeamTotalAward -
                _CoreTeamCurrAward -
                _CoreTeamReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _CoreTeamReleaseTotalAward += addAward;
            _CoreTeamAllowReleaseTime += num * _CoreTeamReleaseInterval;
        }

        uint256 mintNum = _CoreTeamReleaseTotalAward - _CoreTeamCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _CoreTeamCurrAward += mintNum;

        require(
            _CoreTeamTotalAward >= _CoreTeamCurrAward,
            "CoreTeamTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_CoreTeamAddeess, mintNum);
    }

    function getFoundationCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _FoundationReleaseAllowReleaseTime > 0,
            "The commencement of the release of foundation has not yet commenced"
        );

        if (block.timestamp < _FoundationReleaseAllowReleaseTime) {
            return (0, 0);
        }

        uint256 FoundationReleaseTotalAward = _FoundationReleaseTotalAward;

        uint256 time = block.timestamp - _FoundationReleaseAllowReleaseTime;

        time = time - (time % _FoundationReleaseInterval);

        uint256 num = time / _FoundationReleaseInterval;

        if (num > 0) {
            uint256 addAward = _FoundationMonthReleaseAward * num;

            uint256 totalMintAward = _FoundationTotalAward -
                _FoundationCurrAward -
                _FoundationReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            FoundationReleaseTotalAward += addAward;
        }

        return (
            FoundationReleaseTotalAward - _FoundationCurrAward,
            FoundationReleaseTotalAward
        );
    }

    function FoundationMint() private {
        require(
            _FoundationReleaseAllowReleaseTime > 0,
            "The commencement of the release of foundation has not yet commenced"
        );

        require(
            block.timestamp >= _FoundationReleaseAllowReleaseTime,
            "time is not ok"
        );
        uint256 time = block.timestamp - _FoundationReleaseAllowReleaseTime;

        time = time - (time % _FoundationReleaseInterval);

        uint256 num = time / _FoundationReleaseInterval;

        if (num > 0) {
            uint256 addAward = _FoundationMonthReleaseAward * num;

            uint256 totalMintAward = _FoundationTotalAward -
                _FoundationCurrAward -
                _FoundationReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _FoundationReleaseTotalAward += addAward;
            _FoundationReleaseAllowReleaseTime +=
                num *
                _FoundationReleaseInterval;
        }

        uint256 mintNum = _FoundationReleaseTotalAward - _FoundationCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _FoundationCurrAward += mintNum;

        require(
            _FoundationTotalAward >= _FoundationCurrAward,
            "_FoundationReleaseTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_FoundationAddress, mintNum);
    }

    function getAdvisorCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _AdvisorAllowReleaseTime > 0,
            "The commencement of the release of advisor has not yet commenced"
        );

        if (block.timestamp < _AdvisorAllowReleaseTime) {
            return (0, 0);
        }

        uint256 AdvisorReleaseTotalAward = _AdvisorReleaseTotalAward;

        uint256 time = block.timestamp - _AdvisorAllowReleaseTime;

        time = time - (time % _AdvisorReleaseInterval);

        uint256 num = time / _AdvisorReleaseInterval;

        if (num > 0) {
            uint256 addAward = _AdvisorMonthReleaseAward * num;

            uint256 totalMintAward = _AdvisorTotalAward -
                _AdvisorCurrAward -
                _AdvisorReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            AdvisorReleaseTotalAward += addAward;
        }

        return (
            AdvisorReleaseTotalAward - _AdvisorCurrAward,
            AdvisorReleaseTotalAward
        );
    }

    function AdvisorMint() private {
        require(
            _FoundationReleaseAllowReleaseTime > 0,
            "The commencement of the release of advisor has not yet commenced"
        );

        require(block.timestamp >= _AdvisorAllowReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _AdvisorAllowReleaseTime;

        time = time - (time % _AdvisorReleaseInterval);

        uint256 num = time / _AdvisorReleaseInterval;

        if (num > 0) {
            uint256 addAward = _AdvisorMonthReleaseAward * num;

            uint256 totalMintAward = _AdvisorTotalAward -
                _AdvisorCurrAward -
                _AdvisorReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _AdvisorReleaseTotalAward += addAward;

            _AdvisorAllowReleaseTime += num * _AdvisorReleaseInterval;
        }

        uint256 mintNum = _AdvisorReleaseTotalAward - _AdvisorCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _AdvisorCurrAward += mintNum;

        require(
            _AdvisorTotalAward >= _AdvisorCurrAward,
            "AdvisorTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_AdvisorAddress, mintNum);
    }

    function getSeedCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _SeedAllowReleaseTime > 0,
            "The commencement of the release of seed has not yet commenced"
        );

        if (block.timestamp < _SeedAllowReleaseTime) {
            return (0, 0);
        }

        uint256 SeedReleaseTotalAward = _SeedReleaseTotalAward;

        uint256 time = block.timestamp - _SeedAllowReleaseTime;

        time = time - (time % _SeedReleaseInterval);

        uint256 num = time / _SeedReleaseInterval;

        if (num > 0) {
            uint256 addAward = _SeedMonthReleaseAward * num;

            uint256 totalMintAward = _SeedTotalAward -
                _SeedCurrAward -
                _SeedReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            SeedReleaseTotalAward += addAward;
        }

        return (SeedReleaseTotalAward - _SeedCurrAward, SeedReleaseTotalAward);
    }

    function SeedMint() private {
        require(
            _SeedAllowReleaseTime > 0,
            "The commencement of the release of seed has not yet commenced"
        );

        require(block.timestamp >= _SeedAllowReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _SeedAllowReleaseTime;

        time = time - (time % _SeedReleaseInterval);

        uint256 num = time / _SeedReleaseInterval;

        if (num > 0) {
            uint256 addAward = _SeedMonthReleaseAward * num;

            uint256 totalMintAward = _SeedTotalAward -
                _SeedCurrAward -
                _SeedReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _SeedReleaseTotalAward += addAward;

            _SeedAllowReleaseTime += num * _SeedReleaseInterval;
        }

        uint256 mintNum = _SeedReleaseTotalAward - _SeedCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _SeedCurrAward += mintNum;

        require(
            _SeedTotalAward >= _SeedCurrAward,
            "SeedTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_SeedAddress, mintNum);
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

            uint256 totalMintAward = _PrivateSaleTotalAward -
                _PrivateSaleCurrAward -
                _PrivateSaleReleaseTotalAward;

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

    function PrivateSaleMint() private {
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

            uint256 totalMintAward = _PrivateSaleTotalAward -
                _PrivateSaleCurrAward -
                _PrivateSaleReleaseTotalAward;

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

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_PrivateSaleAddress, mintNum);
    }

    function getPublicSaleCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _PublicSaleReleaseTime > 0,
            "The commencement of the release of public sale has not yet commenced"
        );

        if (block.timestamp < _PublicSaleReleaseTime) {
            return (0, 0);
        }

        uint256 PublicSaleReleaseTotalAward = _PublicSaleReleaseTotalAward;

        uint256 time = block.timestamp - _PublicSaleReleaseTime;

        time = time - (time % _PublicSaleReleaseInterval);

        uint256 num = time / _PublicSaleReleaseInterval;

        if (num > 0) {
            uint256 addAward = _PublicSaleMonthReleaseAward * num;

            uint256 totalMintAward = _PublicSaleTotalAward -
                _PublicSaleCurrAward -
                _PublicSaleReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            PublicSaleReleaseTotalAward += addAward;
        }

        return (
            PublicSaleReleaseTotalAward - _PublicSaleCurrAward,
            PublicSaleReleaseTotalAward
        );
    }

    function PublicSaleMint() private {
        require(
            _PublicSaleReleaseTime > 0,
            "The commencement of the release of public sale has not yet commenced"
        );

        require(block.timestamp >= _PrivateSaleReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _PublicSaleReleaseTime;

        time = time - (time % _PublicSaleReleaseInterval);

        uint256 num = time / _PublicSaleReleaseInterval;

        if (num > 0) {
            uint256 addAward = _PublicSaleMonthReleaseAward * num;

            uint256 totalMintAward = _PublicSaleTotalAward -
                _PublicSaleCurrAward -
                _PublicSaleReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _PublicSaleReleaseTotalAward += addAward;
            _PublicSaleReleaseTime += num * _PublicSaleReleaseInterval;
        }

        uint256 mintNum = _PublicSaleReleaseTotalAward - _PublicSaleCurrAward;

        require(mintNum > 0, "There is no mintable amount");

        _PublicSaleCurrAward += mintNum;

        require(
            _PublicSaleTotalAward >= _PublicSaleCurrAward,
            "_PublicSaleTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_PublicSaleAddress, mintNum);
    }

    function getAirdropCurrAllowMintTotalNum()
        public
        view
        returns (uint256, uint256)
    {
        require(
            _AirdropReleaseTime > 0,
            "The commencement of the release of airdrop has not yet commenced"
        );

        if (block.timestamp < _AirdropReleaseTime) {
            return (0, 0);
        }

        uint256 AirdropReleaseTotalAward = _AirdropReleaseTotalAward;

        uint256 time = block.timestamp - _AirdropReleaseTime;

        time = time - (time % _AirdropReleaseInterval);

        uint256 num = time / _AirdropReleaseInterval;

        if (num > 0) {
            uint256 addAward = _AirdropReleaseMonthAward * num;

            uint256 totalMintAward = _AirdropTotalAward -
                _AirdropCurrAward -
                _AirdropReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            AirdropReleaseTotalAward += addAward;
        }

        return (
            AirdropReleaseTotalAward - _AirdropCurrAward,
            AirdropReleaseTotalAward
        );
    }

    function AirdropMint() private {
        require(
            _AirdropReleaseTime > 0,
            "The commencement of the release of airdrop has not yet commenced"
        );

        require(block.timestamp >= _AirdropReleaseTime, "time is not ok");

        uint256 time = block.timestamp - _AirdropReleaseTime;

        time = time - (time % _AirdropReleaseInterval);

        uint256 num = time / _AirdropReleaseInterval;

        if (num > 0) {
            uint256 addAward = _AirdropReleaseMonthAward * num;

            uint256 totalMintAward = _AirdropTotalAward -
                _AirdropCurrAward -
                _AirdropReleaseTotalAward;

            if (addAward > totalMintAward) {
                addAward = totalMintAward;
            }

            _AirdropReleaseTotalAward += addAward;
            _AirdropReleaseTime += num * _AirdropReleaseInterval;
        }

        uint256 mintNum = _AirdropReleaseTotalAward - _AirdropCurrAward;

        _AirdropCurrAward += mintNum;

        require(
            _AirdropTotalAward >= _AirdropCurrAward,
            "_AirdropTotalAward is not enough"
        );

        _mintNum += mintNum;

        require(_mintNum <= _totalSupply, "totalSupply is not enough");

        _mint(_AirdropAddress, mintNum);
    }

    function mint() public {
        if (msg.sender == _CoreTeamAddeess) {
            CoreTeamMint();
        } else if (msg.sender == _FoundationAddress) {
            FoundationMint();
        } else if (msg.sender == _AdvisorAddress) {
            AdvisorMint();
        } else if (msg.sender == _SeedAddress) {
            SeedMint();
        } else if (msg.sender == _PrivateSaleAddress) {
            PrivateSaleMint();
        } else if (msg.sender == _PublicSaleAddress) {
            PublicSaleMint();
        } else if (msg.sender == _AirdropAddress) {
            AirdropMint();
        } else {
            revert("msg.sender is not allowed");
        }
    }

    function startTGETimestamp() public onlyOwner {
        TGE_timestamp = block.timestamp;
        _GPUMiningAllowReleaseTime = TGE_timestamp;
        _lastGPUMiningRateTime = TGE_timestamp;
        _CoreTeamAllowReleaseTime = TGE_timestamp + 3 * _monthTime;
        _FoundationReleaseAllowReleaseTime = TGE_timestamp + _monthTime;
        _AdvisorAllowReleaseTime = TGE_timestamp + _monthTime;
        _SeedAllowReleaseTime = TGE_timestamp;
        _PrivateSaleReleaseTime = TGE_timestamp;
        _PublicSaleReleaseTime = TGE_timestamp;
        _AirdropReleaseTime = TGE_timestamp + 6 * _monthTime;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function getPrivateProperty() public view returns (uint256[] memory) {
        uint256[] memory arr = new uint256[](32);

        arr[0] = _GPUMiningCurrMiningRatio;
        arr[1] = 0;
        arr[2] = _GPUMiningCurrYearTotalSupply;
        arr[3] = _GPUMiningCurrYearTotalAward;
        arr[4] = _GPUMiningReleaseInterval;
        arr[5] = _GPUMiningRateInterval;
        arr[6] = _lastGPUMiningRateTime;

        arr[7] = _CoreTeamReleaseInterval;
        arr[8] = _CoreTeamMonthReleaseAward;
        arr[9] = _CoreTeamReleaseTotalAward;

        arr[10] = _FoundationReleaseInterval;
        arr[11] = _FoundationReleaseTotalAward;
        arr[12] = _FoundationMonthReleaseAward;

        arr[13] = _AdvisorCurrAward;
        arr[14] = _AdvisorReleaseInterval;
        arr[15] = _AdvisorMonthReleaseAward;
        arr[16] = _AdvisorReleaseTotalAward;

        arr[17] = _SeedReleaseInterval;
        arr[18] = _SeedReleaseTotalAward;
        arr[19] = _PrivateSaleReleaseInterval;
        arr[20] = _PrivateSaleReleaseTotalAward;
        arr[21] = _PrivateSaleMonthReleaseAward;
        arr[22] = _PublicSaleReleaseInterval;
        arr[23] = _PublicSaleReleaseTotalAward;
        arr[24] = _PublicSaleMonthReleaseAward;
        arr[25] = _AirdropReleaseInterval;
        arr[26] = _AirdropReleaseMonthAward;
        arr[27] = _AirdropReleaseTotalAward;
        arr[28] = _epochAward;

        return arr;
    }

    function getGPUMiningCurrMiningRatio() {


        

    }
}
