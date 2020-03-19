const YCAdminRole = artifacts.require("YCAdminRole");
const YallaCleanToken = artifacts.require("YallaCleanToken");
const OrgRegistry = artifacts.require("OrgRegistry");

module.exports =async (deployer,network,accouts)=> {
    const orgOwner = accouts[0];
    const rate = 100;
    const name = "YallaClean";
    const symbol = "YCT";
    const decimals = 18;
console.log(accouts,'accouts');

 const admin = await deployer.deploy(YCAdminRole);
 const token = await deployer.deploy(YallaCleanToken, name,  symbol,  decimals);
 const orgReg = await deployer.deploy(OrgRegistry,orgOwner, YCAdminRole.address, YallaCleanToken.address,  rate);
 OrgRegistry.deployed().then(instance=>{
    const userFactory = instance.userFactory();
 console.log(userFactory,'userFactory ');
 
  })
};
