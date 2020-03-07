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
    require(!isBusinessPartners(businessPartner),"OnlyBusinessPartner: Business Partner is already exist ");
    _;
}

function isNewResident(address user) public returns (bool) {
    return residents[user] == address(0);
}
function isNewCollector(address user) public returns (bool) {
    return collectors[user] == address(0);
}
function isBusinessPartners(address user) public returns (bool) {
    return businessPartners[user] == address(0);
}
// setter functions     
function addResident(address resident) public OnlyNewResident(resident) returns (bool) {
    // create new contract
  
        residents[resident] = address(new UserWallet(resident,orgRegistry));

    return true;
}
function addCollector(address collector) public OnlyNewCollector(collector) returns (bool) {
    // create new contract
        collectors[collector] = address(new UserWallet(collector,orgRegistry));

    return true;
}
function addBusinessPartner(address businessPartner) public OnlyBusinessPartner(businessPartner) returns (bool) {
    // create new contract
    businessPartners[businessPartner] = address(new BusinessPartnerWallet(businessPartner));
    return true;
}
// function approve() public onlyAdmin() returns (bool) {
    
//     return true;
// }
}