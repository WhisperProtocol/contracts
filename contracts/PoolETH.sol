// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract PoolETH {
    address public owner;
    uint256 public depositAmount;
    uint256 public fees = 0.0001 ether;
    address lastSender;

    mapping(address => address) public kycHolders;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only handler can call this function");
        _;
    }

    constructor(uint256 _depositAmount) {
        depositAmount = _depositAmount;
    }

    function safeDeposit() public payable {
        require(kycHolders[msg.sender] != address(0), "KYC not done");
        uint totalAmount = depositAmount + fees;
        require(msg.value == totalAmount, "Invalid deposit amount");
        lastSender = msg.sender;
    }

    function Deposit() public payable {
        uint totalAmount = depositAmount + fees;
        require(msg.value == totalAmount, "Invalid deposit amount");
        lastSender = msg.sender;
    }

    function setKYC(address _user, address _KYC) public onlyOwner() {
        kycHolders[_user] = _KYC;
    }

    function returnFunds() public onlyOwner() payable{
        address payable receiver = payable(lastSender);
        (bool ok, ) = receiver.call{value: depositAmount}("");
        require(ok, "Failed to send funds");
    }

    function setFees(uint256 _fees) public onlyOwner() {
        fees = _fees;
    }

    function withdraw(address payable recipient) public onlyOwner() {
        require(address(this).balance >= depositAmount, "Insufficient balance");
        (bool ok, ) = recipient.call{value: depositAmount}("");
        require(ok, "Failed to send funds");
    } 

    function isKYC(address _address) public view returns(bool) {
        return kycHolders[_address] != address(0);
    }
}