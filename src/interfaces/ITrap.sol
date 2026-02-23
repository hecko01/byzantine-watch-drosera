// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    /// @notice Collects data from the trap for operators to evaluate
    /// @return Encoded data containing all relevant information
    function collect() external view returns (bytes memory);
    
    /// @notice Determines if the trap should respond based on collected data
    /// @param data Array of data batches from operators
    /// @return True if the trap should trigger
    function shouldRespond(bytes[] calldata data) external pure returns (bool);
}
