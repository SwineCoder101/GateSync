pragma solidity ^0.8.13;

import {ICallSolana} from "./interfaces/ICallSolana.sol";

contract NeonEVMTokenBalanceReader {
    uint256 public balance;
    ICallSolana private callSolana;

    constructor() {
        callSolana = ICallSolana(0x776E4abe7d73Fed007099518F3aA02C8dDa9baA0);
    }

    function getAssociatedTokenAddress(bytes32 token, address walletAddress, bytes memory get_associated_token_address) public view returns (uint256) {
        //get token balance of the account
        bytes pubkey = callSolana.execute(gas, get_associated_token_address);

        //get balance of the token
        bytes tokenBalanceData = callSolana.execute(0,get_account_info);

        return abi.decode(tokenBalanceData, (uint256));
    }

    //bytes memory get_account_info
    // function getAccountInfo()
}