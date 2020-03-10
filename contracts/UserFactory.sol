pragma solidity ^0.5.0;
import '../node_modules/@openzeppelin/contracts/ownership/Ownable.sol';
import './YCAdminRole.sol';
import './BusinessPartnerWallet.sol';
import './UserWallet.sol';
import './OrgRegistry.sol';

contract UserFactory is Ownable {
    YCAdminRole admin ;
    // UserWallet collectorContract ;
    // UserWallet residentContract ;
    OrgRegistry orgRegistry;
    constructor(address _owner, YCAdminRole _admin,OrgRegistry _orgRegistry) public{
       _transferOwnership(_owner);
       admin = _admin;
       orgRegistry = _orgRegistry;
}
// var
     mapping   (address=>address) public residents;
     mapping   (address=>address) public collectors;
     mapping   (address=>address) public businessPartners;



// modifier
// modifier onlyAdmin() {
//     require(admin.isYCAdmin(msg.sender),"onlyAdmin: caller does not have the YCAdmin role");
//     _
// }

modifier OnlyNewResident(address resident) {
    require(isNewResident(resident),"OnlyNewResident: resident is already exist ");
    _;
}
modifier OnlyNewCollector(address collector) {
    require(isNewCollector(collector),"OnlyNewCollector: collector is already exist ");
    _;
}
modifier OnlyBusinessPartner(address businessPartner) {
    require(isNewBusinessPartners(businessPartner),"OnlyBusinessPartner: Business Partner is already exist ");
    _;
}

function isNewResident(address user) public view returns (bool) {
    return residents[user] == address(0);
}
function isNewCollector(address user) public  view returns (bool) {
    return collectors[user] == address(0);
}
function isNewBusinessPartners(address user) public view returns (bool) {
    return businessPartners[user] == address(0);
}
function getResident(address user) public view returns (address) {
    return residents[user];
}
function getCollector(address user) public view returns (address) {
    return collectors[user] ;
}
function getBusinessPartners(address user) public view returns (address) {
    return businessPartners[user] ;
}
// setter functions     
function addResident(address resident) public OnlyNewResident(resident) returns (address) {
    // create new contract
  
        residents[resident] = address(new UserWallet(resident,orgRegistry));

    return residents[resident];
}
function addCollector(address collector) public OnlyNewCollector(collector) returns (address) {
    // create new contract
        collectors[collector] = address(new UserWallet(collector,orgRegistry));

    return collectors[collector];
}
function addBusinessPartner(address businessPartner) public OnlyBusinessPartner(businessPartner) returns (address) {
    // create new contract
    businessPartners[businessPartner] = address(new BusinessPartnerWallet(businessPartner));
    return     businessPartners[businessPartner] ;
}
// function approve() public onlyAdmin() returns (bool) {
    
//     return true;
// }
}