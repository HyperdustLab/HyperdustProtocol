// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";
import "../utils/StrUtil.sol";

contract Hyperdust_Token is ERC20, ERC20Burnable, Ownable {
    constructor(
        address account1,
        address account2,
        address account3
    ) ERC20("Hyperdust", "HYPT Private Test") {
        _multiSignatureWallet.push(account1);
        _multiSignatureWallet.push(account2);
        _multiSignatureWallet.push(account3);
    }

    using StrUtil for *;

    /**
     * @dev The DateTime contract is used to calculate the current year.
     */
    uint256 public timestamp = block.timestamp;

    /**
     * @dev Total supply of the Hyperdust Token.
     */
    uint256 public _totalSupply = 200000000 ether;

    /**
     * @dev Public array variable to store the addresses of the multi-signature wallets.
     */
    address[] public _multiSignatureWallet;

    /**
     * @dev Total number of times the token has been minted.
     */
    uint256 public _mintNum = 0;

    /**
     * @dev Public variable that stores the address of the GPU mining contract.
     */
    address public _GPUMiningAddress;

    /**
     * @dev The total award for GPU mining is calculated as 55% of the total supply of the token.
     */
    uint256 public _GPUMiningTotalAward = (_totalSupply * 55) / 100;

    /**
     * @dev Public variable that represents the current GPU mining award.
     */
    uint256 public _GPUMiningCurrAward = 0;

    /**
     * @dev Public variable that stores the current year number.
     */
    uint32 public _GPUMiningCurrYearNum = 1;

    /**
     * @dev Public variable that stores the current mining ratio 10% as the initial mining proportion.
     */
    uint32 public _GPUMiningCurrMiningRatio = 100000;

    /**
     * @dev The total mining ratio is calculated by multiplying the current mining ratio by 100.
     */
    uint32 public _GPUMiningTotalMiningRatio = _GPUMiningCurrMiningRatio * 10;

    /**
     * @dev Public variable that stores the current year total supply.
     */
    uint256 public _GPUMiningCurrYearTotalSupply =
        (_GPUMiningTotalAward * _GPUMiningCurrMiningRatio) /
            _GPUMiningTotalMiningRatio;

    uint256 public _epochAward = _GPUMiningCurrYearTotalSupply / 365 / 225;

    /**
     * @dev Public variable that stores the current year total award.
     */
    uint256 public _GPUMiningCurrYearTotalAward = 0;

    /**
     * @dev The duration of time after which GPU mining rewards will be released.
     */
    uint256 public _GPUMiningReleaseInterval = 365 days;
    /**
     * @dev The timestamp when GPU mining tokens are allowed to be released.
     */
    uint256 public _GPUMiningAllowReleaseTime = timestamp;

    /**
     * @dev Public variable that stores the address of the mining reserve.
     */
    address public _MiningReserveAddress;

    /**
     * @dev Total amount of tokens awarded to the mining reserve.
     */
    uint256 public _MiningReserveTotalAward = (_totalSupply * 15) / 100;

    /**
     * @dev Public variable representing the current mining reserve award.
     */
    uint256 public _MiningReserveCurrAward = 0;

    /**
     * @dev The ratio of mining reserve to mining is set to 100000.
     */
    uint32 public _MiningReserveMiningRatio = 100000;

    /**
     * @dev The total mining ratio is calculated by multiplying the mining ratio by 10.
     */
    uint32 public _MiningReserveTotalMiningRatio =
        _MiningReserveMiningRatio * 10;

    /**
     * @dev Total supply of tokens mined in the current year.
     */
    uint256 public _MiningReserveCurrYearTotalSupply =
        (_MiningReserveTotalAward * _MiningReserveMiningRatio) /
            _MiningReserveTotalMiningRatio;
    /**
     * @dev Public variable that stores the total amount of awards for the current year in the mining reserve.
     */
    uint256 public _MiningReserveCurrYearTotalAward = 0;

    /**
     * @dev The current year number for mining reserve.
     */
    uint32 public _MiningReserveCurrYearNum = 1;

    /**
     * @dev The timestamp when the mining reserve will be released.
     */
    uint256 public _MiningReserveReleaseTime = timestamp;

    /**
     * @dev The interval of time after which the mining reserve is released.
     */
    uint256 public _MiningReserveReleaseInterval = 365 days;

    /**
     * @dev Public variable that stores the address of the Core Team.
     */
    address public _CoreTeamAddeess;

    /**
     * @dev Calculates the total award for the core team based on a percentage of the total supply.
     */
    uint256 public _CoreTeamTotalAward = (_totalSupply * 115) / 1000;
    /**
     * @dev Public variable that represents the current award for the core team.
     */
    uint256 public _CoreTeamCurrAward = 0;

    /**
     * @dev Public variable that stores the time when the core team can start releasing tokens.
     */
    uint256 public _CoreTeamAllowReleaseTime = timestamp + 90 days;

    /**
     * @dev Public variable that stores the interval at which the core team can release tokens.
     */
    uint256 public _CoreTeamReleaseInterval = 90 days;

    /**
     * @dev This variable represents the total award that will be released to the core team members
     * over a period of 60 months. The amount released each month will be equal to `_CoreTeamReleaseTotalAward`.
     */
    uint256 public _CoreTeamReleaseTotalAward = _CoreTeamTotalAward / 20;

    /**
     * @dev Public variable that stores the address of the core team.
     */
    uint256 public _CoreTeamReleaseCurrAward = 0;

    /**
     * @dev Public variable that stores the address of the advisor.
     */
    address public _AdvisorAddress;

    /**
     * @dev Public variable that stores the timestamp of 60 days after the contract deployment date.
     */
    uint256 public _AdvisorAllowReleaseTime = timestamp + 90 days;

    /**
     * @dev The total amount of tokens awarded to advisors, which is 1% of the total supply.
     */
    uint256 public _AdvisorTotalAward = (_totalSupply * 1) / 100;

    /**
     * @dev Public variable representing the current advisor award amount.
     */
    uint256 public _AdvisorCurrAward = 0;

    /**
     * @dev The amount of time that must pass before advisor tokens can be released.
     */
    uint256 public _AdvisorReleaseInterval = 90 days;

    /**
     * @dev The total amount of tokens to be released for advisors every month.
     */
    uint256 public _AdvisorReleaseTotalAward = _AdvisorTotalAward / 20;

    /**
     * @dev Public variable that represents the current amount of tokens released to advisors.
     */
    uint256 public _AdvisorReleaseCurrAward = 0;

    /**
     * @dev Public variable that stores the address of the Early Contributors KOL.
     */
    address public _EarlyContributorsKOLAddress;
    /**
     * @dev Calculates the total award for early contributors and assigns it to the _EarlyContributorsKOLTotalAward variable.
     * The award is calculated as 2.35% of the total supply of the Hyperdust Token.
     */
    uint256 public _EarlyContributorsKOLTotalAward =
        (_totalSupply * 235) / 10000;

    /**
     * @dev Public variable that stores the current award for early contributors who are KOLs.
     */
    uint256 public _EarlyContributorsKOLCurrAward = 0;

    /**
     * @dev The duration of the interval after which the early contributors and KOL tokens will be released.
     */
    uint256 public _EarlyContributorsKOLReleaseInterval = 30 days;

    /**
     * @dev Public variable that stores the timestamp for the early contributors KOL allow release time.
     */
    uint256 public _EarlyContributorsKOLAllowReleaseTime = timestamp;

    /**
     * @dev Total amount of tokens to be released for early contributors and KOLs.
     */
    uint256 public _EarlyContributorsKOLReleaseTotalAward = 10000 ether;

    /**
     * @dev Public variable that stores the current award for early contributors and key opinion leaders (KOL) release.
     */
    uint256 public _EarlyContributorsKOLReleaseCurrAward = 0;

    /**
     * @dev Public variable that stores the address of the early contributors genesis address.
     */
    address public _EarlyContributorsGenesisAddress;
    /**
     * @dev Calculates the total award for early contributors based on a percentage of the total supply.
     */
    uint256 public _EarlyContributorsGenesisTotalAward =
        (_totalSupply * 115) / 10000;
    /**
     * @dev Public variable that stores the current award for early contributors in the Hyperdust Token contract.
     */
    uint256 public _EarlyContributorsGenesisCurrAward = 0;

    /**
     * @dev The duration of the interval after which the early contributors' tokens will be released.
     */
    uint256 public _EarlyContributorsGenesisReleaseInterval = 30 days;

    /**
     * @dev Public variable that stores the timestamp for the early contributors' genesis release time.
     */
    uint256 public _EarlyContributorsGenesisAllowReleaseTime =
        timestamp + 30 days;

    /**
     * @dev This variable represents the total award for early contributors' genesis release, which is calculated as a twelfth of the total award for early contributors.
     */
    uint256 public _EarlyContributorsGenesisReleaseTotalAward =
        _EarlyContributorsGenesisTotalAward / 12;

    /**
     * @dev Public variable that stores the current award for the early contributors' genesis release.
     */
    uint256 public _EarlyContributorsGenesisReleaseCurrAward = 0;

    /**
     * @dev Public variable that stores the address of the private sale contract.
     */
    address public _PrivateSaleAddress;

    /**
     * @dev The total amount of tokens awarded during the private sale.
     */
    uint256 public _PrivateSaleTotalAward = (_totalSupply * 9) / 100;

    /**
     * @dev Public variable that stores the current award for private sale.
     */
    uint256 public _PrivateSaleCurrAward = 0;

    /**
     * @dev Public variable that stores the timestamp when private sale tokens can be released.
     */
    uint256 public _PrivateSaleAllowReleaseTime = timestamp;
    /**
     * @dev The interval between private sale releases.
     */
    uint256 public _PrivateSaleReleaseInterval = 30 days;

    /**
     * @dev The total amount of tokens to be released for Private Sale divided by 60.
     */
    uint256 public _PrivateSaleReleaseTotalAward = _PrivateSaleTotalAward / 60;

    /**
     * @dev Public variable that stores the current award for the private sale release.
     */
    uint256 public _PrivateSaleReleaseCurrAward = 0;

    /**
     * @dev Public variable that stores the address of the foundation.
     */
    address public _FoundationAddress;

    /**
     * @dev The total amount of tokens awarded to the foundation.
     */
    uint256 public _FoundationTotalAward = (_totalSupply * 5) / 100;

    /**
     * @dev Public variable that represents the current award for the foundation.
     */
    uint256 public _FoundationCurrAward = 0;

    /**
     * @dev The duration of time after which the foundation can release tokens.
     */
    uint256 public _FoundationReleaseInterval = 90 days;

    /**
     * @dev Public variable that stores the timestamp for the Foundation release allow release time.
     */
    uint256 public _FoundationReleaseAllowReleaseTime = timestamp + 30 days;
    /**
     * @dev This variable represents the total amount of tokens awarded to the foundation in the Hyperdust Token contract.
     * It is calculated as one fourth of the total award amount.
     */
    uint256 public _FoundationReleaseReleaseTotalAward =
        _FoundationTotalAward / 4;

    /**
     * @dev Public variable that represents the current award for the foundation release.
     */
    uint256 public _FoundationReleaseCurrAward = 0;

    /**
     * @dev A mapping of string to address to store the approvers of the Hyperdust Token.
     */
    mapping(string => address) public _approvers;

    /**
     * @dev Mapping of contract names to their updated addresses.
     */
    mapping(string => address) public _updateAddress;

    /**
     * @dev Sets the GPU mining address.
     * @param GPUMiningAddress The address of the GPU mining contract.
     */
    function setGPUMiningAddress(address GPUMiningAddress) public {
        checkSignatureWallet();

        _approvers["setGPUMiningAddress"] = msg.sender;

        _updateAddress["setGPUMiningAddress"] = GPUMiningAddress;
    }

    /**
     * @dev Sets the address of the mining reserve contract.
     * @param MiningReserveAddress The address of the mining reserve contract.
     */

    function setMiningReserveAddress(address MiningReserveAddress) public {
        checkSignatureWallet();

        _approvers["setMiningReserveAddress"] = msg.sender;

        _updateAddress["setMiningReserveAddress"] = MiningReserveAddress;
    }

    /**
     * @dev Sets the address of the core team.
     * @param CoreTeamAddress The address of the core team.
     */
    function setCoreTeamAddress(address CoreTeamAddress) public {
        checkSignatureWallet();

        _approvers["setCoreTeamAddress"] = msg.sender;

        _updateAddress["setCoreTeamAddress"] = CoreTeamAddress;
    }

    /**
     * @dev Sets the address of the advisor.
     * @param AdvisorAddress The address of the advisor to be set.
     */
    function setAdvisorAddress(address AdvisorAddress) public {
        checkSignatureWallet();

        _approvers["setAdvisorAddress"] = msg.sender;

        _updateAddress["setAdvisorAddress"] = AdvisorAddress;
    }

    /**
     * @dev Sets the address of the early contributors and KOLs.
     * @param EarlyContributorsKOLAddress The address of the early contributors and KOLs.
     */

    function setEarlyContributorsKOLAddress(
        address EarlyContributorsKOLAddress
    ) public {
        checkSignatureWallet();

        _approvers["setEarlyContributorsKOLAddress"] = msg.sender;

        _updateAddress[
            "setEarlyContributorsKOLAddress"
        ] = EarlyContributorsKOLAddress;
    }

    /**
     * @dev Sets the address of the early contributors genesis address.
     * @param EarlyContributorsGenesisAddress The address of the early contributors genesis.
     */
    function setEarlyContributorsGenesisAddress(
        address EarlyContributorsGenesisAddress
    ) public {
        checkSignatureWallet();

        _approvers["setEarlyContributorsGenesisAddress"] = msg.sender;

        _updateAddress[
            "setEarlyContributorsGenesisAddress"
        ] = EarlyContributorsGenesisAddress;
    }

    /**
     * @dev Sets the address of the private sale contract.
     * @param PrivateSaleAddress The address of the private sale contract.
     */
    function setPrivateSaleAddress(address PrivateSaleAddress) public {
        checkSignatureWallet();

        _approvers["setPrivateSaleAddress"] = msg.sender;

        _updateAddress["setPrivateSaleAddress"] = PrivateSaleAddress;
    }

    /**
     * @dev Sets the address of the foundation.
     * @param FoundationAddress The address of the foundation.
     */
    function setFoundationAddress(address FoundationAddress) public {
        checkSignatureWallet();

        _approvers["setFoundationAddress"] = msg.sender;

        _updateAddress["setFoundationAddress"] = FoundationAddress;
    }

    /**
     * @dev Allows an approver to update the address of a specific contract.
     * @param name The name of the contract to update.
     * @notice This function can only be called by an approver and requires a valid signature.
     * @notice The name parameter must match one of the predefined contract names.
     * @notice If the name parameter is not recognized, the function will revert.
     */
    function approveUpdateAddress(string memory name) public {
        checkSignatureWallet();

        require(_updateAddress[name] != address(0), "address is 0x0");
        require(_approvers[name] != msg.sender, "msg.sender is approvers");

        if (StrUtil.equals(name.toSlice(), "setGPUMiningAddress".toSlice())) {
            _GPUMiningAddress = _updateAddress[name];
        } else if (
            StrUtil.equals(name.toSlice(), "setMiningReserveAddress".toSlice())
        ) {
            _MiningReserveAddress = _updateAddress[name];
        } else if (
            StrUtil.equals(name.toSlice(), "setCoreTeamAddress".toSlice())
        ) {
            _CoreTeamAddeess = _updateAddress[name];
        } else if (
            StrUtil.equals(name.toSlice(), "setAdvisorAddress".toSlice())
        ) {
            _AdvisorAddress = _updateAddress[name];
        } else if (
            StrUtil.equals(
                name.toSlice(),
                "setEarlyContributorsKOLAddress".toSlice()
            )
        ) {
            _EarlyContributorsKOLAddress = _updateAddress[name];
        } else if (
            StrUtil.equals(
                name.toSlice(),
                "setEarlyContributorsGenesisAddress".toSlice()
            )
        ) {
            _EarlyContributorsGenesisAddress = _updateAddress[name];
        } else if (
            StrUtil.equals(name.toSlice(), "setPrivateSaleAddress".toSlice())
        ) {
            _PrivateSaleAddress = _updateAddress[name];
        } else if (
            StrUtil.equals(name.toSlice(), "setFoundationAddress".toSlice())
        ) {
            _FoundationAddress = _updateAddress[name];
        } else {
            revert("name is error");
        }
    }

    /**
     * @dev Private function to mint tokens for GPU mining.
     * @param mintNum The number of tokens to mint.
     */
    function GPUMiningMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _GPUMiningAllowReleaseTime + _GPUMiningReleaseInterval
        ) {
            _GPUMiningCurrYearNum++;
            if (_GPUMiningCurrYearNum % 4 == 0) {
                _GPUMiningCurrMiningRatio = _GPUMiningCurrMiningRatio / 2;
                require(_GPUMiningCurrMiningRatio > 0, "currMiningRatio is 0");
            }

            _GPUMiningCurrYearTotalAward = 0;
            _GPUMiningAllowReleaseTime = block.timestamp;

            _GPUMiningCurrYearTotalSupply =
                ((_GPUMiningTotalAward - _GPUMiningCurrAward) *
                    _GPUMiningCurrMiningRatio) /
                _GPUMiningTotalMiningRatio;

            _GPUMiningCurrAward = 0;

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

        _GPUMiningCurrYearTotalAward += mintNum;
        _GPUMiningCurrAward += mintNum;

        _mint(_GPUMiningAddress, mintNum);
    }

    /**
     * @dev Private function to mint tokens for the Core Team.
     * @param mintNum The number of tokens to mint.
     * Requirements:
     * - `CoreTeamTotalAward` must be greater than or equal to `mintNum`.
     * - `CoreTeamReleaseTotalAward` must be greater than or equal to `mintNum`.
     */
    function CoreTeamMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _CoreTeamAllowReleaseTime + _CoreTeamReleaseInterval
        ) {
            _CoreTeamAllowReleaseTime += _CoreTeamReleaseInterval;

            _CoreTeamReleaseTotalAward =
                (_CoreTeamReleaseTotalAward - _CoreTeamReleaseCurrAward) +
                _CoreTeamTotalAward /
                20;

            _CoreTeamReleaseCurrAward = 0;
        }

        require(
            _CoreTeamTotalAward - _CoreTeamCurrAward - mintNum >= 0,
            "CoreTeamTotalAward is not enough"
        );

        require(
            _CoreTeamReleaseTotalAward - _CoreTeamReleaseCurrAward - mintNum >=
                0,
            "CoreTeamReleaseTotalAward is not enough"
        );

        _CoreTeamCurrAward += mintNum;
        _CoreTeamReleaseCurrAward += mintNum;

        _mint(_CoreTeamAddeess, mintNum);
    }

    /**
     * @dev Private function to mint tokens for advisors.
     * @param mintNum The number of tokens to mint.
     * Requirements:
     * - `AdvisorTotalAward` must be greater than or equal to `mintNum`.
     * - `AdvisorReleaseTotalAward` must be greater than or equal to `mintNum`.
     */
    function AdvisorMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _AdvisorAllowReleaseTime + _AdvisorReleaseInterval
        ) {
            _AdvisorAllowReleaseTime += _CoreTeamReleaseInterval;

            _AdvisorReleaseTotalAward =
                (_AdvisorReleaseTotalAward - _AdvisorReleaseCurrAward) +
                _CoreTeamTotalAward /
                20;
            _AdvisorReleaseCurrAward = 0;
        }

        require(
            _AdvisorTotalAward - _AdvisorCurrAward - mintNum >= 0,
            "AdvisorTotalAward is not enough"
        );

        require(
            _AdvisorReleaseTotalAward - _AdvisorReleaseCurrAward - mintNum >= 0,
            "AdvisorReleaseTotalAward is not enough"
        );

        _AdvisorCurrAward += mintNum;
        _AdvisorReleaseCurrAward += mintNum;

        _mint(_AdvisorAddress, mintNum);
    }

    /**
     * @dev Private function to mint tokens for early contributors and KOLs.
     * @param mintNum The number of tokens to mint.
     * Requirements:
     * - The release time must have passed.
     * - Sufficient tokens must be available for minting.
     */
    function EarlyContributorsKOLMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _EarlyContributorsKOLAllowReleaseTime +
                _EarlyContributorsKOLReleaseInterval
        ) {
            _EarlyContributorsKOLAllowReleaseTime += _EarlyContributorsKOLReleaseInterval;

            _EarlyContributorsKOLReleaseTotalAward =
                (_EarlyContributorsKOLReleaseTotalAward -
                    _EarlyContributorsKOLReleaseCurrAward) +
                10000 ether;

            _EarlyContributorsKOLReleaseCurrAward = 0;
        }

        require(
            _EarlyContributorsKOLReleaseTotalAward -
                _EarlyContributorsKOLReleaseCurrAward -
                mintNum >=
                0,
            "_EarlyContributorsKOLReleaseTotalAward is not enough"
        );

        require(
            _EarlyContributorsKOLTotalAward -
                _EarlyContributorsKOLCurrAward -
                mintNum >=
                0,
            "_EarlyContributorsKOLReleaseTotalAward is not enough"
        );

        _EarlyContributorsKOLCurrAward += mintNum;
        _EarlyContributorsKOLReleaseCurrAward += mintNum;

        _mint(_EarlyContributorsKOLAddress, mintNum);
    }

    /**
     * @dev Private function to mint tokens for early contributors during the genesis period.
     * @param mintNum The number of tokens to mint.
     * Requirements:
     * - `_EarlyContributorsGenesisReleaseTotalAward` must be enough to cover the minted tokens.
     * - `_EarlyContributorsGenesisTotalAward` must be enough to cover the minted tokens.
     */
    function EarlyContributorsGenesisMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _EarlyContributorsGenesisAllowReleaseTime +
                _EarlyContributorsGenesisReleaseInterval
        ) {
            _EarlyContributorsGenesisAllowReleaseTime += _EarlyContributorsGenesisReleaseInterval;

            _EarlyContributorsGenesisReleaseTotalAward =
                (_EarlyContributorsGenesisReleaseTotalAward -
                    _EarlyContributorsGenesisReleaseCurrAward) +
                (_EarlyContributorsGenesisTotalAward / 12);

            _EarlyContributorsGenesisReleaseCurrAward = 0;
        }

        require(
            _EarlyContributorsGenesisReleaseTotalAward -
                _EarlyContributorsGenesisReleaseCurrAward -
                mintNum >=
                0,
            "_EarlyContributorsGenesisReleaseTotalAward is not enough"
        );

        require(
            _EarlyContributorsGenesisTotalAward -
                _EarlyContributorsGenesisCurrAward -
                mintNum >=
                0,
            "_EarlyContributorsGenesisTotalAward is not enough"
        );

        _EarlyContributorsGenesisCurrAward += mintNum;
        _EarlyContributorsGenesisReleaseCurrAward += mintNum;

        _mint(_EarlyContributorsGenesisAddress, mintNum);
    }

    /**
     * @dev PrivateSaleMint function mints new tokens during the private sale.
     * @param mintNum The number of tokens to be minted.
     */
    function PrivateSaleMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _PrivateSaleAllowReleaseTime + _PrivateSaleReleaseInterval
        ) {
            _PrivateSaleAllowReleaseTime += _PrivateSaleReleaseInterval;

            _PrivateSaleReleaseTotalAward =
                (_PrivateSaleReleaseTotalAward - _PrivateSaleReleaseCurrAward) +
                _PrivateSaleTotalAward /
                60;
            _PrivateSaleReleaseCurrAward = 0;
        }

        require(
            _PrivateSaleReleaseTotalAward -
                _PrivateSaleReleaseCurrAward -
                mintNum >=
                0,
            "_PrivateSaleReleaseTotalAward is not enough"
        );

        require(
            _PrivateSaleTotalAward - _PrivateSaleCurrAward - mintNum >= 0,
            "_PrivateSaleTotalAward is not enough"
        );

        _PrivateSaleReleaseCurrAward += mintNum;
        _PrivateSaleCurrAward += mintNum;

        _mint(_PrivateSaleAddress, mintNum);
    }

    /**
     * @dev Private function to mint tokens for the foundation.
     * @param mintNum The number of tokens to mint.
     * Requirements:
     * - `_FoundationReleaseReleaseTotalAward` must be enough to mint `mintNum` tokens.
     * - `_FoundationTotalAward` must be enough to mint `mintNum` tokens.
     */
    function FoundationMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _FoundationReleaseAllowReleaseTime + _FoundationReleaseInterval
        ) {
            _FoundationReleaseAllowReleaseTime += _FoundationReleaseInterval;

            _FoundationReleaseReleaseTotalAward =
                (_FoundationReleaseReleaseTotalAward -
                    _FoundationReleaseCurrAward) +
                (_FoundationTotalAward / 4);

            _EarlyContributorsGenesisReleaseCurrAward = 0;
        }

        require(
            _FoundationReleaseReleaseTotalAward -
                _EarlyContributorsGenesisReleaseCurrAward -
                mintNum >=
                0,
            "_FoundationReleaseReleaseTotalAward is not enough"
        );

        require(
            _FoundationTotalAward - _FoundationCurrAward - mintNum >= 0,
            "_FoundationTotalAward is not enough"
        );

        _FoundationCurrAward += mintNum;
        _FoundationReleaseCurrAward += mintNum;

        _mint(_FoundationAddress, mintNum);
    }

    /**
     * @dev Mint tokens to the mining reserve address.
     * @param mintNum The number of tokens to mint.
     * @notice Only callable by the contract owner.
     * @notice The total award must be sufficient for the minting to succeed.
     */
    function MiningReserveMint(uint256 mintNum) private {
        if (
            block.timestamp >=
            _MiningReserveReleaseTime + _MiningReserveReleaseInterval
        ) {
            _MiningReserveCurrYearNum++;
            if (_MiningReserveCurrYearNum % 4 == 0) {
                _MiningReserveMiningRatio = _MiningReserveMiningRatio / 2;
                require(
                    _MiningReserveMiningRatio > 0,
                    "_MiningReserveMiningRatio is 0"
                );
            }

            _MiningReserveCurrYearTotalAward = 0;
            _MiningReserveReleaseTime =
                _MiningReserveReleaseTime +
                _MiningReserveReleaseInterval;

            _MiningReserveCurrYearTotalSupply =
                ((_MiningReserveTotalAward - _MiningReserveCurrAward) *
                    _MiningReserveMiningRatio) /
                _GPUMiningTotalMiningRatio;

            _MiningReserveCurrYearTotalAward = 0;
        }

        require(
            _MiningReserveCurrYearTotalSupply -
                _MiningReserveCurrYearTotalAward -
                mintNum >=
                0,
            "_MiningReserveCurrYearTotalSupply is not enough"
        );

        require(
            _MiningReserveTotalAward - _MiningReserveCurrAward - mintNum >= 0,
            "_MiningReserveTotalAward is not enough"
        );

        _MiningReserveCurrYearTotalAward += mintNum;
        _MiningReserveCurrAward += mintNum;

        _mint(_MiningReserveAddress, mintNum);
    }

    /**
     * @dev Checks if the message sender is in the MultiSignatureWallet.
     * @dev If the sender is not in the MultiSignatureWallet, reverts with an error message.
     */
    function checkSignatureWallet() private {
        for (uint i = 0; i < _multiSignatureWallet.length; i++) {
            if (_multiSignatureWallet[i] == msg.sender) {
                return;
            }
        }

        revert("msg.sender is not in MultiSignatureWallet");
    }

    /**
     * @dev Mint new tokens to designated addresses.
     * @param amount The amount of tokens to mint.
     * Emits a {Transfer} event with `from` set to the zero address.
     * Requirements:
     * - The caller must have permission to mint tokens.
     * - The total supply must not exceed the maximum supply.
     */
    function mint(uint256 amount) public {
        require(
            _mintNum + amount <= totalSupply(),
            "totalSupply is not enough"
        );

        if (msg.sender == _GPUMiningAddress) {
            GPUMiningMint(amount);
        } else if (msg.sender == _CoreTeamAddeess) {
            CoreTeamMint(amount);
        } else if (msg.sender == _AdvisorAddress) {
            AdvisorMint(amount);
        } else if (msg.sender == _EarlyContributorsKOLAddress) {
            EarlyContributorsKOLMint(amount);
        } else if (msg.sender == _EarlyContributorsGenesisAddress) {
            EarlyContributorsGenesisMint(amount);
        } else if (msg.sender == _PrivateSaleAddress) {
            PrivateSaleMint(amount);
        } else if (msg.sender == _FoundationAddress) {
            FoundationMint(amount);
        } else if (msg.sender == _MiningReserveAddress) {
            MiningReserveMint(amount);
        } else {
            revert("do not have permission");
        }
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
}
