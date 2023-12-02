/**
 * @title Hyperdust_Render_Awards
 * @dev This contract is responsible for distributing rewards to active nodes in the Hyperdust Protocol.
 * It uses a random selection process to choose a node and distributes an epoch award to it.
 * The epoch award is calculated based on the total supply of the protocol and the number of active nodes.
 * A portion of the epoch award is kept as security deposit and the rest is released as base reward to the node.
 * The contract also keeps track of the total award and residue total award available for distribution.
 * Only the admin role can trigger the rewards distribution.
 */
pragma solidity ^0.8.7;

import {DateTime} from "@quant-finance/solidity-datetime/contracts/DateTime.sol";
import {StrUtil} from "../utils/StrUtil.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IHyperdustNodeMgr {
    function getNode(
        uint256 id
    ) public view returns (address, string memory, uint256[] memory) {}

    function getIdByIndex(uint256 index) public view returns (uint256) {}

    function getStatisticalIndex()
        public
        view
        returns (uint256, uint32, uint32)
    {}

    function setStatisticalIndex(uint32 totalNum, uint32 activeNum) public {}
}

abstract contract IHyperdustSecurityDeposit {
    function addSecurityDeposit(uint256 nodeId, uint256 amount) public {}
}

abstract contract IHyperdustToken {
    function _epochAward() public view returns (uint256) {}

    function mint(uint256 amount) public {}

    function transfer(address to, uint256 amount) external returns (bool) {}
}

abstract contract IHyperdustBaseRewardRelease {
    function addBaseRewardReleaseRecord(
        uint256 amount,
        address account,
        uint256 nodeId,
        uint256 nonce
    ) public {}
}

abstract contract IHyperdustRenderTranscitionAddress {
    function updateEpoch() public {}
}

contract Hyperdust_Render_Awards is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _id;

    address public _rolesCfgAddress;

    address public _hyperdustNodeMgrAddress;

    address public _hyperdustSecurityDeposit;

    address public _hyperdustBaseRewardRelease;

    address public _hyperdustRenderTranscitionAddress;

    address public _HyperdustTokenAddress;

    uint256 private _rand = 1;

    event eveRewards(
        uint256 nodeId,
        uint256 epochAward,
        uint256 rand,
        uint256 nonce
    );

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setHyperdustNodeMgrAddress(
        address hyperdustNodeMgrAddress
    ) public onlyOwner {
        _hyperdustNodeMgrAddress = hyperdustNodeMgrAddress;
    }

    function setHyperdustSecurityDeposit(
        address hyperdustSecurityDeposit
    ) public onlyOwner {
        _hyperdustSecurityDeposit = hyperdustSecurityDeposit;
    }

    function setHyperdustBaseRewardRelease(
        address hyperdustBaseRewardRelease
    ) public onlyOwner {
        _hyperdustBaseRewardRelease = hyperdustBaseRewardRelease;
    }

    function setHyperdustRenderTranscitionAddress(
        address hyperdustRenderTranscitionAddress
    ) public onlyOwner {
        _hyperdustRenderTranscitionAddress = hyperdustRenderTranscitionAddress;
    }

    function setHyperdustTokenAddress(
        address HyperdustTokenAddress
    ) public onlyOwner {
        _HyperdustTokenAddress = HyperdustTokenAddress;
    }

    /**
     * @dev Sets the contract addresses for Hyperdust Render Awards.
     * @param contractaddressArray An array of contract addresses to be set.
     * 0: Roles configuration contract address.
     * 1: Hyperdust node manager contract address.
     * 2: Hyperdust security deposit contract address.
     * 3: Hyperdust base reward release contract address.
     * 4: Hyperdust render transition contract address.
     * 5: Hyperdust token contract address.
     * Emits a {ContractAddressSet} event.
     */
    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _hyperdustNodeMgrAddress = contractaddressArray[1];
        _hyperdustSecurityDeposit = contractaddressArray[2];
        _hyperdustBaseRewardRelease = contractaddressArray[3];
        _hyperdustRenderTranscitionAddress = contractaddressArray[4];
        _HyperdustTokenAddress = contractaddressArray[5];
    }

    /**
     * @dev Distributes rewards to a randomly selected active node based on the number of active nodes and total nodes.
     * @param nodeStatus An array of node statuses.
     * @param nonce A random number used to ensure uniqueness of the rewards distribution.
     */
    function rewards(bytes32[] memory nodeStatus, uint256 nonce) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        (
            uint256[] memory activeNodes,
            uint256 _totalNum,
            uint256 _activeNum
        ) = countActiveNode(nodeStatus);

        IHyperdustNodeMgr hyperdustNodeMgrAddress = IHyperdustNodeMgr(
            _hyperdustNodeMgrAddress
        );

        IHyperdustToken hyperdustToken = IHyperdustToken(
            _HyperdustTokenAddress
        );

        uint256 epochAward = hyperdustToken._epochAward();

        IHyperdustRenderTranscitionAddress(_hyperdustRenderTranscitionAddress)
            .updateEpoch();

        if (_totalNum < 100) {
            _totalNum = 100;
        }

        if (_activeNum == 0 || epochAward == 0) {
            return;
        }

        uint index = _getRandom(0, _activeNum);

        uint256 nodeId = activeNodes[index];

        uint256 actualEpochAward = epochAward / (_totalNum / _activeNum);
        uint256 securityDeposit = actualEpochAward / 10;
        uint256 baseRewardReleaseAward = actualEpochAward - securityDeposit;

        hyperdustToken.mint(actualEpochAward);

        hyperdustToken.transfer(
            _hyperdustBaseRewardRelease,
            baseRewardReleaseAward
        );

        hyperdustToken.transfer(_hyperdustSecurityDeposit, securityDeposit);

        IHyperdustSecurityDeposit(_hyperdustSecurityDeposit).addSecurityDeposit(
            nodeId,
            securityDeposit
        );

        (address incomeAddress, , ) = hyperdustNodeMgrAddress.getNode(nodeId);

        IHyperdustBaseRewardRelease(_hyperdustBaseRewardRelease)
            .addBaseRewardReleaseRecord(
                baseRewardReleaseAward,
                incomeAddress,
                nodeId,
                nonce
            );

        emit eveRewards(nodeId, actualEpochAward, index, nonce);
    }

    /**
     * @dev Counts the number of active nodes and returns an array of their IDs, as well as the total number of nodes and active nodes.
     * @param nodeStatus An array of bytes32 representing the status of each node.
     * @return A tuple containing an array of uint256 representing the IDs of active nodes, the total number of nodes, and the number of active nodes.
     */
    function countActiveNode(
        bytes32[] memory nodeStatus
    ) private returns (uint256[] memory, uint256, uint256) {
        IHyperdustNodeMgr hyperdustNodeMgrAddress = IHyperdustNodeMgr(
            _hyperdustNodeMgrAddress
        );

        uint32 activeNum = 0;
        uint32 totalNum = 0;

        (uint256 totalSize, , ) = hyperdustNodeMgrAddress.getStatisticalIndex();

        uint256[] memory activeNodes = new uint256[](totalSize);

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < nodeStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                uint256 nodeId = hyperdustNodeMgrAddress.getIdByIndex(index);

                if (nodeId == 0) {
                    break;
                }

                bytes1 status = bytes1(nodeStatus[i][j]);

                if (status != 0x00) {
                    totalNum++;

                    if (status == 0x11) {
                        activeNum++;
                        activeNodes[activeIndex] = nodeId;
                        activeIndex++;
                    }
                }
                index++;
            }
        }

        hyperdustNodeMgrAddress.setStatisticalIndex(totalNum, activeNum);

        return (activeNodes, totalNum, activeNum);
    }

    /**
     * @dev Generates a random number between _start and _end (exclusive) using block difficulty, timestamp and a private variable _rand.
     * @param _start The start of the range (inclusive).
     * @param _end The end of the range (exclusive).
     * @return A random number between _start and _end (exclusive).
     */
    function _getRandom(
        uint256 _start,
        uint256 _end
    ) private returns (uint256) {
        if (_start == _end) {
            return _start;
        }
        uint256 _length = _end - _start;
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(block.difficulty, block.timestamp, _rand)
            )
        );
        random = (random % _length) + _start;
        _rand++;
        return random;
    }
}
