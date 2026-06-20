    # 🛡️ Protecting a Token from Unauthorized Withdrawals 
  **Drosera trap** that automatically monitors the balance of a specific ERC20 token on a wallet
If the balance drops by more than a configured percentage, the trap triggers a transaction to transfer the remaining funds to a backup wallet.
 
This solution is designed to protect DAO treasuries, high-value accounts, or wallets at risk of compromise.

## 🎯 Objectives   

- **Monitor** the balance of a specific ERC20 token (`KrkUSD`) on a target wallet.   
- **Trigger** when the balance decreases by **30% or more**.  
- **Automatically transfer** the remaining tokens to a backup wallet.   
---

## ⚙️ Contracts

### `Token.sol` (KrkUSD)
A test ERC20 token with 6 decimal places.

---

### `TwapTrap.sol`
Main trap logic:

- Compares the current block’s balance to the previous block’s.
- If the loss exceeds the `thresholdPercent`, returns `true` and `calldata` for `transferFrom()`.

---

### `Trap.sol`
An example trap that checks `isActive()` on an external contract and returns a Discord username.

---

## 🧩 TwapTrap.sol Logic
function collect() external view returns (bytes memory);

Collects the current balance.

function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);

Compares the balances of two blocks.
Triggers if the decrease is above the threshold.

## Important:
The targetWallet must approve the trap in advance with a sufficiently high allowance.

----

## ⚡ Deployment and Setup
## 1️⃣ Deploy the Token

forge create src/Token.sol:KrkUSD \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key YOUR_PRIVATE_KEY
  
 Save the token contract address. 

 ## 2️⃣ Update TwapTrap.sol Parameters
Replace the values in the contract:

address public constant token = <TOKEN_ADDRESS>;

address public constant targetWallet = <MAIN_WALLET>;

address public constant rescueWallet = <RESCUE_WALLET>;

uint256 public constant thresholdPercent = 30;

## 3️⃣ Compile
forge build

## 4️⃣ Configure drosera.toml

ethereum_rpc = "https://ethereum-hoodi-rpc.publicnode.com"
drosera_rpc = "https://relay.hoodi.drosera.io"
drosera_address = "0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D"

[traps]

[traps.twaptrap]
path = "out/TwapTrap.sol/TwapTrap.json"
response_contract = "<TOKEN_ADDRESS>"
response_function = "transferFrom(address,address,uint256)"
cooldown_period_blocks = 8
min_number_of_operators = 1
max_number_of_operators = 2
block_sample_size = 2
private_trap = true
whitelist = ["<YOUR_OPERATOR_ADDRESS>"]

## 5️⃣ Deploy the Trap
DROSERA_PRIVATE_KEY=YOUR_PRIVATE_KEY drosera apply

## 6️⃣ Approve the Trap
cast send <TOKEN_ADDRESS> \
  "approve(address,uint256)" <TRAP_ADDRESS> 1000000000000 \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key YOUR_PRIVATE_KEY
## 7️⃣ Verify
#### ✅ Transfer part of the tokens from targetWallet to another address.

#### ✅ Wait 1–3 blocks.

#### ✅ In the Drosera dashboard, check that shouldRespond = true.

#### ✅ Confirm that the remaining funds were transferred to the rescueWallet.

---

## 🧠 Potential Improvements

Make thresholdPercent configurable without redeploying the contract.

Support monitoring multiple tokens.

Add a delay timer before responding.

---

## ✍️ Author

Created: 15 July 2025

Author: Coyolx
