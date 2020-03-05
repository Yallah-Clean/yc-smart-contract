const YCAdminRole = artifacts.require("YCAdminRole");

module.exports =async (deployer)=> {
 const admin = await deployer.deploy(YCAdminRole);
 
};
