use anchor_lang::prelude::*;
use anchor_spl::token::{Token, TokenAccount};

declare_id!("6z68wfurCMYkZG51s1Et9BJEd9nJGUusjHXNt4dGbNNF");
#[program]
pub mod token_balance_reader {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Program initialized!");
        Ok(())
    }

    pub fn get_token_balance(ctx: Context<GetTokenBalance>) -> Result<u64> {
        let token_account = &ctx.accounts.token_account;
        msg!("Token balance: {}", token_account.amount);
        Ok(token_account.amount)
    }
}

#[derive(Accounts)]
pub struct Initialize {}

#[derive(Accounts)]
pub struct GetTokenBalance<'info> {
    #[account(mut)]
    pub token_account: Account<'info, TokenAccount>,
    pub token_program: Program<'info, Token>,
}