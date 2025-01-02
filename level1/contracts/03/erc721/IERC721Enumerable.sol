// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 非同质资产不能像账本中的数字那样“集合”在一起，而是每个资产必须单独跟踪所有权，因此需要在合约内部用唯一 uint256 ID 
// 标识码来标识每个资产，该标识码在整个合约期内均不得更改，因此使用（合约地址，
// tokenId）对就成为以太坊链上特定资产的全球唯一且完全合格的标识符。标准并没有限定 ID 标识码的规则，
// 不过开发者可以选择实现下面的枚举接口，方便用户查询 NFTs 的完整列表。
/// @title ERC-721 非同质化代币标准枚举扩展信息（可选接口）
/// Note: 按 ERC-165 标准，接口 id 为 0x780e9d63
interface IERC721Enumerable /* is ERC721 */ { 

    // NFTs 计数 
    /// @return 返回合约有效跟踪（所有者不为零地址）的 NFT 数量
    function totalSupply() external view returns (uint256); 

    // 枚举索引 NFT 
    // 如果 _index >= totalSupply() 则抛出异常 
    function tokenByIndex(uint256 _index) external view returns(uint256); // 枚举索引某个所有者的 NFTs 
    
    function tokenOfOwnerByIndex(address _owner, uint256 _index)external view returns (uint256); 

}