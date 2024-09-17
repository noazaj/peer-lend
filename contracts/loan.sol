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
        string  description;
        address requestAddress;
    }

    struct LenderRequest {
        uint256 requestInterest;
        string  reply;
        uint256 loanDuration;
        address acceptingAddress;
    }

    BorrowerRequest[] public listOfBorrowRequests; 
    LenderRequest[] public listOfLenderRequests;

    function borrowerLoanRequest(uint256 _loanAmount, string memory _description) public validLoanAmount(_loanAmount) {
        listOfBorrowRequests.push(BorrowerRequest(_loanAmount, _description, msg.sender));
    }

    function lenderLoanRequest(uint256 _interestRate, string memory _reply, uint256 _loanDuration) public validInterestRate(_interestRate) validLoanDuration(_loanDuration) {
        bytes memory b = bytes(_reply);
        if (b.length == 0) {
            _reply = "";
        }
        listOfLenderRequests.push(LenderRequest(_interestRate, _reply, _loanDuration, msg.sender));
    }

    modifier validLoanAmount(uint256 _loanAmount) {
        require(_loanAmount > 0, "Need to send amount greater than 0.");
        _;
    }

    modifier validInterestRate(uint256 _interestRate) {
        require(_interestRate > 0, "Need to send rate greater than 0.");
        _;
    }

    modifier validLoanDuration(uint256 _loanDuration) {
        require(_loanDuration > 0, "Loan needs to be longer than 0 months.");
        _;
    }
}