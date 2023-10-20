pragma solidity ^0.8.0;

abstract contract IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {}

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {}

    function balanceOf(address account) external view returns (uint256) {}

    function approve(address spender, uint256 amount) external returns (bool) {}

    function mint(address to, uint256 amount) public {}

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {}
}

abstract contract IHyperdustNodeMgr {
    struct Node {
        address incomeAddress;
        string ip; //Node public network IP
        uint256[] uint256Array; //id,nodeType,cpuNum,memoryNum,diskNum,cudaNum,videoMemory
    }

    function getNodeObj(uint256 id) public view returns (Node memory) {}

    function updateStatus(uint256 nodeId, string memory status) public {}

    function count() public view returns (uint256, uint256) {}
}

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IHyperdustWalletAccount {
    function addAmount(uint256 amount) public {}
}

abstract contract IHyperdustTransactionCfg {
    function get(string memory key) public view returns (uint256) {}
}

abstract contract IHyperdustHYDTPrice {
    function getHYDTPrice() public view returns (uint256) {}
}

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import {StrUtil} from "../utils/StrUtil.sol";

contract Hyperdust_Render_Transcition is Ownable {
    using Strings for *;
    using StrUtil for *;

    using Counters for Counters.Counter;
    Counters.Counter private _id;
    address public _rolesCfgAddress;
    address public _erc20Address;
    address public _nodeMgrAddress;
    address public _transactionCfgAddress;
    address public _walletAccountAddress;
    address public _HYDTPriceAddress;

    struct RenderTranscition {
        address serviceAccount;
        address account;
        uint256[] uint256Array; //id,time,amount,createTime,endTime,nodeId
    }

    event eveRenderTranscitionSave(uint256 id);

    RenderTranscition[] public _renderTranscitions;

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function setNodeMgrAddress(address nodeMgrAddress) public onlyOwner {
        _nodeMgrAddress = nodeMgrAddress;
    }

    function setTransactionCfg(address transactionCfgAddress) public onlyOwner {
        _transactionCfgAddress = transactionCfgAddress;
    }

    function setWalletAccountAddress(
        address walletAccountAddress
    ) public onlyOwner {
        _walletAccountAddress = walletAccountAddress;
    }

    function setHYDTPriceAddress(address HYDTPriceAddress) public onlyOwner {
        _HYDTPriceAddress = HYDTPriceAddress;
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _nodeMgrAddress = contractaddressArray[2];
        _transactionCfgAddress = contractaddressArray[3];
        _walletAccountAddress = contractaddressArray[4];
        _HYDTPriceAddress = contractaddressArray[5];
    }

    function calculateCommission(uint256 time) public view returns (uint256) {
        uint256 renderPrice = IHyperdustTransactionCfg(_transactionCfgAddress)
            .get("render");

        uint256 HYDTPrice = IHyperdustHYDTPrice(_HYDTPriceAddress)
            .getHYDTPrice();

        uint256 commission = (renderPrice * time) / 10 + HYDTPrice;

        return commission;
    }

    function createRenderTranscition(
        uint256 nodeId,
        uint256 time
    ) public returns (uint256) {
        IHyperdustNodeMgr nodeMgr = IHyperdustNodeMgr(_nodeMgrAddress);

        IERC20 erc20 = IERC20(_erc20Address);
        IHyperdustNodeMgr.Node memory node = nodeMgr.getNodeObj(nodeId);

        require(node.uint256Array[0] != 0, "The miner node inexistence");

        uint256 commission = calculateCommission(time);

        uint256 amount = erc20.allowance(msg.sender, address(this));

        require(amount >= commission, "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, _walletAccountAddress, commission);

        IHyperdustWalletAccount(_walletAccountAddress).addAmount(amount);

        _id.increment();

        uint256 createTime = block.timestamp;

        uint256[] memory uint256Array = new uint256[](10);
        uint256Array[0] = _id.current();
        uint256Array[1] = time;
        uint256Array[2] = node.uint256Array[2];
        uint256Array[3] = commission;
        uint256Array[4] = createTime;
        uint256Array[5] = createTime + time * 60;
        uint256Array[6] = nodeId;

        _renderTranscitions.push(
            RenderTranscition(node.incomeAddress, msg.sender, uint256Array)
        );

        emit eveRenderTranscitionSave(_id.current());

        return _id.current();
    }

    function getRenderTranscition(
        uint256 id
    ) public view returns (address, address, uint256[] memory) {
        for (uint256 i = 0; i < _renderTranscitions.length; i++) {
            if (_renderTranscitions[i].uint256Array[0] == id) {
                return (
                    _renderTranscitions[i].serviceAccount,
                    _renderTranscitions[i].account,
                    _renderTranscitions[i].uint256Array
                );
            }
        }

        revert("renderTranscition not found");
    }
}
