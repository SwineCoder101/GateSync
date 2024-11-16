// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ResponseMessage {
    function format(
        uint256 _carbonOffset,
        uint256 _energyConverted,
        uint256 _points
    ) internal pure returns (bytes memory) {
        return abi.encode(_carbonOffset, _energyConverted, _points);
    }

    function carbonOffset(bytes memory message) internal pure returns (uint256) {
        require(message.length >= 1, "Message too short for travelType");
        (uint256 _carbonOffset, uint256 _energyConverted, uint256 _points) = abi.decode(message, (uint8, uint256, uint256));
        return _carbonOffset;
    }

    function energyConverted(bytes memory message) internal pure returns (uint256) {
        require(message.length >= 1, "Message too short for travelType");
        (uint256 _carbonOffset, uint256 _energyConverted, uint256 _points) = abi.decode(message, (uint8, uint256, uint256));
        return _energyConverted;
    }

    function points(bytes memory message) internal pure returns (uint256) {
        require(message.length >= 1, "Message too short for travelType");
        (uint256 _carbonOffset, uint256 _energyConverted, uint256 _points) = abi.decode(message, (uint8, uint256, uint256));
        return _points;
    }

    function returnAll(bytes memory message) internal pure returns (uint256, uint256, uint256) {
        require(message.length >= 1, "Message too short for travelType");
        (uint256 _carbonOffset, uint256 _energyConverted, uint256 _points) = abi.decode(message, (uint8, uint256, uint256));
        return (_carbonOffset, _energyConverted, _points);
    }
}
