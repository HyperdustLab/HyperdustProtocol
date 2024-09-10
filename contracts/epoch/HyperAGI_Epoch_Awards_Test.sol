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

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./../HyperAGI_Roles_Cfg.sol";
import "./HyperAGI_BaseReward_Release.sol";
import "./HyperAGI_Security_Deposit.sol";
import "./../finance/HyperAGI_GPUMining.sol";
import "./../node/HyperAGI_Node_Mgr.sol";

import "./../HyperAGI_Wallet_Account.sol";

import "hardhat/console.sol";

contract HyperAGI_Epoch_Awards_Test {
    using Strings for *;
    using StrUtil for *;

    function countActiveNode(bytes32[] memory nodeStatus) public view returns (uint256[] memory, uint256[] memory, uint256, uint256) {
        uint256 activeNum = 0;
        uint256 totalNum = 0;

        uint256[] memory ids = new uint256[](15);
        ids[0] = 1;
        ids[1] = 2;
        ids[2] = 3;
        ids[3] = 4;
        ids[4] = 5;
        ids[5] = 6;
        ids[6] = 7;
        ids[7] = 9;
        ids[8] = 11;
        ids[9] = 10;
        ids[10] = 12;
        ids[11] = 14;
        ids[12] = 13;
        ids[13] = 16;
        ids[14] = 17;
        uint256 totalSize = ids.length;

        uint256[] memory activeNodes = new uint256[](totalSize);
        uint256[] memory onlineNodes = new uint256[](totalSize);

        uint256 index = 0;
        uint256 activeIndex = 0;

        for (uint i = 0; i < nodeStatus.length; i++) {
            for (uint j = 0; j < 32; j++) {
                if (index >= totalSize) {
                    break;
                }

                bytes1 status = bytes1(nodeStatus[i][j]);

                if (status != 0x00) {
                    uint256 nodeId = ids[index];

                    onlineNodes[totalNum] = nodeId;
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

        return (activeNodes, onlineNodes, totalNum, activeNum);
    }
}
