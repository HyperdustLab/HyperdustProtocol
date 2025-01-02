pragma solidity ^0.8.2;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "../HyperAGI_Roles_Cfg.sol";
import {StrUtil} from "../utils/StrUtil.sol";
import "./../HyperAGI_Pool_Level.sol";

contract HyperAGI_Node_Pool is OwnableUpgradeable, ERC1155Holder {
    using Strings for *;
    using StrUtil for *;

    event NodePoolCreated(uint256 id, bytes32 sid, uint256 nodeId, address account, uint256 pledgeAmount, uint256 maxPledgeAmount, uint256 pledgeKeyNum, uint256 level, uint256 creatorRatio, uint256 keyPledgeRatio, uint256 hyptPledgeRatio);
    event PledgeSubmitted(bytes32 sid, address account, uint256 pledgeAmount, uint256 pledgeKeyNum);

    struct NodePool {
        uint256 id;
        uint256 nodeId;
        address account;
        uint256 level;
        bytes status;
        uint256 totalPledgeAmount;
        uint256 totalPledgeKeyNum;
        uint256 maxPledgeAmount;
    }

    struct PledgeInfo {
        uint256 pledgeAmount;
        uint256 pledgeKeyNum;
    }

    mapping(bytes32 => NodePool) public nodePools;
    uint256 public nextId;
    mapping(uint256 => bool) public nodeCreated;

    address public rolesCfgAddress;
    address public keyTokenAddress;
    address public poolLevelAddress;
    uint256 public keyTokenId;

    bytes32 public constant INFERENCE_NODE = keccak256("inference_node");
    bytes public constant ACTIVE_STATUS = hex"10";

    modifier onlyAdmin() {
        require(HyperAGI_Roles_Cfg(rolesCfgAddress).hasAdminRole(msg.sender), "Not admin role");
        _;
    }

    modifier validPledge(uint256 pledgeAmount, uint256 pledgeKeyNum) {
        require(pledgeAmount > 0 || pledgeKeyNum > 0, "Must pledge amount or key");
        _;
    }

    function initialize(address onlyOwner, uint256 _keyTokenId) public initializer {
        __Ownable_init(onlyOwner);
        keyTokenId = _keyTokenId;
    }

    function setContractAddresses(address[] memory addresses) public onlyOwner {
        rolesCfgAddress = addresses[0];
        keyTokenAddress = addresses[1];
        poolLevelAddress = addresses[2];
    }

    function create(uint256 nodeId, address account, uint256 pledgeAmount, uint256 pledgeKeyNum) public payable onlyAdmin validPledge(pledgeAmount, pledgeKeyNum) {
        require(!nodeCreated[nodeId], "Node pool already exists");
        require(msg.value == pledgeAmount, "Incorrect pledge amount");

        nextId++;

        if (pledgeKeyNum > 0) {
            require(IERC1155(keyTokenAddress).balanceOf(account, keyTokenId) >= pledgeKeyNum, "Insufficient key balance");
            IERC1155(keyTokenAddress).safeTransferFrom(account, address(this), keyTokenId, pledgeKeyNum, "");
        }

        uint256 level = _calculateLevel(pledgeAmount, pledgeKeyNum);
        bytes32 sid = _generateUniqueHash(nextId);

        uint256 maxPledgeAmount = (pledgeKeyNum + 1) * 200 ether;

        NodePool storage pool = nodePools[sid];
        _initializePool(pool, nodeId, account, level, pledgeAmount, maxPledgeAmount, pledgeKeyNum);

        nodeCreated[nodeId] = true;

        //   emit NodePoolCreated(pool.id, sid, nodeId, account, pledgeAmount, maxPledgeAmount, pledgeKeyNum, level);
        emit PledgeSubmitted(sid, account, pledgeAmount, pledgeKeyNum);
    }

    function pledge(bytes32 sid, uint256 pledgeAmount, uint256 pledgeKeyNum) external payable validPledge(pledgeAmount, pledgeKeyNum) {
        NodePool storage pool = nodePools[sid];
        require(keccak256(pool.status) == keccak256(ACTIVE_STATUS), "Node pool not active");

        _handlePledge(pool, pledgeAmount, pledgeKeyNum);

        emit PledgeSubmitted(sid, msg.sender, pledgeAmount, pledgeKeyNum);
        // emit NodePoolCreated(pool.id, sid, pool.nodeId, pool.account, pool.totalPledgeAmount, pool.maxPledgeAmount, pool.totalPledgeKeyNum, pool.level);
    }

    function _calculateLevel(uint256 pledgeAmount, uint256 pledgeKeyNum) internal view returns (uint256) {
        if (pledgeAmount > 0) {
            return HyperAGI_Pool_Level(poolLevelAddress).matchLevelByPledge(INFERENCE_NODE, pledgeAmount).levelId;
        } else if (pledgeKeyNum > 0) {
            return HyperAGI_Pool_Level(poolLevelAddress).matchLevelByPledge(INFERENCE_NODE, pledgeKeyNum).levelId;
        }
        return 0;
    }

    function _initializePool(NodePool storage pool, uint256 nodeId, address account, uint256 level, uint256 pledgeAmount, uint256 maxPledgeAmount, uint256 pledgeKeyNum) internal {
        pool.id = nextId;
        pool.nodeId = nodeId;
        pool.account = account;
        pool.level = level;
        pool.status = ACTIVE_STATUS;
        pool.totalPledgeAmount = pledgeAmount;
        pool.totalPledgeKeyNum = pledgeKeyNum;
        pool.maxPledgeAmount = maxPledgeAmount;

        // pool.pledges[account] = PledgeInfo({pledgeAmount: pledgeAmount, pledgeKeyNum: pledgeKeyNum});
    }

    function _handlePledge(NodePool storage pool, uint256 pledgeAmount, uint256 pledgeKeyNum) internal {
        if (pledgeAmount > 0) {
            require(msg.value == pledgeAmount, "Incorrect pledge amount");
        }

        if (pledgeKeyNum > 0) {
            require(IERC1155(keyTokenAddress).balanceOf(msg.sender, keyTokenId) >= pledgeKeyNum, "Insufficient key balance");
            IERC1155(keyTokenAddress).safeTransferFrom(msg.sender, address(this), keyTokenId, pledgeKeyNum, "");
        }

        pool.totalPledgeAmount += pledgeAmount;
        pool.totalPledgeKeyNum += pledgeKeyNum;
        pool.maxPledgeAmount += pledgeKeyNum * 200 ether;

        // PledgeInfo storage userPledge = pool.pledges[msg.sender];
        // userPledge.pledgeAmount += pledgeAmount;
        // userPledge.pledgeKeyNum += pledgeKeyNum;
    }

    function handlePledge(bytes32 sid, uint256 pledgeAmount, uint256 pledgeKeyNum) public payable validPledge(pledgeAmount, pledgeKeyNum) {
        NodePool storage pool = nodePools[sid];
        require(keccak256(pool.status) == keccak256(ACTIVE_STATUS), "Node pool not active");

        _handlePledge(pool, pledgeAmount, pledgeKeyNum);

        emit PledgeSubmitted(sid, msg.sender, pledgeAmount, pledgeKeyNum);
        //emit NodePoolCreated(pool.id, sid, pool.nodeId, pool.account, pool.totalPledgeAmount, pool.maxPledgeAmount, pool.totalPledgeKeyNum, pool.level);
    }

    function _generateUniqueHash(uint256 _nextId) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, block.difficulty, _nextId));
    }

    function getPoolInfo(bytes32 sid) public view returns (NodePool memory) {
        NodePool storage pool = nodePools[sid];
        return pool;
    }
}
