// src/hooks/useLinkWallet.ts

import { useState } from 'react';
import { ethers } from 'ethers';
import { EVMOriginInstructionSenderSDK } from '../sdk/sdk';

/**
 * Hook to handle wallet linking using the EVMOriginInstructionSenderSDK.
 */
export const useLinkWallet = (contractAddress: string) => {
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<boolean>(false);
  const [balance, setBalance] = useState<number | null>(null);

  /**
   * Initiates the wallet linking process.
   * @param evmAddress - The EVM (Ethereum) address.
   * @param solanaAddress - The Solana address in bytes32 format.
   * @param instruction - The instruction data.
   */
  const linkWallet = async (
    evmAddress: string,
    solanaAddress: string,
    instruction: string
  ) => {
    setLoading(true);
    setError(null);
    setSuccess(false);
    setBalance(null);

    try {
      // Check if MetaMask is installed
      if (!(window as any).ethereum) {
        throw new Error('MetaMask is not installed');
      }

      // Request account access
      await (window as any).ethereum.request({ method: 'eth_requestAccounts' });

      // Create a provider and SDK instance
      const provider = new ethers.providers.Web3Provider((window as any).ethereum);
      const sdk = new EVMOriginInstructionSenderSDK(provider, contractAddress);

      // Link the wallet
      const tx = await sdk.linkWallet(instruction, evmAddress, solanaAddress);
      await tx.wait();

      setSuccess(true);
    } catch (err: any) {
      setError(err.message || 'An unexpected error occurred');
    } finally {
      setLoading(false);
    }
  };

  /**
   * Retrieves the token balance for a specific token and wallet.
   * @param token - The token identifier.
   * @param walletAddress - The EVM (Ethereum) wallet address.
   * @param getAssociatedTokenAddressInstruction - The instruction to get the associated token address.
   */
  const fetchTokenBalance = async (
    token: string,
    walletAddress: string,
    getAssociatedTokenAddressInstruction: string
  ) => {
    setLoading(true);
    setError(null);
    setBalance(null);

    try {
      if (!(window as any).ethereum) {
        throw new Error('MetaMask is not installed');
      }

      const provider = new ethers.providers.Web3Provider((window as any).ethereum);
      const sdk = new EVMOriginInstructionSenderSDK(provider, contractAddress);

      const tokenBalance = await sdk.getTokenBalance(
        token,
        walletAddress,
        getAssociatedTokenAddressInstruction
      );

      setBalance(tokenBalance);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch token balance');
    } finally {
      setLoading(false);
    }
  };

  return {
    loading,
    error,
    success,
    balance,
    linkWallet,
    fetchTokenBalance,
  };
};
