// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "../ERC165.sol";

contract IERC721 is IERC165 { 

    // 当任何 NFT 的所有权更改时（不管哪种方式），就会触发此事件
    event Transfer(address indexed from, address indexed to, uint256indexed tokenId); 
    // 当更改或确认 NFT 的授权地址时触发 
    event Approval(address indexed owner, address indexed approved,uint256 indexed tokenId); 
    // 所有者启用或禁用操作员时触发（操作员可管理所有者所持有的NFTs）
    event ApprovalForAll(address indexed owner, address indexedoperator, bool approved); 
    // 统计所持有的 NFTs 数量 
    function balanceOf(address _owner) external view returns (uint256); 
    // 返回所有者 
    function ownerOf(uint256 _tokenId) external view returns (address); 
    // 将 NFT 的所有权从一个地址转移到另一个地址 
    function safeTransferFrom(address _from, address _to, uint256_tokenId, bytes data) external payable; 
    // 将 NFT 的所有权从一个地址转移到另一个地址，功能同上，不带data 参数
    function safeTransferFrom(address _from, address _to, uint256_tokenId) external payable; 
    // 转移所有权——调用者负责确认_to 是否有能力接收 NFTs，否则可能永久丢失
    function transferFrom(address _from, address _to, uint256 _tokenId)external payable; 
    // 更改或确认 NFT 的授权地址 
    function approve(address _approved, uint256 _tokenId) externalpayable; // 启用或禁用第三方（操作员）管理 msg.sender 所有资产
    function setApprovalForAll(address _operator, bool _approved)external; // 获取单个 NFT 的授权地址 
    function getApproved(uint256 _tokenId) external view returns(address); // 查询一个地址是否是另一个地址的授权操作员 
    function isApprovedForAll(address _owner, address _operator)external view returns (bool); 
    
} 

//如果合约（应用）要接受 NFT 的安全转账，则必须实现以下接口。
// 按 ERC-165 标准，接口 id 为 0x150b7a02 
interface ERC721TokenReceiver { 
    // 处理接收 NFT 
    // ERC721 智能合约在 transfer 完成后，在接收者地址上调用这个函数
    /// @return 正确处理时返回 
    bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")) function onERC721Received(address _operator, address _from,uint256 _tokenId, bytes _data) external returns(bytes4); 
} 

//以下元信息（描述代币本身的信息）扩展是可选的，但是可以提供一些资产代表的信息以便查询。 
/// @title ERC-721 非同质化代币标准, 可选元信息扩展 
/// Note: 按 ERC-165 标准，接口 id 为 0x5b5e139f 
interface ERC721Metadata /* is ERC721 */ { 
    // NFTs 集合的名字 
    function name() external view returns (string _name); 

    // NFTs 缩写代号 
    function symbol() external view returns (string _symbol); 

    // 一个给定资产的唯一的统一资源标识符(URI) 
    // 如果_tokenId 无效，抛出异常 
    /// URI 也许指向一个符合“ERC721 元数据 JSON Schema”的JSON 文件
    function tokenURI(uint256 _tokenId) external view returns (string); 
} 