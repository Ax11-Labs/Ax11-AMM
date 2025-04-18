// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.28;

/// @title Factory Interface for Ax11 AMM
/// @notice Interface for the factory contract that deploys and manages Ax11 liquidity pools
interface IFactory {
    /// @notice Error thrown when the caller is not the owner
    error NOT_OWNER();

    /// @notice Error thrown when an invalid address is provided (zero address or identical tokens)
    error INVALID_ADDRESS();

    /// @notice Error thrown when attempting to create a pool that already exists
    error CREATED();

    /// @notice Emitted when a new pool is created
    /// @param tokenX The first token of the pool (lower address)
    /// @param tokenY The second token of the pool (higher address)
    /// @param pool The address of the newly created pool
    event PoolCreated(address indexed tokenX, address indexed tokenY, address pool);

    /// @notice Structure containing information about a pool
    /// @param tokenX The address of the first token in the pool (lower address)
    /// @param tokenY The address of the second token in the pool (higher address)
    struct PoolInfo {
        address tokenX;
        address tokenY;
    }

    /// @notice Returns the address of the sweeper
    /// @return The address of the sweeper
    function sweeper() external view returns (address);

    /// @notice Returns the total number of pools created
    /// @return The number of pools deployed by this factory
    function totalPools() external view returns (uint256);

    /// @notice Returns the address that receives protocol fees
    /// @return The address where protocol fees are sent
    function feeTo() external view returns (address);

    /// @notice Returns the address of the factory owner
    /// @return The address of the current owner
    function owner() external view returns (address);

    /// @notice Fetches the pool address for a given pair of tokens
    /// @dev The order of tokenX and tokenY doesn't matter, as the factory handles sorting
    /// @param tokenX The address of the first token
    /// @param tokenY The address of the second token
    /// @return pool The address of the pool for the token pair, or address(0) if it doesn't exist
    function getPool(address tokenX, address tokenY) external view returns (address pool);

    /// @notice Retrieves the tokens associated with a pool
    /// @param pool The address of the pool
    /// @return tokenX The address of the first token (lower address)
    /// @return tokenY The address of the second token (higher address)
    function getTokens(address pool) external view returns (address tokenX, address tokenY);

    /// @notice Creates a new pool for a pair of tokens
    /// @dev Tokens are automatically sorted so tokenX is always the lower address
    /// @param tokenX The address of the first token
    /// @param tokenY The address of the second token
    /// @param activeId The active bin of the pool
    /// @return pool The address of the newly created pool
    function createPool(address tokenX, address tokenY, int24 activeId) external returns (address pool);

    /// @notice Updates the owner of the factory
    /// @dev Can only be called by the current owner
    /// @param _owner The address of the new owner
    function setOwner(address _owner) external;

    /// @notice Updates the fee recipient address
    /// @dev Can only be called by the current owner
    /// @param _feeTo The new address to receive protocol fees
    function setFeeTo(address _feeTo) external;

    /// @notice Updates the sweeper address
    /// @dev Can only be called by the current owner
    /// @param _sweeper The new address to receive swept tokens
    function setSweeper(address _sweeper) external;

    /// @notice Sweeps tokens from a pool
    /// @dev Can only be called by the sweeper
    /// @param recipient The address to receive the swept tokens
    /// @param pool The address of the pool
    /// @param zeroOrOne Whether to sweep tokenX or tokenY
    /// @param amount The amount of tokens to sweep
    function poolSweep(address recipient, address pool, bool zeroOrOne, uint256 amount) external;
}
