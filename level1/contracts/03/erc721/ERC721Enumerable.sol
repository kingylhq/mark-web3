// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// import "./IERC721Enumerable.sol"; 
import "./ERC721.sol"; 
import "./IERC721Enumerable.sol"; 
import "../ERC165Registry.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {

    // 所有者拥有的 token ID 列表 
    mapping(address => uint256[]) private _ownedTokens; 
    
    // token ID 对应的索引号（在拥有者下） 
    mapping(uint256 => uint256) private _ownedTokensIndex; 

    // 所有的 token ID 
    uint256[] private _allTokens; 

    // token ID 在所有 token 中的索引号 
    mapping(uint256 => uint256) private _allTokensIndex; 
    /* 
    * bytes4(keccak256('totalSupply()')) == 0x18160ddd 
    * bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)'))== 0x2f745c59 
    * bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
    * 
    * => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
    */ 
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63; 

    ERC165Registry private _registry;

    // 合约构造函数需要一个 ERC165Registry 类型的参数，需要先部署 ERC165Registry 合约，
    // 然后将其部署后的合约地址作为参数传递给目标合约的构造函数。
    constructor (ERC165Registry registry) public { 
        // register the supported interface to conform to ERC721Enumerable via ERC165 
        _registry = registry;
        _registry.registry(_INTERFACE_ID_ERC721_ENUMERABLE); 
    }


    function searchBalances() public view returns (uint) {
        return address(this).balance;
    }

    /** * @dev 用持有者索引获取到 token id */ 
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) { 
        require(index < balanceOf(owner), "ERC721Enumerable: ownerindex out of bounds"); 
        return _ownedTokens[owner][index]; 
    } 

    // 合约一共管理了多少 token 
    function totalSupply() public view returns (uint256) { 
        return _allTokens.length; 
    } 

    /** * @dev 用索引获取到 token id */ 
    function tokenByIndex(uint256 index) public view returns (uint256){ 
        require(index < totalSupply(), "ERC721Enumerable: global indexout of bounds"); 
        return _allTokens[index]; 
    } 

    function _transferFrom(address from, address to, uint256 tokenId)internal { 
        super._transferFrom(from, to, tokenId); 
        _removeTokenFromOwnerEnumeration(from, tokenId); 
        _addTokenToOwnerEnumeration(to, tokenId); 
    } 

    function _mint(address to, uint256 tokenId) internal { super._mint(to, tokenId); 
        _addTokenToOwnerEnumeration(to, tokenId); 
        _addTokenToAllTokensEnumeration(tokenId);
    } 

    function _burn(address owner, uint256 tokenId) internal { super._burn(owner, tokenId); 
        _removeTokenFromOwnerEnumeration(owner, tokenId); 
        // Since tokenId will be deleted, we can clear its slotin_ownedTokensIndex to trigger a gas refund 
        _ownedTokensIndex[tokenId] = 0; 
        _removeTokenFromAllTokensEnumeration(tokenId);
    } 

    function _tokensOfOwner(address owner) internal view returns(uint256[] storage) { 
        return _ownedTokens[owner]; 
    } 

    /** 
    * @dev 填加 token id 到对应的所有者下进行索引 
    */ 
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId)private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length; 
        _ownedTokens[to].push(tokenId); 
    } 

    // 填加 token id 到 token 列表内进行索引 
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private { 
        _allTokensIndex[tokenId] = _allTokens.length; 
        _allTokens.push(tokenId); 
    } 

    // 移除相应的索引 
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private { 
        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId]; 
        if (tokenIndex != lastTokenIndex) { 
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
            _ownedTokens[from][tokenIndex] = lastTokenId; 
            // Movethelast token to the slot of the to-delete token 
            _ownedTokensIndex[lastTokenId] = tokenIndex; 
            // Updatethemoved token's index 
        }
        _ownedTokens[from].length--; 
    }

    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private { 
        uint256 lastTokenIndex = _allTokens.length.sub(1); 
        uint256 tokenIndex = _allTokensIndex[tokenId]; 
        uint256 lastTokenId = _allTokens[lastTokenIndex]; _allTokens[tokenIndex] = lastTokenId; // Move the last tokento the slot of the to-delete token 
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the movedtoken's index 
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0; 
    } 
}