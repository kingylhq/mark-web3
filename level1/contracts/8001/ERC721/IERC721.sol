// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "../../03/IERC165.sol";

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
interface IERC721 is IERC165 {

    /**
     @dev 当任何 NFT 的所有权通过任何形式发生变化时，需要触发该事件。
     当 NFT 创建（`from` == 0）和销毁（`to` == 0）时会触发此事件。
     例外情况：在合约创建期间，可以创建和分配任意数量的 NFT，而不会发出 Transfer。
     在任何形式的资产转移时，该 NFT如果有批准地址将重置为无。
    */
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    /**
     * 当 NFT 的批准地址被更改或重新确认时，它会发出。
     * 零地址表示没有批准的地址。
     * 当 Transfer 事件发出时，这也表明该 NFT 如果有批准地址被重置为无。
     */
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );

    /// @dev 当为所有者启用或禁用操作员时，它会发出。 运营者可以管理所有者的所有 NFT。
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    /// @notice 所有者的 NFT 数量
    /// @dev 分配给零地址的 NFT 被认为是无效的，并且该函数抛出有关零地址的查询。
    /// @param _owner 查询余额的地址
    /// @return `_owner` 拥有的 NFT 数量，可能为零
    function balanceOf(address _owner) external view returns (uint256);

    /// @notice 找到 NFT 的所有者
    /// @dev 分配给零地址的 NFT 被认为是无效的，并且对它们的查询确实会抛出异常。
    /// @param _tokenId NFT 的标识符
    /// @return NFT所有者的地址
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice 将 NFT 的所有权从一个地址转移到另一个地址
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from NFT的当前所有者
    /// @param _to 新 owner
    /// @param _tokenId 转移的 NFT
    /// @param data 没有指定格式的附加数据，在调用 _to 时发送
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata data
    ) external payable;

    /// @notice 将 NFT 的所有权从一个地址转移到另一个地址
    /// @dev 这与具有额外数据参数的其他函数的工作方式相同，只是此函数只是将数据设置为“”。
    /// @param _from NFT的当前所有者
    /// @param _to 新 owner
    /// @param _tokenId 转移的 NFT
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    /// @notice 转移 NFT 的所有权——调用者有责任确认 `_to` 能够接收 NFTS，否则它们可能会永久丢失
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from NFT的当前所有者
    /// @param _to 新 owner
    /// @param _tokenId 转移的 NFT
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    /// @notice 更改或重申 NFT 的批准地址
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved 新批准的 NFT 控制器
    /// @param _tokenId NFT 批准
    function approve(address _approved, uint256 _tokenId) external payable;

    /// @notice 启用或禁用对第三方（“操作员”）的批准以管理所有 `msg.sender` 的资产
    /// @dev 发出 ApprovalForAll 事件。 合同必须允许每个所有者有多个操作员。
    /// @param _operator 添加到授权运营商集中的地址
    /// @param _approved 如果运营商获得批准，则为 True，如果撤消批准，则为 false
    function setApprovalForAll(address _operator, bool _approved) external;

    /// @notice 获取单个 NFT 的认可地址
    /// @dev 如果 _tokenId 不是有效的 NFT，则抛出。
    /// @param _tokenId NFT寻找批准的地址
    /// @return 此 NFT 的批准地址，如果没有则为零地址
    function getApproved(uint256 _tokenId) external view returns (address);

    /// @notice 查询一个地址是否是另一个地址的授权操作员
    /// @param _owner 拥有 NFT 的地址
    /// @param _operator 代表所有者的地址
    /// @return 如果 _operator 是 _owner 的批准运算符，则为真，否则为假
    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);

}