import { Connection, PublicKey } from "@solana/web3.js";
import { TOKEN_PROGRAM_ID } from "@solana/spl-token";


export async function checkTokenBalance(walletAddress: string, tokenAddress: string): Promise<number> {
  const connection = new Connection(process.env.NEXT_PUBLIC_SOLANA_RPC_URL || "");
  const walletPublicKey = new PublicKey(walletAddress);

  try {
    const tokenAccounts = await connection.getParsedTokenAccountsByOwner(walletPublicKey, {
      programId: TOKEN_PROGRAM_ID,
    });

    const tokenAccount = tokenAccounts.value.find(
      (account) => account.account.data.parsed.info.mint === tokenAddress
    );

    if (!tokenAccount) return 0;

    const balance = tokenAccount.account.data.parsed.info.tokenAmount.uiAmount;
    return balance;
  } catch (error) {
    console.error("Error checking token balance:", error);
    return 0;
  }
}

export function getChainIcon(chainType: string) {
  switch (chainType?.toLowerCase()) {
    case "solana":
      return (
        <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            fill="currentColor"
            d="M19.125 7.447a.7.7 0 0 1-.456.181H2.644c-.568 0-.856-.65-.462-1.031l2.631-2.538a.67.67 0 0 1 .456-.187h16.087c.575 0 .857.656.457 1.037zm0 12.506a.68.68 0 0 1-.456.175H2.644c-.568 0-.856-.644-.462-1.025l2.631-2.544a.66.66 0 0 1 .456-.18h16.087c.575 0 .857.65.457 1.03zm0-9.65a.68.68 0 0 0-.456-.175H2.644c-.568 0-.856.644-.462 1.025l2.631 2.544a.7.7 0 0 0 .456.181h16.087c.575 0 .857-.65.457-1.031z"
          ></path>
        </svg>
      );
    case "ethereum":
      return (
        <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            fill="currentColor"
            d="M12 2v7.39l6.25 2.795zm0 0L5.75 12.185 12 9.39zm0 14.975V22l6.25-8.65zM12 22v-5.025L5.75 13.35z"
          ></path>
          <path fill="currentColor" d="m12 15.81 6.25-3.625L12 9.39zm-6.25-3.625L12 15.81V9.39z"></path>
        </svg>
      );
    default:
      return null;
  }
}
