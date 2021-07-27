const Orbs = artifacts.require('Orbs.sol');
const BN = require('bn.js');

contract('Orbs', (accounts) => {

  beforeEach(async() => {
    OrbInstance = await Orbs.new();
  });

  it('should mint orb', async () => {
    
    const orbUri = "fyagygfygfg";
    
    await OrbInstance.mintCollectable(accounts[0],orbUri);
    const orbs = await OrbInstance.getAllOrbs();

    assert(orbs.length > 0,"no elements in collection");
    assert(orbs.length == 1,"wrong number added to collection");
    //assert(Owner===accounts[0],"Did not mint to owner");

  });

});
