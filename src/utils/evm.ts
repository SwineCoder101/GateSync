import { createPublicClient, parseUnits } from 'viem';
import erc20ABI from './abi/erc20.json';

/**
 * Fetch the balance of an ERC20 token for a given wallet address.
 * @param provider - Wallet provider injected by the frontend (e.g., MetaMask).
 * @param tokenAddress - The address of the ERC20 token contract.
 * @param walletAddress - The wallet address to check the balance of.
 * @returns {Promise<string>} - Token balance in human-readable format.
 */
export async function getERC20Balance(
  provider: any,
  tokenAddress: string,
  walletAddress: string
): Promise<string> {
  // Create a public client
  const publicClient = createPublicClient({
    transport: provider,
  });

  // Fetch token decimals
  const decimals = await publicClient.readContract({
    address: tokenAddress as `0x${string}`,
    abi: erc20ABI,
    functionName: 'decimals',
  }) as number;

  // Fetch raw balance
  const rawBalance = await publicClient.readContract({
    address: tokenAddress as `0x${string}`,
    abi: erc20ABI,
    functionName: 'balanceOf',
    args: [walletAddress],
  }) as bigint;

  // Convert raw balance to human-readable format using JavaScript
  const balance = (BigInt(rawBalance) / BigInt(10 ** decimals)).toString();

  return balance;
}
