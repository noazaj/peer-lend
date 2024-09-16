// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Loan {
    struct LoanDetails {
        uint256 amount;
        uint256 interestRate;
        uint256 lenderRating;
        address lenderAddress;
        uint256 borrowerRating;
        address borrowerAddress;
        uint256 loanDuration;
    }

    struct BorrowerRequest {
        uint256 requestAmount;
        string description;
        address requestAddress;
    }

    BorrowerRequest[] public listOfRequests; 

    function borrowerLoanRequest(uint256 _loanAmount, string memory _description) public {
        listOfRequests.push(BorrowerRequest(_loanAmount, _description, msg.sender));
    }

}