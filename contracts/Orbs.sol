// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Orbs is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;


    mapping (uint256 => uint256) private _tokenPrices;

    struct OrbProps {
        uint256 id;
        uint256 price;
        string uri;
    }

    constructor() ERC721("Orbs", "ORBS") {
    }


    // 0 -> ['tone','note','time','hashmark'] ...
    function mintCollectable(address _owner, string memory _tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_owner, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        
        return newItemId;
    }


}