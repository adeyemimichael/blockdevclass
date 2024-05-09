// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DigitalWallet {
    address public owner;
    uint256 public maxCapacity;
    mapping(address => uint256) public balances;

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor(uint256 _maxCapacity) {
        owner = msg.sender;
        maxCapacity = _maxCapacity;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        require(balances[msg.sender] + msg.value <= maxCapacity, "Exceeds maximum capacity");
        
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;
        emit Withdrawal(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public {
        require(to != address(0), "Invalid recipient address");
        require(amount > 0, "Transfer amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }
}
