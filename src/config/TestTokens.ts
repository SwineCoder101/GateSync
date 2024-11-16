
export interface TestToken {
    symbol: string
    mockAddress: string
    tokenJupAddress: string // used for jupiter pricing
    logoPath: string
    maxFaucetAmount: number
}

export const BONK_ADDRESS = 'kgUd2v7jcxWJ552vz2GF7W3gG2cEkNu43KK7wQRRqhg';

export const BONK_TOKEN : TestToken = {
    symbol: 'BONK',
    mockAddress: 'kgUd2v7jcxWJ552vz2GF7W3gG2cEkNu43KK7wQRRqhg',
    tokenJupAddress: 'DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263',
    logoPath: '/BONK-coin-logo.png',
    maxFaucetAmount: 1_000_000
}

export const SOL_TOKEN : TestToken = {
    symbol: 'SOL',
    mockAddress: '11111111111111111111111111111111',
    tokenJupAddress: '11111111111111111111111111111112',
    logoPath: '/solana-coin-logo.webp',
    maxFaucetAmount: 0.1
}

export const POPCAT_TOKEN : TestToken = {
    symbol: 'POPCAT',
    mockAddress: 'AAAe3NThFeJdepTTbfCvgTXrsbRCmZfhc5GeZpME5VcF',
    tokenJupAddress: '7GCihgDB8fe6KNjn2MYtkzZcRjQy3t9GHdC8uHYmW2hr',
    logoPath: '/popcat-logo.webp',
    maxFaucetAmount: 100
}

export const WIF_TOKEN : TestToken = {
    symbol: 'WIF',
    mockAddress: 'AwQ37ojBhyF9NJQgW2pAS7KSjJKeDHa5fkBBkWW4Q63x',
    tokenJupAddress: 'EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm',
    logoPath: '/WIF-coin-logo.png',
    maxFaucetAmount: 100
}

export const MAX_SOL_FAUCET_AMOUNT = 0.1;


export const TOKEN_LIST : TestToken [] = [
    BONK_TOKEN, POPCAT_TOKEN,WIF_TOKEN
]

export const ALL_TOKEN_LIST : TestToken [] = [SOL_TOKEN,...TOKEN_LIST]


export type TokenMap = { [key: string]: TestToken }

// TODO: Refactor, this should be renamed appropriately we use different map conventions in different places

export const ALL_TOKEN_MAP: TokenMap = ALL_TOKEN_LIST.reduce((acc: { [key: string]: TestToken }, tk) => {
    acc[tk.mockAddress] = tk;
    return acc;
}, {});

export const TOKEN_MAP: TokenMap = TOKEN_LIST.reduce((acc: { [key: string]: TestToken }, tk) => {
    acc[tk.tokenJupAddress] = tk;
    return acc;
}, {});

export const MINT_TOKEN_MAP: TokenMap = TOKEN_LIST.reduce((acc: { [key: string]: TestToken }, tk) => {
    acc[tk.mockAddress] = tk;
    return acc;
}, {});
