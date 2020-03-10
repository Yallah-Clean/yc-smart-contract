const {
    time,
    ether,
    advanceBlock,
    expectEvent,
    BN,
} = require('@openzeppelin/test-helpers');

const BigNumber = web3.BigNumber;
const should = require('chai')
    .use(require('chai-bignumber')(BigNumber))
    .should();
const tokenContract = artifacts.require('YallaCleanToken');
const YCAdminRole = artifacts.require("YCAdminRole");
const OrgRegistry = artifacts.require("OrgRegistry");
const UserFactory = artifacts.require("UserFactory");
const UserWallet = artifacts.require("UserWallet");
const BusinessPartnerWallet = artifacts.require("BusinessPartnerWallet");
// const OrgRegistry = artifacts.require("OrgRegistry");
contract('TokenContract', (accounts) => {
    console.log(accounts, 'accounts');
    const rate = 100;

    let token;
    let userFactory;
    let userFactoryInstance;
    let userWallet;
    let userWalletInstance;
    let collectorWallet;
    let collectorWalletInstance;
    let orgRegestry;
    let adminRole;
    let bPartnerWallet;
    let bPartnerWalletinstance;
    let adminAccount = accounts[0]
    let orgAccount = accounts[1]
    let collectorAccount = accounts[2]
    let residentAccount = accounts[3]
    let bPartnerAccount = accounts[4]
    const  location= "Zag";
    const time = Date.now;
    const code= 505;
    const itemName= "plastic";
    const unitName = 'garm';
    const unitMaltiplier =2;
    const price =20;
     const amount = 100;
   const mapHash = 252525;
    let tokenvalue =1000;

/**
 * septs 
 * 1- org registery created 
 * 2-  org own some token 
 * 3- collector register  and org approve as collector
 * 4- resident register
 * 4- business partener  register
 * 5- residnet request order
 * 6- collector add delivery
 * 7- residnet confirm and mint his token 
 * 8- collector send delivery request to or 
 * 9- org confirm and mint token to collector 
 */
    before(async () => {
        // get depleoyed contract 
        adminRole = await YCAdminRole.deployed();
        token = await tokenContract.deployed();
    });
    beforeEach(async () => {

    });
    it('token should exist ', async () => {
        should.exist(token);

    });
    it('adminRole should exist ', async () => {
        should.exist(adminRole);
    });
    it('should create orgRegestry with correct parameters', async () => {
        orgRegestry = await OrgRegistry.new(orgAccount, adminRole.address, token.address, rate);

        should.exist(orgRegestry);

    });
    it('should mint  token to orgRegestry with correct parameters', async () => {
        const tx = await token.mint(orgRegestry.address, tokenvalue, {
            from: adminAccount
        })
        // expectEvent(tx, 'Transfer', {
        //     from: '0x0000000000000000000000000000000000000000',
        //     to: orgRegestry.address,
        //     value: tokenvalue,
        // });
        // let balance = await token.balanceOf(orgRegestry.address);

        // balance.should.be.bignumber.equal(tokenvalue);
    
    });
    it('org can add trash list details with correct parameters', async () => {
        const tx = await orgRegestry.manageTrashType(  code, itemName, unitName, unitMaltiplier,  price,{
            from: orgAccount
        })
        tx.receipt.status.should.be.equal(true);
    });

    it('userFactory should exist', async () => {
        userFactory = await orgRegestry.userFactory();
        userFactoryInstance =await UserFactory.at(userFactory)
        should.exist(userFactoryInstance);

    });
    it('should create wallet to residnet  with correct parameter', async () => {
        
        const tx   = await userFactoryInstance.addResident(residentAccount,{
            from: adminAccount
        });
        const userWallet   = await userFactoryInstance.residents(residentAccount);
console.log(userWallet,'userWallet');

        userWalletInstance = await UserWallet.at(userWallet);
        should.exist(userWallet);

    });
    it('should create wallet to collector  with correct parameter', async () => {
        const tx   = await userFactoryInstance.addCollector(collectorAccount,{
            from: adminAccount
        });
        const collectorWallet   = await userFactoryInstance.collectors(collectorAccount);

        collectorWalletInstance = await UserWallet.at(collectorWallet);
        should.exist(collectorWallet);

    });
    it('should create wallet to business partner  with correct parameter', async () => {
        const tx   = await userFactoryInstance.addBusinessPartner(bPartnerAccount,{
            from: adminAccount
        });
        bPartnerWallet = await userFactoryInstance.businessPartners(bPartnerAccount);
        bPartnerWalletinstance = await BusinessPartnerWallet.at(bPartnerWallet);
        should.exist(bPartnerWalletinstance);

    });
    it('residnet can send request', async () => {
        const tx  = await userWalletInstance.residentSendRequest(location,time,{
            from: residentAccount
        });
        tx.receipt.status.should.be.equal(true); 

    });
    it('org  can approve collector', async () => {
        const tx  = await collectorWalletInstance.approveCollector({
            from: orgAccount
        });
        tx.receipt.status.should.be.equal(true); 

    });
    it('collector  can add deliverabiles', async () => {
        const tx  = await collectorWalletInstance.collectorAddDelivery( location, time,  code,  amount,
            residentAccount, mapHash,{
            from: collectorAccount
        });
    
        tx.receipt.status.should.be.equal(true); 

    });
    it('check amounts ', async () => {
        const trList  = await orgRegestry.trashsubmission(mapHash );
        console.log(trList,'list of trash');
        const getDeliveredAmount  = await orgRegestry.getDeliveredAmount(mapHash );
        console.log(getDeliveredAmount,'getDeliveredAmount');
        const getDeliveredCode  = await orgRegestry.getDeliveredCode(mapHash );
        // console.log(getDeliveredCode,'getDeliveredCode');
        const calcResidentPoints  = await orgRegestry.calcResidentPoints(getDeliveredCode,getDeliveredAmount );
        console.log(calcResidentPoints,'calcResidentPoints');

    });

    it('resident  can add redeem tokens', async () => {
        const tx  = await userWalletInstance.residentConfirm(  mapHash,{
            from: residentAccount
        });
                let balance = await token.balanceOf(userWalletInstance.address);
console.log(balance,'balance');

        tx.receipt.status.should.be.equal(true); 

    });
    it('collector  can add submit', async () => {
        const tx  = await collectorWalletInstance.collectorSubmitRequest(  location,time,{
            from: collectorAccount
        });
     
              

        tx.receipt.status.should.be.equal(true); 

    });
    it('org  can add validate and transfer tokens to collector', async () => {
        const tx  = await collectorWalletInstance.OrgConfirm(  mapHash,{
            from: orgAccount
        });
                let balance = await token.balanceOf(collectorWalletInstance.address);
console.log(balance,'balance');

        tx.receipt.status.should.be.equal(true); 

    });

});
/**    */