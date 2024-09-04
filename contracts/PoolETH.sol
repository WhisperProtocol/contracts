// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract PoolETH {
    address public handler;
    uint256 public depositAmount;
    uint256 public fees = 0.0001 ether;
    address lastSender;

    modifier onlyHandler() {
        require(msg.sender == handler, "Only handler can call this function");
        _;
    }

    constructor(uint256 _depositAmount, address _handler) {
        depositAmount = _depositAmount;
        handler = _handler;
    }

    function deposit() public payable {
        uint totalAmount = depositAmount + fees;
        require(msg.value == totalAmount, "Invalid deposit amount");
        lastSender = msg.sender;
    }

    function returnFunds() public onlyHandler() payable{
        address payable receiver = payable(lastSender);
        (bool ok, ) = receiver.call{value: depositAmount}("");
        require(ok, "Failed to send funds");
    }

    function setFees(uint256 _fees) public onlyHandler() {
        fees = _fees;
    }

    function withdraw(address payable recipient) public onlyHandler() {
        require(address(this).balance >= depositAmount, "Insufficient balance");
        (bool ok, ) = recipient.call{value: depositAmount}("");
        require(ok, "Failed to send funds");
    } 
}