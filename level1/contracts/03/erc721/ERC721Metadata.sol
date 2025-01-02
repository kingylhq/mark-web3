// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "./ERC721.sol"; 
import "./IERC721Metadata.sol"; 
import "../ERC165Registry.sol";

contract ERC721Metadata is IERC721, IERC721Metadata { 

    // Token 名字 
    string private _name; 
    // Token 代号 
    string private _symbol; 
    // Optional mapping for token URIs 
    mapping(uint256 => string) private _tokenURIs; 
    /* 
    * bytes4(keccak256('name()')) == 0x06fdde03 
    * bytes4(keccak256('symbol()')) == 0x95d89b41 
    * bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd* 
    * => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
    */ 
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f; 

    mapping(uint256 => address) private _owners;

    ERC165Registry private _registry;

    constructor (string memory name, string memory symbol, ERC165Registry registry) public{
        _name = name; 
        _symbol = symbol;
        _registry = registry;
        _registry.registry(_INTERFACE_ID_ERC721_METADATA); 
    } 

    function name() external view returns (string memory) { 
        return _name; 
    } 

    function symbol() external view returns (string memory) { 
        return _symbol; 
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    // 返回 token 资源 URI 
    function tokenURI(uint256 tokenId) external view returns (string memory) { 
        require(_exists(tokenId), "ERC721Metadata: URI query fornonexistent token"); 
        return _tokenURIs[tokenId]; 
    } 

    function _setTokenURI(uint256 tokenId, string memory uri) internal{ 
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token"); 
        _tokenURIs[tokenId] = uri; 
    } 

    function _burn(address owner, uint256 tokenId) internal { super._burn(owner, tokenId); 
        // Clear metadata (if any) 
        if (bytes(_tokenURIs[tokenId]).length != 0) { 
            delete _tokenURIs[tokenId]; 
        } 
    } 

 }