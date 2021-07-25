const Orbs = artifacts.require('Orbs.sol');
const BN = require('bn.js');

contract('Orbs', (accounts) => {

  beforeEach(async() => {
    OrbInstance = await Orbs.new();
  });

  it('should mint orb', async () => {
    
    const orb = ["F;4;29640.870666666666;090850", "G;3;29641.203999999998;7fc8bb", "E;2;29641.270666666667;002b88", "E;2;29641.870666666666;fa9386", "B;6;29642.870666666666;c8123e", "B;5;29643.370666666666;238f85", "F;2;29643.870666666666;b6aeb8", "D;5;29644.370666666666;8b9907", "D;2;29644.870666666666;cf1128", "B;3;29645.370666666666;120fe8", "B;6;29645.870666666666;d326cb", "D;5;29646.370666666666;2caa1d", "E;4;29646.870666666666;b1a1f7", "F;3;29647.370666666666;440137", "B;5;29647.870666666666;5c3560", "D;5;29648.370666666666;22d724", "D;4;29648.870666666666;cd2f50", "B;4;29649.370666666666;d0613e", "D;5;29649.870666666666;ed97ec", "E;3;29650.370666666666;bda587", "C;6;29650.870666666666;b8ea15", "D;2;29651.370666666666;37ef17", "E;4;29662.870666666666;2badf1", "A;5;29663.370666666666;71e1e5", "F;4;29664.870666666666;2a25cd", "E;4;29665.370666666666;60f3a3", "C;5;29665.870666666666;d6efca", "E;3;29666.370666666666;26b253", "B;2;29666.870666666666;df685d", "B;5;29667.370666666666;b5ac94"];
    
    await OrbInstance.mintCollectable(accounts[0],orb);
    const orbs = await OrbInstance.getOrbs();

    assert(orbs.length > 0,"no elements in collection");
    assert(orbs.length == 1,"wrong number added to collection");
    assert(Owner===accounts[0],"Did not mint to owner");

  });

});
