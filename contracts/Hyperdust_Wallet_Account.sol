pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "./utils/StrUtil.sol";

abstract contract IHyperdustRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

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

contract Hyperdust_Wallet_Account is Ownable {
    using Strings for *;
    using StrUtil for *;

    AmountConfInfo[] public _amountConfInfos;
    address public _erc20Address;

    address public _rolesCfgAddress;

    enum AccountType {
        TVL,
        PLATFORM_RESERVE,
        TEAM,
        BURN
    }

    struct AmountConfInfo {
        AccountType accountType;
        uint256 allocateAmount;
        uint256 useAmount;
        uint8 proportion;
        bool allowSettlement;
        address contractAddress;
    }

    constructor() {
        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.TVL,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 40,
                allowSettlement: true,
                contractAddress: address(0)
            })
        );

        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.PLATFORM_RESERVE,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 20,
                allowSettlement: true,
                contractAddress: address(0)
            })
        );

        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.TEAM,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 24,
                allowSettlement: true,
                contractAddress: address(0)
            })
        );

        _amountConfInfos.push(
            AmountConfInfo({
                accountType: AccountType.BURN,
                allocateAmount: 0,
                useAmount: 0,
                proportion: 16,
                allowSettlement: false,
                contractAddress: address(0)
            })
        );
    }

    function setErc20Address(address erc20Address) public onlyOwner {
        _erc20Address = erc20Address;
    }

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function updateAmountConfInfoAddress(
        address[] memory addressList
    ) public onlyOwner {
        for (uint i = 0; i < _amountConfInfos.length; i++) {
            _amountConfInfos[i].contractAddress = addressList[i];
        }
    }

    function setContractAddress(
        address[] memory contractaddressArray
    ) public onlyOwner {
        _rolesCfgAddress = contractaddressArray[0];
        _erc20Address = contractaddressArray[1];
    }

    function list()
        public
        view
        returns (
            string[] memory accountTypes,
            uint256[] memory,
            uint256[] memory,
            uint8[] memory,
            bool[] memory,
            address[] memory
        )
    {
        string[] memory accountTypes = new string[](_amountConfInfos.length);
        uint256[] memory allocateAmounts = new uint256[](
            _amountConfInfos.length
        );
        uint256[] memory useAmounts = new uint256[](_amountConfInfos.length);
        uint8[] memory proportions = new uint8[](_amountConfInfos.length);
        bool[] memory allowSettlements = new bool[](_amountConfInfos.length);
        address[] memory contractAddresses = new address[](
            _amountConfInfos.length
        );

        for (uint i = 0; i < _amountConfInfos.length; i++) {
            AmountConfInfo memory amountConfInfo = _amountConfInfos[i];

            accountTypes[i] = accountTypeToString(amountConfInfo.accountType);
            allocateAmounts[i] = amountConfInfo.allocateAmount;
            useAmounts[i] = amountConfInfo.useAmount;
            proportions[i] = amountConfInfo.proportion;
            allowSettlements[i] = amountConfInfo.allowSettlement;
            contractAddresses[i] = amountConfInfo.contractAddress;
        }

        return (
            accountTypes,
            allocateAmounts,
            useAmounts,
            proportions,
            allowSettlements,
            contractAddresses
        );
    }

    function accountTypeToString(
        AccountType _accountType
    ) public pure returns (string memory) {
        if (_accountType == AccountType.TVL) {
            return "TVL";
        } else if (_accountType == AccountType.PLATFORM_RESERVE) {
            return "PLATFORM_RESERVE";
        } else if (_accountType == AccountType.TEAM) {
            return "TEAM";
        } else if (_accountType == AccountType.BURN) {
            return "BURN";
        } else {
            revert("Invalid account type");
        }
    }

    function get(
        AccountType accountType
    ) public view returns (AmountConfInfo memory) {
        for (uint i = 0; i < _amountConfInfos.length; i++) {
            if (_amountConfInfos[i].accountType == accountType) {
                AmountConfInfo memory amountConfInfo = _amountConfInfos[i];

                return amountConfInfo;
            }
        }

        revert("not found");
    }

    function addAmount(uint256 amount) public {
        require(
            IHyperdustRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint i = 0; i < _amountConfInfos.length; i++) {
            _amountConfInfos[i].allocateAmount +=
                (amount * _amountConfInfos[i].proportion) /
                100;
        }
    }

    function settlementAmount(
        AccountType accountType,
        uint256 amount,
        address account
    ) public {
        IERC20 erc20 = IERC20(_erc20Address);

        for (uint i = 0; i < _amountConfInfos.length; i++) {
            if (_amountConfInfos[i].accountType == accountType) {
                AmountConfInfo memory amountConfInfo = _amountConfInfos[i];

                require(
                    msg.sender == amountConfInfo.contractAddress,
                    "No permission"
                );

                require(amountConfInfo.allowSettlement, "Billing not allowed");

                require(
                    amountConfInfo.allocateAmount -
                        amountConfInfo.useAmount -
                        amount >=
                        0,
                    "invalid amount"
                );

                _amountConfInfos[i].useAmount += amount;

                erc20.transfer(account, amount);

                return;
            }
        }

        revert("not found");
    }
}
