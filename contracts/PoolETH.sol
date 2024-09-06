// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IWhisper {
    function addCommitment(uint _commitment) external;
    function addNullifierHash(uint256 _nullifierHash) external;
}

interface IVerifier {
    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[2] calldata _pubSignals) external view returns (bool);
}

contract PoolETH {
    IWhisper whisper;
    address verifier;
    address public owner;
    uint256 public depositAmount;
    uint256 public fees = 0.0001 ether;

    mapping(address => address) public kycHolders;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only handler can call this function");
        _;
    }

    constructor(uint256 _depositAmount, address _whisper, address _verifier) {
        depositAmount = _depositAmount;
        whisper = IWhisper(_whisper);
        verifier = _verifier;
        owner = msg.sender;
    }

    function safeDeposit(uint _commitment) public payable {
        require(kycHolders[msg.sender] != address(0), "KYC not done");
        uint totalAmount = depositAmount + fees;
        require(msg.value == totalAmount, "Invalid deposit amount");

        whisper.addCommitment(_commitment);
    }

    function Deposit(uint _commitment) public payable {
        uint totalAmount = depositAmount + fees;
        require(msg.value == totalAmount, "Invalid deposit amount");
        lastSender = msg.sender;

        whisper.addCommitment(_commitment);
    }

    function setKYC(address _user, address _KYC) public onlyOwner() {
        kycHolders[_user] = _KYC;
    }

    function setFees(uint256 _fees) public onlyOwner() {
        fees = _fees;
    }

    function withdraw(
        uint[2] calldata _proofA,
        uint[2][2] calldata _proofB,
        uint[2] calldata _proofC,
        uint[1] calldata _publicSignals
    ) public {
        require(address(this).balance >= depositAmount, "Insufficient balance");

        uint _nullifierHash = _publicSignals[0]
        uint _addr = uint256(uint160(msg.sender));

        (bool verifyOk, ) = verifier.call(abi.encodeCall(IVerifier.verifyProof(_pA, _pB, _pC, [_nullifierHash, _addr]);))

        require(verifyOk, "Invalid proof");

        whisper.addNullifierHash(_nullifierHash);

        address payable target = payable(msg.sender);

        (bool ok, ) = target.call{value: depositAmount}("");
        require(ok, "Failed to send funds");
    } 

    function isKYC(address _address) public view returns(bool) {
        return kycHolders[_address] != address(0);
    }
}