// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Hyperdust_Token is ERC20, ERC20Burnable, Ownable {
    // Constants in uppercase
    uint256 private constant TOTAL_SUPPLY = 210_000_000 ether;
    uint256 public constant MAX_MINING_MINT_NUM = 997_500 ether;
    uint256 public constant MAX_UBAI_MINT_NUM = 700_000 ether;
    uint256 public constant MINT_INTERVAL = 600;

    uint256 public mintNum;
    uint256 public tgeTimestamp;
    uint256 public lastGpuMiningMintTime;
    uint256 public lastUbaiMintTime;

    // Use immutable keyword to optimize gas consumption
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

    function mint(uint256 mintAmount) external {
        require(block.timestamp >= tgeTimestamp, "TGE has not started");

        bytes32 name = bytes32Addresses[msg.sender];
        require(name != bytes32(0), "Sender is not allowed to mint");
        require(minterAddresses[name] == msg.sender, "Sender is not authorized");

        currAwards[name] += mintAmount;
        require(totalAwards[name] >= currAwards[name], "Exceeds total award");

        if (name == GPU_MINING) {
            require(block.timestamp >= lastGpuMiningMintTime + MINT_INTERVAL, "GPU mining cooldown not met");
            require(mintAmount <= MAX_MINING_MINT_NUM, "Exceeds max mining mint amount");
            lastGpuMiningMintTime = block.timestamp;
        } else if (name == UBAI) {
            require(block.timestamp >= lastUbaiMintTime + MINT_INTERVAL, "UBAI cooldown not met");
            require(mintAmount <= MAX_UBAI_MINT_NUM, "Exceeds max UBAI mint amount");
            lastUbaiMintTime = block.timestamp;
        }

        mintNum += mintAmount;
        require(mintNum <= TOTAL_SUPPLY, "Exceeds total supply");

        _mint(msg.sender, mintAmount);
    }

    function startTGE() external onlyOwner {
        require(tgeTimestamp == 0, "TGE already started");
        tgeTimestamp = block.timestamp;
    }

    // Override totalSupply function
    function totalSupply() public view override returns (uint256) {
        return TOTAL_SUPPLY;
    }

    // Getter functions
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
}
