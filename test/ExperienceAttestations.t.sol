// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ExperienceAttestations.sol";

contract ExperienceAttestationsTest is Test {
    ExperienceAttestations public attestationContract;
    
    address public issuer = address(1);
    address public recipient = address(2);

    function setUp() public {
        vm.prank(issuer);
        attestationContract = new ExperienceAttestations();
    }

    function test_IssueAttestation() public {
        vm.prank(issuer);
        string memory uri = "ipfs://test";
        
        uint256 id = attestationContract.issueAttestation(recipient, uri);
        
        assertEq(id, 1);
        
        (uint256 _id, address _issuer, , string memory _uri, , bool _revoked) = attestationContract.getAttestation(id);
        assertEq(_id, 1);
        assertEq(_issuer, issuer);
        assertEq(_uri, uri);
        assertFalse(_revoked);
    }

    function test_RevokeAttestation() public {
        vm.startPrank(issuer);
        uint256 id = attestationContract.issueAttestation(recipient, "ipfs://test");
        
        attestationContract.revokeAttestation(id);
        vm.stopPrank();

        (, , , , , bool revoked) = attestationContract.getAttestation(id);
        assertTrue(revoked);
    }

    function test_RevertIf_NotIssuerRevokes() public {
        vm.prank(issuer);
        uint256 id = attestationContract.issueAttestation(recipient, "ipfs://test");

        vm.prank(recipient); 
        vm.expectRevert("Not issuer"); 
        attestationContract.revokeAttestation(id);
    }
}