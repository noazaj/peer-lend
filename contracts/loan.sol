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
        bool    exists;
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

    BorrowerRequest[]   public listOfBorrowRequests; 
    LenderRequest[]     public listOfLenderRequests;

    mapping(uint256 => LoanDetails) public loanAgreements;

    function borrowerLoanRequest(uint256 _loanAmount, string memory _description) public validLoanAmount(_loanAmount) {
        listOfBorrowRequests.push(BorrowerRequest(_loanAmount, _description, msg.sender));
    }

    function lenderLoanRequest(uint256 _interestRate, string memory _reply, uint256 _loanDuration, uint256 _requestIndex) public validInterestRate(_interestRate) validLoanDuration(_loanDuration) {
        bytes memory b = bytes(_reply);
        if (b.length == 0) {
            _reply = "";
        }

        require(_requestIndex < listOfBorrowRequests.length, "Index not within borrower array.");

        // Add lender's proposal
        LenderRequest memory lenderRequest = LenderRequest(_interestRate, _reply, _loanDuration, msg.sender);
        listOfLenderRequests.push(lenderRequest);

        // Fetch borrow request
        BorrowerRequest memory borrowerRequest = listOfBorrowRequests[_requestIndex];

        // Check if requestIndex is already a loanAgreement
        require(!loanAgreements[_requestIndex].exists, "A loan already exists with specified index.");

        // Map both to LoanDetails
        mapLoanDetails(_requestIndex, borrowerRequest, lenderRequest);
    }

    function mapLoanDetails(uint256 _requestIndex, BorrowerRequest memory _borrowRequest, LenderRequest memory _lenderRequest) internal {
        loanAgreements[_requestIndex] = LoanDetails({
            amount:             _borrowRequest.requestAmount,
            interestRate:       _lenderRequest.requestInterest,
            lenderRating:       0,
            lenderAddress:      _lenderRequest.acceptingAddress,
            borrowerRating:     0,
            borrowerAddress:    _borrowRequest.requestAddress,
            loanDuration:       _lenderRequest.loanDuration,
            exists:             true
        });
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