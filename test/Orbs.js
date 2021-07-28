const Orbs = artifacts.require('Orbs.sol');
const BN = require('bn.js');
const { expectRevert } = require('@openzeppelin/test-helpers');

contract('Orbs', (accounts) => {

  beforeEach(async() => {
    mint_fee = web3.utils.toWei('0.01', 'ether');
    OrbInstance = await Orbs.new();
  });

  it('should mint orb', async () => {
    
    const orbUri = "fyagygfygfg";
    
    await OrbInstance.mintCollectable(accounts[0],orbUri,{from:accounts[0], value: mint_fee});
    const orbs = await OrbInstance.getAllOrbs();

    assert(orbs.length > 0,"no elements in collection");
    assert(orbs.length == 1,"wrong number added to collection");
    let Owner = await OrbInstance.ownerOf(1);
    assert(Owner===accounts[0],"Did not mint to owner");

  });

  it('should transfer amount to owner', async () => {
    let allorbs = await OrbInstance.getAllOrbs();
    let oldBalance = await web3.eth.getBalance(accounts[0]);
    let amountToMint=10;
    for(let i=1;i<amountToMint+1;i++){
      let orbDna = "orbDna"+i;
      await OrbInstance.mintCollectable(accounts[1],orbDna,{from:accounts[1], value: mint_fee});
    }

    await OrbInstance.transferBalanceToOwner();
    let newBalance = await web3.eth.getBalance(accounts[0]);
    oldBalance = new BN(oldBalance, 10);
    newBalance = new BN(newBalance, 10);
    assert(newBalance.gt(oldBalance),"did not transfer balance to owner");

  });

  it('should paginate orbs', async () => {  
          let amountToMint=10;
          for(let i=1;i<amountToMint+1;i++){
            let orbDna = "orbDna"+i;
            await OrbInstance.mintCollectable(accounts[0],orbDna,{from:accounts[0], value: mint_fee});
          }
          /*let allorbs = await OrbInstance.getAllOrbs();
          for(let i=0;i<allorbs.length;i++ ){
            console.log(allorbs[i].id);
          }*/
          //from tokenId 3 we want 5 orbs, so it should be token 3 to 7
          let res  = await OrbInstance.getNthsOrbs(3,5);
          assert(res.length > 0);
          assert(res.length == 5);
          for(let i=0;i<5;i++ )
          assert(res[i].dna == 'orbDna'+(i+3),'error asserting 3,5');

          //from tokenId 5 we want 5 orbs, so it should be token 5 to 9
          let res2  = await OrbInstance.getNthsOrbs(5,5);
          assert(res2.length > 0);
          assert(res2.length == 5);
          for(let i=0;i<5;i++ )
          assert(res2[i].dna == 'orbDna'+(i+5),'error asserting 5,5');
          
          
          //from tokenId 5 we want 11 orbs, so it should be token 5 to 10!
          let res3  = await OrbInstance.getNthsOrbs(5,11);
          assert(res3.length > 0);
          assert(res3.length == 6);
          for(let i=0;i<6;i++ )
          assert(res3[i].dna == 'orbDna'+(i+5),'error asserting 5,11');
          
          //from tokenId 1 we want 2 orbs, so it should be token 1 to 2
          let res4  = await OrbInstance.getNthsOrbs(1,2);
          assert(res4.length == 2);
          assert(res4.length > 0);
          for(let i=0;i<2;i++ )
          assert(res4[i].dna == 'orbDna'+(i+1),'error asserting 1,2');

          //from tokenId 1 we want 2 orbs, so it should be token 1 to 10
          let res5  = await OrbInstance.getNthsOrbs(1,11);
          assert(res5.length == 10);
          assert(res5.length > 0);
          for(let i=0;i<10;i++ )
          assert(res5[i].dna == 'orbDna'+(i+1),'error asserting 1,11');

          //from tokenId 1 we want 2 orbs, so it should be token 9 to 10
          let res6  = await OrbInstance.getNthsOrbs(8,4);
          assert(res6.length == 3);
          assert(res6.length > 0);
          for(let i=0;i<3;i++ ){
            assert(res6[i].dna == 'orbDna'+(i+8),'error asserting 8,4');
          }

          //out of index expect revert
          await expectRevert(
            OrbInstance.getNthsOrbs(11,2),
            'out of index'
          );

          //wrong number of orbs requested expect revert
          await expectRevert(
            OrbInstance.getNthsOrbs(1,0),
            'number of orbs should be greater than 0'
          );

  });

 


});
