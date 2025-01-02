// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./ERC20Detailed.sol";
import "./ERC20.sol";

contract MyToken is ERC20 , ERC20Detailed("Wrapped Ether", "WETH",18) { 
    event Deposit(address indexed dst, uint wad); 
    event Withdrawal(address indexed src, uint wad); 
    constructor() public { 

    } 
    function totalSupply() public view override  returns (uint) { 
        return address(this).balance; 
    } 
    receive() external  payable { 
        deposit(); 
    } 
    function deposit() public payable { 
        _mint(msg.sender, msg.value); 
        emit Deposit(msg.sender, msg.value); 
    } 
    function withdraw(uint wad) public { 
        _burn(msg.sender, wad); 
        msg.sender.transfer(wad); 
        emit Withdrawal(msg.sender, wad); 
    } 
}