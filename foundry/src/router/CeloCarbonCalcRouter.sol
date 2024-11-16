// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TokenRouter} from "@hyperlane-xyz/core/contracts/token/libs/TokenRouter.sol";
import {GasRouter} from "@hyperlane-xyz/core/contracts/client/GasRouter.sol";
import {RequestMessage} from "./message/RequestMessage.sol";
import {ResponseMessage} from "./message/ResponseMessage.sol";

contract CeloCarbonCalcRouter is GasRouter {
    using RequestMessage for bytes;
    using ResponseMessage for bytes;

    constructor(address _mailbox) GasRouter(_mailbox) {}
    event SendMessage(uint8 travelType, uint256 distance, uint256 duration, uint256 points);
    event RecievedMessage(uint256 carbonOffset, uint256 energyConverted, uint256 points, uint256 origin );


    //input for the calculation
    function sendMessage(
        uint8 _travelType,
        uint256 _distance,
        uint256 _duration,
        uint256 _points
    ) external {
        bytes memory _message = RequestMessage.format(_travelType, _distance, _duration, _points);
        emit SendMessage(_travelType, _distance, _duration, _points);
        _GasRouter_dispatch(421614, 10000000000000000, _message, address(0));
    }
    
    
    // get the output of the calculation and send back to the user
    function _handle(
        uint32 _origin,
        bytes32,
        bytes calldata _message
    ) internal virtual override {
        (uint256 _carbonOffset,
        uint256 _energyConverted,
        uint256 _points) = ResponseMessage.returnAll(_message);
        emit RecievedMessage(_carbonOffset, _energyConverted, _points,_origin);
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