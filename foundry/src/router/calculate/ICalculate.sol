// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICalculate {
    function calculate(uint8 travelType, uint256 distance, uint256 duration, uint256 points) external view returns (bytes memory);
}