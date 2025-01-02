// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

//以下元信息（描述代币本身的信息）扩展是可选的，但是可以提供一些资产代表的信息以便查询。 
/// @title ERC-721 非同质化代币标准, 可选元信息扩展 
/// Note: 按 ERC-165 标准，接口 id 为 0x5b5e139f 
interface IERC721Metadata { 

    // NFTs 集合的名字 
    function name() external view returns (string memory _name); 

    // NFTs 缩写代号 
    function symbol() external view returns (string memory _symbol); 

    // 一个给定资产的唯一的统一资源标识符(URI) 
    // 如果_tokenId 无效，抛出异常 
    /// URI 也许指向一个符合“ERC721 元数据 JSON Schema”的JSON 文件
    function tokenURI(uint256 _tokenId) external view returns (string memory); 

} 