// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PoolKey} from "v4-core/src/types/PoolKey.sol";
import {PoolId, PoolIdLibrary} from "v4-core/src/types/PoolId.sol";

contract BlackListControl {
   address immutable public poolOwner;

   // NOTE: ---------------------------------------------------------
    // state variables should typically be unique to a pool
    // a single hook contract should be able to service multiple pools
    // ---------------------------------------------------------------
    mapping(PoolId => mapping(address => bool)) public blackList;
    error SenderBlackListed(address sender);
    constructor () {
        poolOwner = msg.sender;
    }

    function setBlackListStatusForAddress(PoolId _pool, address _sender, bool _status) external {
        require (msg.sender == poolOwner, "Only for Pool Owner");
        require (_sender != address(0), "No Zero Address");
        blackList[_pool][_sender] =_status;
    }

    function _checkBlackListed(PoolId _pool, address _sender) internal view {
        if(blackList[_pool][_sender]) {
            revert SenderBlackListed(_sender); 
        }
    }
}
