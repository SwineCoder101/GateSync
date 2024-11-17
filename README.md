# GateSync

## Getting Started

### Prerequisites

- Node v18.18.0 or higher

- Rust v1.77.2 or higher
- Anchor CLI 0.30.1 or higher
- Solana CLI 1.18.17 or higher
- Forge CLI
- Hyperlane CLI

### Installation

#### Clone the repo

```shell
git clone <repo-url>
cd <repo-name>
```

#### Install Dependencies

```shell
pnpm install
```

#### Start the web app

```
pnpm dev
```

## Apps

### anchor

This is a Solana program written in Rust using the Anchor framework.

#### Commands

You can use any normal anchor commands. Either move to the `anchor` directory and run the `anchor` command or prefix the command with `pnpm`, eg: `pnpm anchor`.

#### Sync the program id:

Running this command will create a new keypair in the `anchor/target/deploy` directory and save the address to the Anchor config file and update the `declare_id!` macro in the `./src/lib.rs` file of the program.

You will manually need to update the constant in `anchor/lib/basic-exports.ts` to match the new program id.

```shell
pnpm anchor keys sync
```

#### Build the program:

```shell
pnpm anchor-build
```

#### Start the test validator with the program deployed:

```shell
pnpm anchor-localnet
```

#### Run the tests

```shell
pnpm anchor-test
```

#### Deploy to Devnet

```shell
pnpm anchor deploy --provider.cluster devnet
```

### web

This is a React app that uses the Anchor generated client to interact with the Solana program.

#### Commands

Start the web app

```shell
pnpm dev
```

Build the web app

```shell
pnpm build
```
GateSync

🚀 Overview
GateSync is a cutting-edge cross-chain synchronization platform designed to seamlessly connect Ethereum (EVM) and Solana ecosystems. By leveraging advanced technologies such as Hyperlane for cross-chain messaging, Neon EVM for EVM compatibility on Solana, and robust security mechanisms from sponsors like Privy and Blockscout, GateSync ensures secure and efficient token gating and wallet linking across multiple blockchain networks.

Whether you're looking to bridge assets, synchronize wallet states, or implement sophisticated token gating mechanisms, GateSync provides the tools and infrastructure necessary to achieve your decentralized application (dApp) goals with ease and reliability.

🎉 Sponsors
GateSync is proudly supported by leading organizations in the blockchain space:

Privy
Hyperlane
Neon EVM
Blockscout
Circle
Polygon
Scroll
Their unwavering support and contributions have been instrumental in bringing GateSync to life.

📂 Directory Structure
lua
Copy code
GateSync/
├── LICENSE
├── README.md
├── anchor/
├── foundry/
├── hyperlane/
├── next-env.d.ts
├── next.config.mjs
├── node_modules/
├── package-lock.json
├── package.json
├── postcss.config.mjs
├── public/
├── src/
├── tailwind.config.ts
└── tsconfig.json
🔧 Getting Started
Follow these instructions to set up the development environment, build the project, and run tests.

📋 Prerequisites
Ensure you have the following installed on your machine:

Node.js (v14 or higher)
npm or yarn
Solidity and Foundry for smart contract development
Anchor for Solana smart contracts
Git for version control
🛠️ Installation
Clone the Repository

bash
Copy code
git clone https://github.com/your-username/GateSync.git
cd GateSync
Install Dependencies

Using npm:

bash
Copy code
npm install
Or using yarn:

bash
Copy code
yarn install
Configure Environment Variables

Create a .env file in the root directory and add the necessary environment variables. Refer to .env.example for guidance.

bash
Copy code
cp .env.example .env
Edit .env with your preferred editor:

bash
Copy code
nano .env
🧪 Development Tools
Next.js: For building the frontend application.
Tailwind CSS: For styling and responsive design.
Foundry: For Solidity smart contract testing.
Anchor: For Solana smart contract development.
Hyperlane: For cross-chain messaging and interoperability.
🛠️ Development
🚀 Running the Development Server
Start the Next.js development server:

bash
Copy code
npm run dev
Or with yarn:

bash
Copy code
yarn dev
Open http://localhost:3000 in your browser to view the application.

💻 Smart Contract Development
📝 Anchor (Solana)
Navigate to the anchor/ directory to work on Solana smart contracts.

Build Anchor Contracts

bash
Copy code
cd anchor
anchor build
Deploy Anchor Contracts

bash
Copy code
anchor deploy
🔨 Foundry (Ethereum)
Navigate to the foundry/ directory to work on Ethereum smart contracts.

Install Foundry

If you haven't installed Foundry yet, follow the Foundry installation guide.

Build Foundry Contracts

bash
Copy code
cd foundry
forge build
Run Tests

bash
Copy code
forge test
🖌️ Styling with Tailwind CSS
Tailwind CSS is used for rapid UI development.

Start Tailwind in Development Mode

bash
Copy code
npm run tailwind:dev
Or with yarn:

bash
Copy code
yarn tailwind:dev
Build for Production

bash
Copy code
npm run build:css
Or with yarn:

bash
Copy code
yarn build:css
🛰️ Hyperlane Integration
Hyperlane facilitates cross-chain messaging between Ethereum and Solana.

Configure Hyperlane

Navigate to the hyperlane/ directory and follow the Hyperlane documentation to set up cross-chain communication.

Deploy Hyperlane Contracts

bash
Copy code
cd hyperlane
hyperlane deploy
🔍 Testing
🧪 Running Tests with Foundry
Ensure you're in the foundry/ directory.

bash
Copy code
cd foundry
forge test
🧪 Running Tests with Anchor
Ensure you're in the anchor/ directory.

bash
Copy code
cd anchor
anchor test
🧪 Frontend Testing
Run frontend tests using Jest or your preferred testing framework.

bash
Copy code
npm run test
Or with yarn:

bash
Copy code
yarn test
🤝 Contributing
We welcome contributions from the community! To contribute to GateSync, please follow these guidelines:

📜 Guidelines
Fork the Repository

Click on the "Fork" button at the top-right corner of the repository to create your own fork.

Clone Your Fork

bash
Copy code
git clone https://github.com/your-username/GateSync.git
cd GateSync
Create a New Branch

bash
Copy code
git checkout -b feature/your-feature-name
Make Changes

Implement your feature or bug fix. Ensure your code adheres to the project's coding standards and guidelines.

Commit Your Changes

bash
Copy code
git commit -m "Add feature XYZ"
Push to Your Fork

bash
Copy code
git push origin feature/your-feature-name
Open a Pull Request

Navigate to the original repository and click on "Compare & pull request". Provide a clear description of your changes and submit the PR.

📝 Code of Conduct
By contributing, you agree to abide by our Code of Conduct, fostering a respectful and inclusive environment for all contributors.

📦 Building for Production
🏗️ Building the Frontend
Compile the Next.js application for production:

bash
Copy code
npm run build
Or with yarn:

bash
Copy code
yarn build
🏗️ Deploying Smart Contracts
Deploy Ethereum Contracts with Foundry

bash
Copy code
cd foundry
forge deploy
Deploy Solana Contracts with Anchor

bash
Copy code
cd anchor
anchor deploy
📤 Deployment
Deploy the application to your preferred hosting service (e.g., Vercel, Netlify).

bash
Copy code
npm run deploy
Or with yarn:

bash
Copy code
yarn deploy
Ensure you have configured your deployment settings according to the hosting provider's guidelines.

🧑‍💻 Usage
Once deployed, users can interact with GateSync to:

Link EVM and Solana Wallets: Facilitate seamless cross-chain interactions.
Token Gating: Restrict access to certain features or content based on token ownership.
Cross-Chain Asset Management: Transfer and manage assets between Ethereum and Solana.
📚 API Documentation
Detailed API documentation is available here.

📄 License
This project is licensed under the MIT License.

📞 Contact
For any inquiries or support, please contact support@gatesync.com.