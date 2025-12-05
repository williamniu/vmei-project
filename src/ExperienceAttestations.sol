// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ExperienceAttestations {
    uint256 public nextId = 1; [cite_start]// [cite: 8]

    struct Attestation {
        uint256 id;
        address issuer;
        address recipient;
        string metadataURI;
        uint256 timestamp;
        bool revoked;
    }

    mapping(uint256 => Attestation) public attestations; [cite_start]// [cite: 17]
    mapping(address => uint256[]) public attestationsOf;

    event AttestationIssued(uint256 indexed id, address indexed issuer, address indexed recipient); [cite_start]// [cite: 18]
    event AttestationRevoked(uint256 indexed id, address indexed issuer); [cite_start]// [cite: 19]

    function issueAttestation(address recipient, string calldata metadataURI) external returns (uint256) {
        require(recipient != address(0), "Invalid recipient"); [cite_start]// [cite: 21]
        
        uint256 id = nextId++;
        
        attestations[id] = Attestation(
            id, 
            msg.sender, 
            recipient,
            metadataURI, 
            block.timestamp, 
            false
        ); [cite_start]// [cite: 22, 23]

        attestationsOf[recipient].push(id); [cite_start]// [cite: 25]
        
        emit AttestationIssued(id, msg.sender, recipient); [cite_start]// [cite: 26]
        return id;
    }

    function revokeAttestation(uint256 id) external {
        Attestation storage a = attestations[id];
        
        require(a.id != 0, "No attestation"); [cite_start]// [cite: 29]
        require(msg.sender == a.issuer, "Not issuer"); [cite_start]// [cite: 30]
        
        a.revoked = true; [cite_start]// [cite: 31]
        
        emit AttestationRevoked(id, msg.sender); [cite_start]// [cite: 32]
    }

    function getAttestationsOf(address recipient) external view returns (uint256[] memory) {
        return attestationsOf[recipient]; [cite_start]// [cite: 36]
    }

    function getAttestation(uint256 id) external view returns (Attestation memory) {
        return attestations[id]; [cite_start]// [cite: 40]
    }
}