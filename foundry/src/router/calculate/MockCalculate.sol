// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICalculate} from "./ICalculate.sol"; 
import {ResponseMessage} from "../message/ResponseMessage.sol";

contract MockCalculate is ICalculate {

    using ResponseMessage for bytes;

    uint256 public carbonEmissionFactor;
    bytes public merkleRoot;

    mapping(uint8 => uint256) public emissionFactors;

    // Event to log the emission factor updates
    event EmissionFactorUpdated(uint8 travelType, uint256 emissionFactor);

    function setEmissionFactor(uint8 travelType, uint256 factor) external {
        emissionFactors[travelType] = factor;
        emit EmissionFactorUpdated(travelType, factor);
    }

    function calculate(uint8 travelType, uint256 distance, uint256 duration, uint256 points) external view returns (bytes memory) {
        uint256 factor = emissionFactors[travelType];
        bytes memory message = ResponseMessage.format(factor, distance, duration);
        return message;
    }

    function updateEmissionFactorsFromValidator(uint8 travelType, uint256 factor, bytes calldata merkleRoot) external {
        // This function will be called by the validator to update the emission factors, the validity is provided by flare

        // before updating the validity of the data source will be checked
    }
}
