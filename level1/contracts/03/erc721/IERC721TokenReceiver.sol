// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

//如果合约（应用）要接受 NFT 的安全转账，则必须实现以下接口。
// 按 ERC-165 标准，接口 id 为 0x150b7a02 
interface ERC721TokenReceiver { 

    // 处理接收 NFT 
    // ERC721 智能合约在 transfer 完成后，在接收者地址上调用这个函数
    /// @return 正确处理时返回 
    // bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")) 
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4); 
    
} 