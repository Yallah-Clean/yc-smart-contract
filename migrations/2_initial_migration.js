const YCAdminRole = artifacts.require("YCAdminRole");
const YallaCleanToken = artifacts.require("YallaCleanToken");
// const OrgRegistry = artifacts.require("OrgRegistry");

module.exports =async (deployer,network,accouts)=> {
    const orgOwner = accouts[1];
    const rate = 100;
    const name = "YallaClean";
    const symbol = "YCT";
    const decimals = 18;

 const admin = await deployer.deploy(YCAdminRole);
 const token = await deployer.deploy(YallaCleanToken, name,  symbol,  decimals);
//  const orgReg = await deployer.deploy(OrgRegistry,orgOwner, YCAdminRole.address, YallaCleanToken.address,  rate);
 
};
