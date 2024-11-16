import { NextResponse } from 'next/server';
import { PrivyClient } from '@privy-io/server-auth';

export async function GET() {
  try {
    const privy = new PrivyClient(
      process.env.NEXT_PUBLIC_PRIVY_APP_ID!,
      process.env.PRIVY_APP_SECRET!
    );

    const users = await privy.getUsers();
    console.log("🚀 ~ GET ~ users:", users);

    return NextResponse.json(
      { 
        success: true, 
        data: users 
      },
      { 
        status: 200 
      }
    );

  } catch (error) {
    console.error('Privy API Error:', error);
    
    return NextResponse.json(
      { 
        success: false, 
        error: 'Failed to fetch users' 
      },
      { 
        status: 500 
      }
    );
  }
}
