// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 查询某个合约是否支持某个接口，采用函数选择器的方式，interfaceId是某个接口的keccak256的签名
// 开发NFT市场或者钱包，通过ERC165查询某个合约是否支持ERC721和ERC115标准，以决定如何与该合约交互
interface IERC165 {
  
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

}
