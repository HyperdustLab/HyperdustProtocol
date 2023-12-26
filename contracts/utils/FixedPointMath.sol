library FixedPointMath {
    struct FixedPoint {
        int256 rawValue;
    }

    int256 constant FIXED_ONE = 10 ** 18;

    function fromU256(uint256 value) internal pure returns (FixedPoint memory) {
        return FixedPoint(int256(value) * FIXED_ONE);
    }

    function mul(
        FixedPoint memory a,
        FixedPoint memory b
    ) internal pure returns (FixedPoint memory) {
        return FixedPoint((a.rawValue * b.rawValue) / FIXED_ONE);
    }

    function div(
        FixedPoint memory a,
        FixedPoint memory b
    ) internal pure returns (FixedPoint memory) {
        return FixedPoint((a.rawValue * FIXED_ONE) / b.rawValue);
    }

    function toInt(FixedPoint memory a) internal pure returns (int256) {
        return a.rawValue / FIXED_ONE;
    }

    function intToUint(int256 signedNumber) external pure returns (uint256) {
        require(signedNumber >= 0, "Value must be non-negative");

        uint256 unsignedNumber = uint256(signedNumber);
        return unsignedNumber;
    }
}
