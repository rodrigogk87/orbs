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
        address owner;
        uint256 price;
        string uri;
    }

    constructor() ERC721("Orbs", "ORBS") {
    }
    

    function getAllOrbs () public view virtual returns( OrbProps[] memory ) {
        OrbProps[] memory tokens = new OrbProps[](_tokenIds.current());
        uint256 counter = 0;

        for(uint i = 1; i < _tokenIds.current() + 1; i++) {
                address owner = ownerOf(i);
                OrbProps memory token = OrbProps(i,owner, _tokenPrices[i], tokenURI(i));
                tokens[counter] = token;
                counter++;
        }
        return tokens;
    }
    
    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() override internal view virtual returns (string memory) {
        return "https://ipfs.infura.io/ipfs/";
    }

    /**
     * @dev sets maps token to its price
     * @param tokenId uint256 token ID (token number)
     * @param _price uint256 token price
     * 
     * Requirements: 
     * `tokenId` must exist
     */
    function setTokenPrice(uint256 tokenId, uint256 _price) public {
        require(_exists(tokenId), "ERC721Metadata: Price set of nonexistent token");
        _tokenPrices[tokenId] = _price;
    }
    

    // 0 -> ['tone','note','time','hashmark'] ...
    function mintCollectable(address _owner, string memory _tokenURI)
        public payable
        returns (uint256)
    {
        require(msg.value > 0);
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_owner, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        setTokenPrice(newItemId,msg.value);
        return newItemId;
    }

    receive() external payable {}


}