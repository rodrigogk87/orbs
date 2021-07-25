// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Orbs is ERC721{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping (uint256 => TokenProps) private _tokenData;
    // event Sent(address indexed payee, uint256 amount, uint256 balance);
    // event Received(address indexed payer, uint tokenId, uint256 amount, uint256 balance);

    struct TokenProps {
        uint256 id;
        string tone;
        string note;
        string time;
        string hashmark;
        uint256 price;
    }


    constructor() ERC721("Orbs", "ORBS") {
    }


    function setTokenPrice(uint256 tokenId, uint256 _price) public {
        require(_exists(tokenId), "ERC721Metadata: Price set of nonexistent token");
       _tokenData[tokenId].price=_price;
    }

    function mintCollectable(address _owner, string memory _tone, string memory _note, string memory _time, string memory _hashmark)
        public
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_owner, newItemId);
        _tokenData[newItemId].id=newItemId;
        _tokenData[newItemId].tone=_tone;
        _tokenData[newItemId].tone=_note;
        _tokenData[newItemId].tone=_time;
        _tokenData[newItemId].tone=_hashmark;

        return newItemId;
    }


}