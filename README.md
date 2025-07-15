# 🛡️ Protecting a Token from Unauthorized Withdrawals

A **Drosera trap** that automatically monitors the balance of a specific ERC20 token on a wallet.  
If the balance drops by more than a configured percentage, the trap triggers a transaction to transfer the remaining funds to a backup wallet.

This solution is designed to protect DAO treasuries, high-value accounts, or wallets at risk of compromise.

---

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
№№Important:
The targetWallet must approve the trap in advance with a sufficiently high allowance.

----

№№⚡ Deployment and Setup
№№№1️⃣ Deploy the Token
