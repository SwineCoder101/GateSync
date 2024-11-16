// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GasRouter} from "@hyperlane-xyz/core/contracts/client/GasRouter.sol";
import {RequestMessage} from "./message/RequestMessage.sol";
import {ResponseMessage} from "./message/ResponseMessage.sol";
import {ICalculate} from "./calculate/ICalculate.sol";

contract ArbitrumCarbonCalcRouter is GasRouter {

    using RequestMessage for bytes;
    using ResponseMessage for bytes;

    address public calculaterAddress;
    address public hookAuthorityAddress;
    address public destinationAddress;

    constructor(address _mailbox, address _destinationAddress, address _calculaterAddress) GasRouter(_mailbox) {

        if (_destinationAddress == address(0)) {
            revert("ArbitrumCarbonCalcRouter: destination address is zero");
        }

        if (_calculaterAddress == address(0)) {
            revert("ArbitrumCarbonCalcRouter: calculater address is zero");
        }

        destinationAddress = _destinationAddress;
        calculaterAddress = _calculaterAddress;
    }

    event ReceivedMessage(uint8 travelType, uint256 distance, uint256 duration, uint256 points,uint256 _origin);
    event SendMessage(uint256 carbonOffset, uint256 energyConverted, uint256 points);

    function sendMessage(
        bytes memory _message
    ) internal {

        (uint256 _carbonOffset, uint256 _energyConverted, uint256 _points) = ResponseMessage.returnAll(_message);
        emit SendMessage(_carbonOffset, _energyConverted, _points);
        _GasRouter_dispatch(44787, 10000000000000000, _message, hookAuthorityAddress);
    }

    // get the output of the calculation and send back to the user
    function _handle(
        uint32 _origin,
        bytes32,
        bytes calldata _message
    ) internal virtual override {

        (uint8 travelType, uint256 distance, uint256 duration, uint256 points) = RequestMessage.returnAll(_message);
        emit ReceivedMessage(travelType, distance, duration, points,_origin);

        // call the calculater contract
        ICalculate calculater = ICalculate(calculaterAddress);
        bytes memory response = calculater.calculate(travelType, distance, duration, points);

        // send the response back to the user on celo chain
        sendMessage(response);
    }

    // Transfer balance back to owner
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }

    // Allow contract to receive Ether
    receive() external payable {       
    }
    
}
