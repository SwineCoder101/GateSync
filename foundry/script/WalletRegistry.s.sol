// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/WalletRegistry.sol";

contract DeployWalletRegistry is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the WalletRegistry contract
        WalletRegistry walletRegistry = new WalletRegistry();

        vm.stopBroadcast();

        // Log the address of the deployed contract
        console.log("WalletRegistry deployed at:", address(walletRegistry));
    }
}