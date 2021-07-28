// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Orbs is ERC721{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address payable orbsGod;


    mapping (uint256 => uint256) private _tokenPrices;
    mapping (uint256 => string) private _tokenDnas;
    mapping (uint256 => uint256) private _tokenLikes;

    struct OrbProps {
        uint256 id;
        address owner;
        uint256 price;
        string dna;
        uint likes;
    }

    constructor() ERC721("Orbs", "ORBS") {
        orbsGod = payable(msg.sender);
    }
    
    //EX TKID = 6, NO = 5, CURRENT = 7
    function getNthsOrbs(uint _token_id,uint _number_of_orbs) public view returns(OrbProps[] memory ){
        require(_number_of_orbs > 0,'number of orbs should be greater than 0');

        //particular case 0 elements
        if(_tokenIds.current()==0)
        return new OrbProps[](0);

        //particular case 1 element
        if(_tokenIds.current()==1){
         OrbProps[] memory token = new OrbProps[](1);
         token[0] = OrbProps(1,ownerOf(1), _tokenPrices[1], _tokenDnas[1],_tokenLikes[1]);
         return token;
        }        

        //more than 1 element
        require(_token_id < _tokenIds.current(),'out of index');

        //6,5
        uint totalOrbs =    (_tokenIds.current() > _number_of_orbs) 
                            ? (_tokenIds.current() >= _token_id+_number_of_orbs) 
                                ? _number_of_orbs 
                                : _tokenIds.current() - _token_id + 1
                            : _tokenIds.current() - _token_id + 1;


        OrbProps[] memory tokens = new OrbProps[](totalOrbs);
        uint256 counter = 0;


        for(uint i = _token_id; i < totalOrbs+_token_id; i++) {
                address owner = ownerOf(i);
                OrbProps memory token = OrbProps(i,owner, _tokenPrices[i], _tokenDnas[i],_tokenLikes[i]);
                tokens[counter] = token;
                counter++;
        }

        return tokens;
    }

    function getNumberOfOrbs() public view returns(uint){
        return _tokenIds.current();
    }

    function getAllOrbs () public view returns(OrbProps[] memory ) {
        OrbProps[] memory tokens = new OrbProps[](_tokenIds.current());
        uint256 counter = 0;

        for(uint i = 1; i < _tokenIds.current() + 1; i++) {
                address owner = ownerOf(i);
                OrbProps memory token = OrbProps(i,owner, _tokenPrices[i], _tokenDnas[i],_tokenLikes[i]);
                tokens[counter] = token;
                counter++;
        }

        return tokens;
    }

    function setTokenPrice(uint256 tokenId, uint256 _price) public onlyOwnerOfToken(tokenId) tokenExist(tokenId){
        _tokenPrices[tokenId] = _price;
    }

    function setTokenDna(uint256 tokenId,string memory _dna) internal tokenExist(tokenId){
        _tokenDnas[tokenId] = _dna;
    }
    
    function setLikeToken(uint256 tokenId,uint _like) external tokenExist(tokenId) returns(bool) {
        require(_like == 1);
        _tokenLikes[tokenId]+=1;
        return true;
    }

    function setUnLikeToken(uint256 tokenId,uint _like) external tokenExist(tokenId) returns(bool) {
        require(_like == 1);
        
        if(_tokenLikes[tokenId] > 0)
        _tokenLikes[tokenId]-=1;

        return true;
    }

    // 0 -> ['tone','note','time','hashmark'] ...
    function mintCollectable(address _owner, string memory _dna)
        public payable
        returns (uint256)
    {
        require(msg.value >= 0.01 ether, 'Need to send 0.01 ETH');
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_owner, newItemId);
        setTokenDna(newItemId, _dna);
        return newItemId;
    }

    receive() external payable {}


    function transferBalanceToOwner() payable external onlyCreator{
        orbsGod.transfer(address(this).balance);
    }

    modifier onlyOwnerOfToken(uint256 tokenId){
        require(msg.sender == ownerOf(tokenId), 'only creator of the token');
        _;
    }

    modifier onlyCreator{
        require(msg.sender == orbsGod, 'only creator');
        _;
    }

    modifier tokenExist(uint _token_id){
        require(_exists(_token_id), "ERC721Metadata: set data of nonexistent token");
        _;
    }


}