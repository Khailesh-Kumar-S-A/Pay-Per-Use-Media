// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayPerUseMedia {

    address public owner;
    mapping(address => uint) public payments;
    mapping(address => bool) public hasAccess;

    event PaymentReceived(address payer, uint amount);
    event ContentAccessGranted(address user, string content);

    constructor() {
        owner = msg.sender;
    }

    // Function to receive payments for media access
    function payForContent(string memory contentId) public payable {
        require(msg.value > 0, "Payment must be greater than 0");
        
        payments[msg.sender] += msg.value;
        hasAccess[msg.sender] = true;

        emit PaymentReceived(msg.sender, msg.value);
        emit ContentAccessGranted(msg.sender, contentId);
    }

    // Function to check if the user has paid and can access the content
    function hasPaid(address user) public view returns (bool) {
        return hasAccess[user];
    }

    // Function to withdraw the funds to the owner
    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        payable(owner).transfer(address(this).balance);
    }

    // Function to check the contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
