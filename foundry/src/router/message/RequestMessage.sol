// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library RequestMessage {
    function format(
        uint8 _travelType,
        uint256 _distance,
        uint256 _duration,
        uint256 _points
    ) internal pure returns (bytes memory) {
        return abi.encode(_travelType, _distance, _duration,_points);
    }

    function travelType(bytes memory message) internal pure returns (uint8) {
        require(message.length >= 1, "Message too short for travelType");
        (uint8 _travelType, uint256 _distance, uint256 _duration, uint256 _points) = abi.decode(message, (uint8, uint256, uint256, uint256));
        return _travelType;
    }

    function distance(bytes memory message) internal pure returns (uint256) {
        require(message.length >= 33, "Message too short for distance");
        (uint8 _travelType, uint256 _distance, uint256 _duration, uint256 _points) = abi.decode(message, (uint8, uint256, uint256, uint256));
        return _distance;
    }

    function duration(bytes memory message) internal pure returns (uint256) {
        require(message.length >= 33, "Message too short for distance");
        (uint8 _travelType, uint256 _distance, uint256 _duration, uint256 _points) = abi.decode(message, (uint8, uint256, uint256, uint256));
        return _duration;
    }

    function points(bytes memory message) internal pure returns (uint256) {
        require(message.length >= 33, "Message too short for distance");
        (uint8 travelType, uint256 distance, uint256 duration, uint256 _points) = abi.decode(message, (uint8, uint256, uint256, uint256));
        return _points;
    }

    function returnAll(bytes memory message) internal pure returns (uint8, uint256, uint256, uint256) {
        require(message.length >= 33, "Message too short for distance");
        (uint8 travelType, uint256 distance, uint256 duration, uint256 points) = abi.decode(message, (uint8, uint256, uint256, uint256));
        return (travelType, distance, duration, points);
    }
}
