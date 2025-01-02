// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "../IERC165.sol";

abstract contract IERC721 is IERC165 { 

    // 当任何 NFT 的所有权更改时（不管哪种方式），就会触发此事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 
    // 当更改或确认 NFT 的授权地址时触发 
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 
    // 所有者启用或禁用操作员时触发（操作员可管理所有者所持有的NFTs）
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
    
    // 统计所持有的 NFTs 数量 
    function balanceOf(address _owner) external view virtual returns (uint256); 
    // 返回所有者 
    function ownerOf(uint256 _tokenId) external view virtual returns (address);
    // 将 NFT 的所有权从一个地址转移到另一个地址 
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external virtual  payable; 
    // 将 NFT 的所有权从一个地址转移到另一个地址，功能同上，不带data 参数
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external virtual  payable; 
    // 转移所有权——调用者负责确认_to 是否有能力接收 NFTs，否则可能永久丢失
    function transferFrom(address _from, address _to, uint256 _tokenId) external virtual payable; 
    // 更改或确认 NFT 的授权地址 
    function approve(address _approved, uint256 _tokenId) external virtual payable; // 启用或禁用第三方（操作员）管理 msg.sender 所有资产
    function setApprovalForAll(address _operator, bool _approved) external virtual ; // 获取单个 NFT 的授权地址 
    function getApproved(uint256 _tokenId) external view  virtual returns(address); // 查询一个地址是否是另一个地址的授权操作员 
    function isApprovedForAll(address _owner, address _operator)external view virtual returns (bool); 

}