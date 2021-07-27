// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Orbs is ERC721{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;


    mapping (uint256 => uint256) private _tokenPrices;
    mapping (uint256 => string) private _tokenDnas;

    struct OrbProps {
        uint256 id;
        address owner;
        uint256 price;
        string dna;
    }

    constructor() ERC721("Orbs", "ORBS") {
    }
    

    function getAllOrbs () public view virtual returns( OrbProps[] memory ) {
        OrbProps[] memory tokens = new OrbProps[](_tokenIds.current());
        uint256 counter = 0;

        for(uint i = 1; i < _tokenIds.current() + 1; i++) {
                address owner = ownerOf(i);
                OrbProps memory token = OrbProps(i,owner, _tokenPrices[i], _tokenDnas[i]);
                tokens[counter] = token;
                counter++;
        }
        return tokens;
    }

    function setTokenPrice(uint256 tokenId, uint256 _price) public {
        require(_exists(tokenId), "ERC721Metadata: Price set of nonexistent token");
        _tokenPrices[tokenId] = _price;
    }

    function setTokenDna(uint256 tokenId,string memory _dna) public {
        _tokenDnas[tokenId] = _dna;
    }
    
    

    // 0 -> ['tone','note','time','hashmark'] ...
    function mintCollectable(address _owner, string memory _dna)
        public
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_owner, newItemId);
        setTokenDna(newItemId, _dna);
        return newItemId;
    }

    //receive() external payable {}


}