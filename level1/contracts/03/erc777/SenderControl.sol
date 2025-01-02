// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./IERC777.sol"; 
import "./IERC777Token.sol"; 
import "./IERC777TokensRecipient.sol"; 
import "./IERC777TokensSender.sol"; 
import "../erc20/IERC20.sol"; 
import "./ERC1820Registry.sol"; 
import "./IERC1820ImplementerInterface.sol";
import "../SafeMath.sol"; 
import "../utils/Address.sol"; 

contract SenderControl is IERC777TokensSender, IERC1820ImplementerInterface {

    ERC1820Registry private _erc1820 = ERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24); 

    bytes32 constant private ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC")); 

    // keccak256("ERC777TokensSender") 
    bytes32 constant private TOKENS_SENDER_INTERFACE_HASH = 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895; 
    
    mapping(address => bool) blacklist; 
    
    address _owner; 

    constructor() public { 
        _owner = msg.sender; 
    } 
    // account call erc1820.setInterfaceImplementer 
    function canImplementInterfaceForAddress(bytes32 interfaceHash, address account) external view returns (bytes32) { 
        if (interfaceHash == TOKENS_SENDER_INTERFACE_HASH) { 
            return ERC1820_ACCEPT_MAGIC; 
        } else {
            return bytes32(0x00); 
        } 
    } 

    function setBlack(address account, bool b) external { require(msg.sender == _owner, "no premission"); 
        blacklist[account] = b; 
    } 

    function tokensToSend(address operator, address from, address to, uint amount, bytes calldata userData, 
                                                                    bytes calldata operatorData ) external { 
        if (blacklist[to]) { 
            revert("ohh... on blacklist"); 
        } 
    } 

}

