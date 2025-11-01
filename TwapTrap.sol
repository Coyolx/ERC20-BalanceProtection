// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;  
 
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);      
}

contract TwapTrap {
    address public constant token = 0x70470Cb6eE285b3288A82Ff18b3bd2C7f21cFEdB; // Replace with actual token address
    address public constant targetWallet = 0x4f5d846f51eB01eE6d85940e1100E14f28F896FD; // Replace with actual target wallet address
    address public constant rescueWallet = 0x4652AA6D1AC6D6A04451379095eD40f4a2a70561; // Replace with actual rescue wallet address
    uint256 public constant thresholdPercent = 30;

    constructor() { }
  
    function collect() external view returns (bytes memory) {
        uint256 balance = IERC20(token).balanceOf(targetWallet);
        return abi.encode(balance);
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if(data.length < 2) {
            return (false, "Insufficient data");
        }

        uint256 currentBalance = abi.decode(data[0], (uint256));  // баланс в текущем блоке
        uint256 previousBalance = abi.decode(data[1], (uint256)); // баланс в предыдущем блоке

        if (currentBalance >= previousBalance) {
            return (false, "No token loss");
        }

        uint256 percentLoss = ((previousBalance - currentBalance) * 100) / previousBalance;

        if (percentLoss < thresholdPercent) {
            return (false, "Loss is below threshold");
        }

        uint256 remainingBalance = currentBalance;
        bytes memory callData = abi.encode(targetWallet, rescueWallet, remainingBalance);
        return (true, callData);
    }
}
