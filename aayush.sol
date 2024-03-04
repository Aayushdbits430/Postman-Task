// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Aayushzbank {

    struct Person {
        uint256 id;
        string name;
        uint256 age;
    }

    mapping(address => uint256) public balances;
    mapping(address => uint256) public borrowedAmount;
     mapping(uint256 => Person) public people;
    uint256 public totalDeposits;
    uint256 public totalBorrowed;
    uint256 public peopleCount;

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);
    event Borrow(address indexed account, uint256 amount);
    event Repay(address indexed account, uint256 amount);
    event PersonAdded(uint256 indexed id, string name, uint256 age);

    function addPerson(string memory _name, uint256 _age) public {
        peopleCount++;
        people[peopleCount] = Person(peopleCount, _name, _age);
        emit PersonAdded(peopleCount, _name, _age);
    }

    
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
         balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
       

   
    function withdraw(uint256 amount) external payable {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        totalDeposits -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
       
    }

       function borrow(uint256 amount) external payable {
        require(amount > 0, "Borrow amount must be greater than 0");
        require(amount <= totalDeposits - totalBorrowed, "Insufficient funds available for borrowing");
        borrowedAmount[msg.sender] += amount;
        totalBorrowed += amount;
        payable(msg.sender).transfer(amount);
         emit Borrow(msg.sender, amount);
    }
        
        
        function repay(uint256 amount) external payable {
        require(amount > 0, "Repay amount must be greater than 0");
        require(amount <= borrowedAmount[msg.sender], "Cannot repay more than borrowed");
        borrowedAmount[msg.sender] -= amount;
        totalBorrowed -= amount;
        emit Repay(msg.sender, amount);
    }
    
     function checkBalance(address account) external view returns (uint256) {
        return balances[account];
    }
}
   
     