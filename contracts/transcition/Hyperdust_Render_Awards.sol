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

abstract contract IHyperdustBaseRewardRelease {
    function addBaseRewardReleaseRecord(
        uint256 amount,
        address account,
        uint256 nodeId
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

    uint256 public _totalSupply = 2000000000 ether;

    uint256 public _totalAward = (_totalSupply * 62) / 100;

    uint256 public _residueTotalAward = _totalAward;

    uint256 timestamp = block.timestamp;

    uint256 public _currTotalAward = (_residueTotalAward * 10) / 100;

    uint256 public _epochAward = _currTotalAward / 365 / 225;

    address public _hyperdustNodeMgrAddress;

    address public _hyperdustSecurityDeposit;

    address public _hyperdustBaseRewardRelease;

    address public _hyperdustRenderTranscitionAddress;

    uint256 private _rand = 1;

    event eveRewards(uint256 nodeId, uint256 epochAward);

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

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _hyperdustNodeMgrAddress = contractaddressArray[1];
        _hyperdustSecurityDeposit = contractaddressArray[2];
        _hyperdustBaseRewardRelease = contractaddressArray[3];
        _hyperdustRenderTranscitionAddress = contractaddressArray[4];
    }

    function rewards(bytes32[] memory nodeStatus) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        uint256[] memory activeNodes = countActiveNode(nodeStatus);

        IHyperdustNodeMgr hyperdustNodeMgrAddress = IHyperdustNodeMgr(
            _hyperdustNodeMgrAddress
        );

        (, uint32 _activeNum, uint32 _totalNum) = hyperdustNodeMgrAddress
            .getStatisticalIndex();

        uint256 currYear = DateTime.getYear(block.timestamp);
        uint256 _currYear = DateTime.getYear(timestamp);

        if (currYear != _currYear) {
            resetCurrTotalAward();
        }

        if (_activeNum == 0 || _totalNum == 0 || _residueTotalAward == 0) {
            return;
        }

        uint index = _getRandom(0, _activeNum);

        uint256 nodeId = activeNodes[index];

        uint256 epochAward = _epochAward / _totalNum / _activeNum;

        _residueTotalAward -= epochAward;

        uint256 securityDeposit = (_epochAward * 10) / 100;

        IHyperdustSecurityDeposit(_hyperdustSecurityDeposit).addSecurityDeposit(
            nodeId,
            securityDeposit
        );

        (address incomeAddress, , ) = hyperdustNodeMgrAddress.getNode(nodeId);

        IHyperdustSecurityDeposit(_hyperdustSecurityDeposit).addSecurityDeposit(
            nodeId,
            securityDeposit
        );

        IHyperdustBaseRewardRelease(_hyperdustBaseRewardRelease)
            .addBaseRewardReleaseRecord(
                epochAward - securityDeposit,
                incomeAddress,
                nodeId
            );

        IHyperdustRenderTranscitionAddress(_hyperdustRenderTranscitionAddress)
            .updateEpoch();

        emit eveRewards(nodeId, epochAward);
    }

    function countActiveNode(
        bytes32[] memory nodeStatus
    ) private returns (uint256[] memory) {
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
            uint256 nodeId = hyperdustNodeMgrAddress.getIdByIndex(index);

            if (nodeId == 0) {
                break;
            }

            for (uint j = 0; j < 32; j++) {
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

        return activeNodes;
    }

    function resetCurrTotalAward() private {
        _currTotalAward = (_residueTotalAward * 10) / 100;
        timestamp = block.timestamp;
    }

    //TODO: change to on-chain random number generator
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
