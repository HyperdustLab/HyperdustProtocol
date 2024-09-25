// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract HyperAGI_Token is ERC20, ERC20Burnable, Ownable {
    uint256 private constant TOTAL_SUPPLY = 210_000_000 ether;
    uint256 public constant MAX_MINING_MINT_NUM = 997_500 ether;
    uint256 public constant MAX_UBAI_MINT_NUM = 700_000 ether;
    uint256 public constant MINT_INTERVAL = 600;

    uint256 public mintNum;
    uint256 public tgeTimestamp;
    uint256 public lastGpuMiningMintTime;
    uint256 public lastUbaiMintTime;

    bytes32 public immutable GPU_MINING = keccak256("GPU_MINING");
    bytes32 public immutable PUBLIC_SALE = keccak256("PUBLIC_SALE");
    bytes32 public immutable UBAI = keccak256("UBAI");

    mapping(bytes32 => uint256) private totalAwards;
    mapping(bytes32 => uint256) private currAwards;
    mapping(bytes32 => address) private minterAddresses;
    mapping(address => bytes32) private bytes32Addresses;

    constructor(string memory name_, string memory symbol_, address initialOwner) ERC20(name_, symbol_) Ownable(initialOwner) {
        totalAwards[GPU_MINING] = (TOTAL_SUPPLY * 57) / 100;
        totalAwards[UBAI] = (TOTAL_SUPPLY * 40) / 100;
        totalAwards[PUBLIC_SALE] = (TOTAL_SUPPLY * 3) / 100;
    }

    function setMinterAddress(bytes32 name, address account) external onlyOwner {
        minterAddresses[name] = account;
        bytes32Addresses[account] = name;
    }

    function mint(uint256 mintAmount) public {
        require(block.timestamp >= tgeTimestamp, "TGE has not started");

        console.log("lastUbaiMintTime0", lastUbaiMintTime);

        bytes32 name = bytes32Addresses[msg.sender];
        require(name != bytes32(0), "Sender is not allowed to mint");
        require(minterAddresses[name] == msg.sender, "Sender is not authorized");

        // Ensure the mint amount does not exceed the total awards limit for this category
        require(totalAwards[name] >= currAwards[name] + mintAmount, "Exceeds total award");

        if (name == GPU_MINING) {
            uint256 monthsElapsed = (block.timestamp - lastGpuMiningMintTime) / MINT_INTERVAL;
            require(monthsElapsed > 0, "GPU mining cooldown not met");

            // Overflow check: ensure the mint amount does not exceed the maximum GPU mining amount
            require(monthsElapsed <= type(uint256).max / MAX_MINING_MINT_NUM, "Overflow in GPU mining mint amount calculation");
            uint256 maxMintable = MAX_MINING_MINT_NUM * monthsElapsed;
            require(mintAmount <= maxMintable, "Exceeds max mining mint amount");

            lastGpuMiningMintTime = block.timestamp;
        } else if (name == UBAI) {
            uint256 monthsElapsed = (block.timestamp - lastUbaiMintTime) / MINT_INTERVAL;
            require(monthsElapsed > 0, "UBAI cooldown not met");

            // Overflow check: ensure the mint amount does not exceed the maximum UBAI amount
            require(monthsElapsed <= type(uint256).max / MAX_UBAI_MINT_NUM, "Overflow in UBAI mint amount calculation");

            uint256 maxMintable = MAX_UBAI_MINT_NUM * monthsElapsed;
            require(mintAmount <= maxMintable, "Exceeds max UBAI mint amount");

            lastUbaiMintTime = block.timestamp;

            console.log("lastUbaiMintTime1", lastUbaiMintTime);
        } else if (name == PUBLIC_SALE) {
            uint256 remainingAward = totalAwards[name] - currAwards[name];
            require(mintAmount <= remainingAward, "Exceeds max public sale mint amount");
        }

        // Overflow check: ensure the total minted tokens do not exceed the total supply
        require(mintNum + mintAmount >= mintNum, "Overflow in total mint calculation");
        require(mintNum + mintAmount <= TOTAL_SUPPLY, "Exceeds total supply");

        // Update the current awards for the minter
        currAwards[name] += mintAmount;
        mintNum += mintAmount;

        _mint(msg.sender, mintAmount);
    }

    function startTGE() external onlyOwner {
        require(tgeTimestamp == 0, "TGE already started");
        tgeTimestamp = block.timestamp;
        lastGpuMiningMintTime = block.timestamp - MINT_INTERVAL;
        lastUbaiMintTime = block.timestamp - MINT_INTERVAL;
    }

    function totalSupply() public view override returns (uint256) {
        return TOTAL_SUPPLY;
    }

    function getTotalAward(bytes32 name) public view returns (uint256) {
        return totalAwards[name];
    }

    function getCurrAward(bytes32 name) public view returns (uint256) {
        return currAwards[name];
    }

    function getMinterAddress(bytes32 name) public view returns (address) {
        return minterAddresses[name];
    }

    function getBytes32Address(address account) external view returns (bytes32) {
        return bytes32Addresses[account];
    }

    function getAvailableMintAmount(bytes32 name) public view returns (uint256) {
        if (name == GPU_MINING) {
            // Calculate the time interval and ensure the timestamp does not overflow
            require(block.timestamp >= lastGpuMiningMintTime, "Invalid timestamp for GPU mining");
            uint256 monthsElapsed = (block.timestamp - lastGpuMiningMintTime) / MINT_INTERVAL;

            // Calculate the maximum mintable amount and check for overflow
            require(monthsElapsed <= type(uint256).max / MAX_MINING_MINT_NUM, "Overflow in max mintable calculation");
            uint256 maxMintable = MAX_MINING_MINT_NUM * monthsElapsed;

            // Check the size of the remaining award pool and maxMintable
            uint256 remainingAward = totalAwards[name] - currAwards[name];
            return maxMintable < remainingAward ? maxMintable : remainingAward;
        } else if (name == UBAI) {
            // Calculate the time interval and ensure the timestamp does not overflow
            require(block.timestamp >= lastUbaiMintTime, "Invalid timestamp for UBAI");
            uint256 monthsElapsed = (block.timestamp - lastUbaiMintTime) / MINT_INTERVAL;
            console.log("lastUbaiMintTime2", lastUbaiMintTime);

            // Calculate the maximum mintable amount and check for overflow
            require(monthsElapsed <= type(uint256).max / MAX_UBAI_MINT_NUM, "Overflow in max mintable calculation");
            uint256 maxMintable = MAX_UBAI_MINT_NUM * monthsElapsed;

            // Check the size of the remaining award pool and maxMintable
            uint256 remainingAward = totalAwards[name] - currAwards[name];
            return maxMintable < remainingAward ? maxMintable : remainingAward;
        } else if (name == PUBLIC_SALE) {
            // Check the remaining award for public sale and prevent overflow
            uint256 remainingAward = totalAwards[name] - currAwards[name];
            return remainingAward;
        }
        return 0;
    }
}
