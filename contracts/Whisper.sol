// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./MiMC5.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Whisper is ReentrancyGuard {
    address owner;
    MiMC5 mimc5;

    mapping(address => bool) public isAllowedCaller;

    // Tree Levels determine the total number of transactions that can occur in one tree, right now it's 2**10
    uint8 treeLevel = 10;
    uint public nextLeafIndex;

    mapping(uint8 => uint) lastLevelHash;
    mapping(uint256 => bool) nullifierHashes;
    mapping(uint256 => bool) commitments;

    uint[10] levelDefaults = [
        98802119202599077311661355950044988197066472055575054888808493105602281489066,
        93294173872719768839486926484525195947077317750382505979482973263894027827086,
        57899121086108745255039950688167215371190983573326283303607125387186936743919,
        26854886670190432450536069173227146791348120334835719352271904524374204509846,
        49446997658527013131796851452169581531930943346241380439069105017743285039834,
        63897050663180235712578121949722268139049041502760198751535245836960126619214,
        95043049235717339820383357477122374021356972989629034453260786882841976358252,
        49782660706683877062144683782482486985345725483475823839612051713263974442177,
        57166143961280651254069398797975577484346757164395689170289411957983602324397,
        114674852194379494398515637970597404256523001465300473113208742226500347475356
    ];

    event Deposit(uint256 root, uint[10] hashPairings, uint8[10] hashDirections);

    modifier onlyAllowedCaller() {
        require(isAllowedCaller[msg.sender], "Caller not allowed");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(address _mimc5) {
        mimc5 = MiMC5(_mimc5);
        owner = msg.sender;
    }

    function addCommitment(uint _commitment ) onlyAllowedCaller() external nonReentrant() {
        require(!commitments[_commitment], "Commitment already exists");
        require(nextLeafIndex < 2**treeLevel, "Tree is full");

        uint newRoot;
        uint[10] memory hashPairings;
        uint8[10] memory hashDirections;

        uint currentIndex = nextLeafIndex;
        uint currentHash = _commitment;

        uint left;
        uint right;
        uint[2] memory ins;

        for (uint8 i; i < treeLevel; i++) {
            if(currentIndex % 2 == 0){
                left = currentHash;
                right = levelDefaults[i];
                hashPairings[i] = levelDefaults[i];
                hashDirections[i] = 0;
            }else{
                left = lastLevelHash[i];
                right = currentHash;
                hashPairings[i] = lastLevelHash[i];
                hashDirections[i] = 1;
            }
            lastLevelHash[i] = currentHash;

            ins[0] = left;
            ins[1] = right;

            (uint256 h) = mimc5.MiMC5Sponge{ gas: 150000 }(ins, _commitment);

            currentHash = h;
            currentIndex = currentIndex / 2;
        }

        newRoot = currentHash;
        nextLeafIndex += 1;

        commitments[_commitment] = true;

        emit Deposit(newRoot, hashPairings, hashDirections);
    }

    function addNullifierHash(
        uint256 _nullifierHash
    ) onlyAllowedCaller() external nonReentrant() {
        require(!nullifierHashes[_nullifierHash], "Nullifier hash already exists");

        nullifierHashes[_nullifierHash] = true;
    }

    function allowCaller(address _caller) onlyOwner() external {
        isAllowedCaller[_caller] = true;
    }
}