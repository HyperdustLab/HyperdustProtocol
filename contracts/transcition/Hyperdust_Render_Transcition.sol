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

    function getStatisticalIndex()
        public
        view
        returns (uint256, uint32, uint32)
    {}
}

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

abstract contract IHyperdustWalletAccount {
    function addAmount(uint256 amount) public {}
}

abstract contract IHyperdustTransactionCfg {
    function get(string memory key) public view returns (uint256) {}

    function getGasFee(string memory func) public view returns (uint256) {}
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

    struct RenderTranscition {
        uint256 id;
        address serviceAccount;
        address account;
        uint32 epoch;
        uint32 useEpoch;
        uint256 amount;
        uint256 createTime;
        uint256 endTime;
        uint256 nextEndTime;
        uint256 nodeId;
        bytes1 status;
        uint256[] epochAmounts;
        uint256[] epochTimes;
    }

    event eveRenderTranscitionSave(uint256 id);

    event eveUpdateRenderEpoch(uint256[] success, uint256[] fail);

    RenderTranscition[] public _renderTranscitions;

    uint256[] public _runingRenderTranscitions;

    mapping(address => uint256) public _runingRenderAccounts;

    mapping(uint256 => uint256) public _runingRenderNodes;

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

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
        _nodeMgrAddress = contractaddressArray[2];
        _transactionCfgAddress = contractaddressArray[3];
        _walletAccountAddress = contractaddressArray[4];
    }

    function createRenderTranscition(
        uint256 nodeId,
        uint32 epoch
    ) public returns (uint256) {
        checkRenderTranscition(msg.sender);
        checkRenderNode(nodeId);

        IHyperdustNodeMgr nodeMgr = IHyperdustNodeMgr(_nodeMgrAddress);

        IERC20 erc20 = IERC20(_erc20Address);
        IHyperdustNodeMgr.Node memory node = nodeMgr.getNodeObj(nodeId);

        require(node.uint256Array[0] != 0, "The miner node inexistence");

        uint256 commission = IHyperdustTransactionCfg(_transactionCfgAddress)
            .getGasFee("render");

        uint256 amount = erc20.allowance(msg.sender, address(this));

        require(amount >= commission, "Insufficient authorized amount");

        erc20.transferFrom(msg.sender, _walletAccountAddress, commission);

        IHyperdustWalletAccount(_walletAccountAddress).addAmount(amount);

        _id.increment();

        uint256 createTime = block.timestamp;

        bytes1 status = 0x11;

        if (epoch > 1) {
            status = 0x00;
        }

        RenderTranscition memory renderTranscition = RenderTranscition(
            _id.current(),
            node.incomeAddress,
            msg.sender,
            epoch,
            1,
            commission,
            createTime,
            createTime + (epoch * 60 * 64) / 10,
            createTime + (60 * 64) / 10,
            nodeId,
            status,
            new uint256[](epoch),
            new uint256[](epoch)
        );

        renderTranscition.epochAmounts[0] = commission;
        renderTranscition.epochTimes[0] = createTime;

        _renderTranscitions.push(renderTranscition);

        if (epoch > 1) {
            _runingRenderTranscitions.push(_id.current());
        }

        _runingRenderAccounts[msg.sender] = _id.current();
        _runingRenderNodes[nodeId] = _id.current();

        emit eveRenderTranscitionSave(_id.current());

        return _id.current();
    }

    function checkRenderTranscition(address account) private {
        uint256 _runingRenderTranscitionId = _runingRenderAccounts[account];

        if (_runingRenderTranscitionId == 0) {
            return;
        }

        RenderTranscition memory renderTranscition = _renderTranscitions[
            _runingRenderTranscitionId - 1
        ];

        require(
            renderTranscition.status == 0x11 &&
                block.timestamp > renderTranscition.nextEndTime,
            "You have an Render Transcition running"
        );
    }

    function checkRenderNode(uint256 nodeId) private {
        uint256 _runingRenderTranscitionId = _runingRenderNodes[nodeId];

        if (_runingRenderTranscitionId == 0) {
            return;
        }

        RenderTranscition memory renderTranscition = _renderTranscitions[
            _runingRenderTranscitionId - 1
        ];

        require(
            renderTranscition.status == 0x11 &&
                block.timestamp > renderTranscition.nextEndTime,
            "The render node is already in use"
        );
    }

    function updateEpoch() public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        if (_runingRenderTranscitions.length == 0) {
            return;
        }

        IERC20 erc20 = IERC20(_erc20Address);

        uint256 commission = IHyperdustTransactionCfg(_transactionCfgAddress)
            .getGasFee("render");

        uint256 totalAmount = 0;

        uint256[] memory success = new uint256[](
            _runingRenderTranscitions.length
        );

        uint256[] memory fail = new uint256[](_runingRenderTranscitions.length);

        uint32 successIndex = 0;
        uint32 failIndex = 0;

        uint256[] memory runingRenderTranscitions = _runingRenderTranscitions;

        for (uint i = 0; i < runingRenderTranscitions.length; i++) {
            uint256 id = runingRenderTranscitions[i];

            RenderTranscition memory renderTranscition = _renderTranscitions[
                id - 1
            ];

            uint256 amount = erc20.allowance(
                renderTranscition.account,
                address(this)
            );

            uint256 balance = erc20.balanceOf(renderTranscition.account);

            if (amount >= commission && balance >= commission) {
                erc20.transferFrom(
                    renderTranscition.account,
                    _walletAccountAddress,
                    commission
                );
                _renderTranscitions[id - 1].useEpoch++;

                if (
                    _renderTranscitions[id - 1].useEpoch >=
                    renderTranscition.epoch
                ) {
                    _renderTranscitions[id - 1].status = 0x11;
                }

                _renderTranscitions[id - 1].nextEndTime =
                    _renderTranscitions[id - 1].nextEndTime +
                    (60 * 64) /
                    10;

                uint32 useEpoch = _renderTranscitions[id - 1].useEpoch;

                _renderTranscitions[id - 1].epochAmounts[
                    useEpoch - 1
                ] = commission;

                _renderTranscitions[id - 1].epochTimes[useEpoch - 1] = block
                    .timestamp;

                _renderTranscitions[id - 1].amount =
                    _renderTranscitions[id - 1].amount +
                    commission;
                totalAmount += commission;

                success[successIndex] = id;
                successIndex++;

                if (
                    _renderTranscitions[id - 1].useEpoch >=
                    renderTranscition.epoch
                ) {
                    cleanRuningRenderTranscitions(id);
                }
            } else {
                cleanRuningRenderTranscitions(id);

                fail[failIndex] = id;
                failIndex++;

                _renderTranscitions[id - 1].status = 0x11;
            }
        }

        if (totalAmount > 0) {
            IHyperdustWalletAccount(_walletAccountAddress).addAmount(
                totalAmount
            );
        }

        uint256[] memory _success = new uint256[](successIndex);

        uint256[] memory _fail = new uint256[](failIndex);

        for (uint i = 0; i < successIndex; i++) {
            _success[i] = success[i];
        }

        for (uint i = 0; i < failIndex; i++) {
            _fail[i] = fail[i];
        }

        emit eveUpdateRenderEpoch(_success, _fail);
    }

    function cleanRuningRenderTranscitions(uint256 id) private {
        _renderTranscitions[id - 1].status = 0x11;

        for (uint i = 0; i < _runingRenderTranscitions.length; i++) {
            if (_runingRenderTranscitions[i] == id) {
                if (i != _runingRenderTranscitions.length - 1) {
                    _runingRenderTranscitions[i] = _runingRenderTranscitions[
                        _runingRenderTranscitions.length - 1
                    ];
                }

                _runingRenderTranscitions.pop();
            }
        }
    }

    function getRenderTranscition(
        uint256 id
    )
        public
        view
        returns (
            address,
            address,
            uint32,
            uint32,
            uint256[] memory,
            bytes1,
            uint256[] memory,
            uint256[] memory
        )
    {
        RenderTranscition memory renderTranscition = _renderTranscitions[
            id - 1
        ];

        uint256[] memory uint256Array = new uint256[](6);
        uint256Array[0] = renderTranscition.id;
        uint256Array[1] = renderTranscition.amount;
        uint256Array[2] = renderTranscition.createTime;
        uint256Array[3] = renderTranscition.endTime;
        uint256Array[4] = renderTranscition.nextEndTime;
        uint256Array[5] = renderTranscition.nodeId;

        return (
            renderTranscition.serviceAccount,
            renderTranscition.account,
            renderTranscition.epoch,
            renderTranscition.useEpoch,
            uint256Array,
            renderTranscition.status,
            renderTranscition.epochAmounts,
            renderTranscition.epochTimes
        );
    }

    function getRuningRenderTranscitions()
        public
        view
        returns (uint256[] memory)
    {
        return _runingRenderTranscitions;
    }

    function getRuningRenderAccounts(
        address account
    ) public view returns (uint256) {
        return _runingRenderAccounts[account];
    }

    function getRuningRenderNodes(
        uint256 nodeId
    ) public view returns (uint256) {
        return _runingRenderNodes[nodeId];
    }
}
