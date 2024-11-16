// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAuthorize} from "./IAuthorize.sol";

interface IAuthorize {
    function authorize(bytes calldata msg) external returns (bool);
}