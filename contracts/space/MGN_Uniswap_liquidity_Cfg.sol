pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "../utils/StrUtil.sol";

abstract contract IMGNRolesCfg {
    function hasAdminRole(address account) public view returns (bool) {}
}

contract MGN_Uniswap_liquidity_Cfg is Ownable {
    address public _rolesCfgAddress;
    mapping(address => LiquidityCfg[]) public _liquidityCfgs;

    struct LiquidityCfg {
        uint256 liquidity;
        uint256 airdropNum;
    }

    event eveAdd(address token, uint256[] liquidity, uint256[] airdropNum);

    event eveDelete(address token, uint256[] liquidity);

    function setRolesCfgAddress(address rolesCfgAddress) public onlyOwner {
        _rolesCfgAddress = rolesCfgAddress;
    }

    function add(
        address token,
        uint256[] memory liquiditys,
        uint256[] memory airdropNums
    ) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        for (uint i = 0; i < liquiditys.length; i++) {
            _liquidityCfgs[token].push(
                LiquidityCfg({
                    liquidity: liquiditys[i],
                    airdropNum: airdropNums[i]
                })
            );
        }

        emit eveAdd(token, liquiditys, airdropNums);
    }

    function del(address token, uint256[] memory liquiditys) public {
        require(
            IMGNRolesCfg(_rolesCfgAddress).hasAdminRole(msg.sender),
            "not admin role"
        );

        LiquidityCfg[] memory liquidityCfgs = _liquidityCfgs[token];

        for (uint i = 0; i < liquiditys.length; i++) {
            for (uint j = 0; j < liquidityCfgs.length; j++) {
                if (liquidityCfgs[j].liquidity == liquiditys[i]) {
                    _liquidityCfgs[token][i] = _liquidityCfgs[token][
                        _liquidityCfgs[token].length - 1
                    ];
                    _liquidityCfgs[token].pop();
                }
            }
        }
        emit eveDelete(token, liquiditys);
    }

    function getLiquidityCfgList(
        address token
    ) public view returns (LiquidityCfg[] memory) {
        LiquidityCfg[] memory sortedData = _liquidityCfgs[token];

        uint n = sortedData.length;

        if (n > 1) {
            for (uint i = 0; i < n - 1; i++) {
                for (uint j = 0; j < n - i - 1; j++) {
                    if (sortedData[j].liquidity < sortedData[j + 1].liquidity) {
                        // 交换元素
                        (sortedData[j], sortedData[j + 1]) = (
                            sortedData[j + 1],
                            sortedData[j]
                        );
                    }
                }
            }
        }

        return sortedData;
    }
}
