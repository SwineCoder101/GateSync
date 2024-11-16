// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAuthorize} from "./IAuthorize.sol";

contract Authorize is IAuthorize {
    
    function authorize(bytes calldata msg) external override returns (bool) {
        return true;
    }

}