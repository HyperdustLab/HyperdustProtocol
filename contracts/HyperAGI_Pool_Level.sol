pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "./HyperAGI_Roles_Cfg.sol";

contract HyperAGI_Pool_Level is OwnableUpgradeable {
    address public _rolesCfgAddress;

    bytes32 public constant AGENT = keccak256("agent");
    bytes32 public constant INFERENCE_NODE = keccak256("inference_node");

    mapping(bytes32 => LevelInfo[]) public levelInfoMap;

    event eveLevelInfoRemove(uint256 levelId);

    event eveLevelInfoSave(LevelInfo levelInfo);

    struct LevelInfo {
        bytes32 businessId; // Business Identifier
        uint256 levelId; // Level ID
        string levelName; // Level Name
        uint256 pledgeKeyTokenAmount; // Pledge Key Token Amount
        uint256 rewardMultiplier; // Reward Multiplier
    }

    function initialize(address onlyOwner) public initializer {
        __Ownable_init(onlyOwner);
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    uint256 private _levelIdCounter;

    function addLevelInfo(bytes32 businessId, string memory levelName, uint256 pledgeKeyTokenAmount, uint256 rewardMultiplier) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        _levelIdCounter++;
        uint256 levelId = _levelIdCounter;
        LevelInfo memory newLevelInfo = LevelInfo({businessId: businessId, levelId: levelId, levelName: levelName, pledgeKeyTokenAmount: pledgeKeyTokenAmount, rewardMultiplier: rewardMultiplier});
        levelInfoMap[businessId].push(newLevelInfo);

        emit eveLevelInfoSave(newLevelInfo);
    }

    function getLevelInfo(bytes32 businessId, uint256 levelId) public view returns (LevelInfo memory) {
        uint256 index = findLevelInfoIndex(businessId, levelId);
        require(index < levelInfoMap[businessId].length, "Level ID not found");
        return levelInfoMap[businessId][index];
    }

    function updateLevelInfo(bytes32 businessId, uint256 levelId, string memory levelName, uint256 pledgeKeyTokenAmount, uint256 rewardMultiplier) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        uint256 index = findLevelInfoIndex(businessId, levelId);
        require(index < levelInfoMap[businessId].length, "Level ID not found");
        LevelInfo storage levelInfo = levelInfoMap[businessId][index];
        levelInfo.levelName = levelName;
        levelInfo.pledgeKeyTokenAmount = pledgeKeyTokenAmount;
        levelInfo.rewardMultiplier = rewardMultiplier;

        emit eveLevelInfoSave(levelInfo);
    }

    function removeLevelInfo(bytes32 businessId, uint256 levelId) public {
        require(HyperAGI_Roles_Cfg(_rolesCfgAddress).hasAdminRole(msg.sender), "not admin role");
        uint256 index = findLevelInfoIndex(businessId, levelId);
        require(index < levelInfoMap[businessId].length, "Level ID not found");
        levelInfoMap[businessId][index] = levelInfoMap[businessId][levelInfoMap[businessId].length - 1];
        levelInfoMap[businessId].pop();

        emit eveLevelInfoRemove(levelId);
    }

    function findLevelInfoIndex(bytes32 businessId, uint256 levelId) internal view returns (uint256) {
        for (uint256 i = 0; i < levelInfoMap[businessId].length; i++) {
            if (levelInfoMap[businessId][i].levelId == levelId) {
                return i;
            }
        }
        revert("Level ID not found");
    }

    function matchLevelByPledge(bytes32 businessId, uint256 pledgeKeyTokenAmount) public view returns (LevelInfo memory) {
        LevelInfo memory matchedLevel;
        bool levelFound = false;

        LevelInfo[] memory levels = levelInfoMap[businessId];
        for (uint256 i = 0; i < levels.length; i++) {
            for (uint256 j = i + 1; j < levels.length; j++) {
                if (levels[i].pledgeKeyTokenAmount < levels[j].pledgeKeyTokenAmount) {
                    LevelInfo memory temp = levels[i];
                    levels[i] = levels[j];
                    levels[j] = temp;
                }
            }
        }

        for (uint256 i = 0; i < levels.length; i++) {
            if (pledgeKeyTokenAmount >= levels[i].pledgeKeyTokenAmount) {
                matchedLevel = levels[i];
                levelFound = true;
                break;
            }
        }

        if (!levelFound) {
            matchedLevel = LevelInfo({businessId: businessId, levelId: 0, levelName: "Default Level", pledgeKeyTokenAmount: 0, rewardMultiplier: 0});
        }

        return matchedLevel;
    }

    function getAllLevelsByBusinessId(bytes32 businessId) public view returns (LevelInfo[] memory) {
        return levelInfoMap[businessId];
    }
}
