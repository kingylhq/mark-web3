// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./IERC721.sol"; 
import "./IERC721TokenReceiver.sol"; 
import "../SafeMath.sol"; 
import "../utils/Address.sol"; 
import "../utils/Counters.sol"; 
import "../IERC165.sol";

// IERC721 实现了 IERC165
contract ERC721 is IERC721 { 

    using SafeMath for uint256; 
    using Address for address; 
    using Counters for Counters.Counter; 
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02; 
    // 记录 id 及所有者 
    mapping (uint256 => address) private _tokenOwner; 
    // 记录 id 及对应的授权地址 
    mapping (uint256 => address) private _tokenApprovals; 
    // 某个地址拥有的 token 数量 
    mapping (address => Counters.Counter) private _ownedTokensCount;
    // 所有者的授权操作员列表 
    mapping (address => mapping (address => bool)) private _operatorApprovals; 
    mapping(bytes4 => bool) private _supportedInterfaces;
    // 实现的接口 
    /* 
    * bytes4(keccak256('balanceOf(address)')) == 0x70a08231
    * bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e 
    * bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3 
    * bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
    * bytes4(keccak256('setApprovalForAll(address,bool)'))==0xa22cb465 
    * bytes4(keccak256('isApprovedForAll(address,address)'))==0xe985e9c 
    * bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd 
    * bytes4(keccak256('safeTransferFrom(address,address,uint256)'))==0x42842e0e 
    * bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde 
    * 
    * => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc^* 0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^0xb88d4fde == 0x80ac58cd 
    */ 
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    // 构造函数 
    constructor () public { 
        // 注册支持的接口 
        super._registerInterface(_INTERFACE_ID_ERC721); 
    } 

    // 注册接口
    // function _registerInterface(bytes4 interfaceId) internal {
    //     require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
    //     require(!_supportedInterfaces(interfaceId), "Registering already registered interface id");
    //     _supportedInterfaces[interfaceId] = true;
    // }

    // // 实现 ERC-165
    // function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
    //     return _supportedInterfaces[interfaceId];
    // }
    
    // 返回持有数量 
    function balanceOf(address owner) public view returns (uint256) { 
        require(owner != address(0), "ERC721: balance query forthezero address"); 
        return _ownedTokensCount[owner].current(); 
    } 

    // 返回持有者 
    function ownerOf(uint256 tokenId) public view returns (address){ address owner = _tokenOwner[tokenId]; 
        require(owner != address(0), "ERC721: owner query for nonexistent token"); 
        return owner; 
    } 

    // 授权另一个地址可以转移对应的 token, 授权给零地址表示token 不授权给其他地址 
    function approve(address to, uint256 tokenId) public { 
        address owner = ownerOf(tokenId); 
        require(to != owner, "ERC721: approval to current owner");
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721: approve caller is not owner nor approved for all"); _tokenApprovals[tokenId] = to; 
        emit Approval(owner, to, tokenId); 
    } 

    // 获取单个 NFT 的授权地址 
    function getApproved(uint256 tokenId) public view returns (address){ require(_exists(tokenId), "ERC721: approved query for nonexistent token"); 
        return _tokenApprovals[tokenId]; 
    } 

    // 启用或禁用操作员管理 msg.sender 所有资产 
    function setApprovalForAll(address to, bool approved)public{
        require(to != msg.sender, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][to] = approved; 
        emit ApprovalForAll(msg.sender, to, approved); 
    } 
    // 查询一个地址 operator 是否是 owner 的授权操作员 
    function isApprovedForAll(address owner, address operator) public view returns (bool) { 
        return _operatorApprovals[owner][operator]; 
    } 
    
    // 转移所有权 
    function transferFrom(address from, address to, uint256 tokenId)public { 
        //solhint-disable-next-line max-line-length 
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721:transfer caller is not owner nor approved");
        _transferFrom(from, to, tokenId); 
    } 

    // 安全转移所有权，如果接受的是合约，必须有 onERC721Received 实现
    function safeTransferFrom(address from, address to, uint256 tokenId) public { 
        safeTransferFrom(from, to, tokenId, ""); 
    } 

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public { 
        transferFrom(from, to, tokenId); 
        require(_checkOnERC721Received(from, to, tokenId, _data),"ERC721: transfer to non ERC721Receiver implementer"); 
    } 
    // token 是否存在 
    function _exists(uint256 tokenId) internal view returns (bool){
        address owner = _tokenOwner[tokenId]; 
        return owner != address(0); 
    } 

    // 检查 spender 是否经过授权 
    function _isApprovedOrOwner(address spender, uint256 tokenId)internal view returns (bool) { 
        require(_exists(tokenId), "ERC721: operator query for nonexistent token"); 
        address owner = ownerOf(tokenId); 
        return (spender == owner || getApproved(tokenId) == spender||isApprovedForAll(owner, spender)); 
    } 

    // 挖出一个新的币 
    function _mint(address to, uint256 tokenId) internal { 
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment(); 
        emit Transfer(address(0), to, tokenId); 
    } 

    // 销毁 
    function _burn(address owner, uint256 tokenId) internal { require(ownerOf(tokenId) == owner, "ERC721: burn of tokenthatis not own"); 
        _clearApproval(tokenId); 
        _ownedTokensCount[owner].decrement(); 
        _tokenOwner[tokenId] = address(0); 
        emit Transfer(owner, address(0), tokenId); 
    } 

    function _burn(uint256 tokenId) internal { 
        _burn(ownerOf(tokenId), tokenId); 
    } 

    // 实际实现转移所有权的方法 
    function _transferFrom(address from, address to, uint256 tokenId)internal { 
        require(ownerOf(tokenId) == from, "ERC721: transfer of tokenthat is not own"); 
        require(to != address(0), "ERC721: transfer to the zeroaddress"); _clearApproval(tokenId); 
        _ownedTokensCount[from].decrement(); _ownedTokensCount[to].increment(); 
        _tokenOwner[tokenId] = to; 
        emit Transfer(from, to, tokenId); 
    } 

    // 检查合约账号接收 token 时，是否实现了 onERC721Received 
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool) { 
        if (!to.isContract()) { 
            return true; 
        } 
        bytes4 retval = ERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId,_data); 
        return (retval == _ERC721_RECEIVED); 
    } 
    
    // 清除授权 
    function _clearApproval(uint256 tokenId) private { 
        if (_tokenApprovals[tokenId] != address(0)) { 
            _tokenApprovals[tokenId] = address(0); 
        } 
    } 
}