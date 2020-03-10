pragma solidity ^0.5.0;
import '../node_modules/@openzeppelin/contracts/ownership/Ownable.sol';

import '../node_modules/@openzeppelin/contracts/math/SafeMath.sol';

import './YCAdminRole.sol';
import './OrgWallet.sol';
import './UserFactory.sol';
import './DeliverableService.sol';

contract OrgRegistry is Ownable ,   OrgWallet , DeliverableService{
    using SafeMath for uint256;
    YCAdminRole public admin ;
    UserFactory public userFactory ;
    
    // var
    uint256 public residentRate =2;
    uint256 public collectorRate = 8;
    bool status ;
     mapping   (uint256=>TrashDetails) public trashList;
    struct TrashDetails{
        string name;
        string UnitName;
        uint256 unitMaltiplier;
        uint256 price;
    }



    constructor(address _owner, YCAdminRole _admin,IERC20 token, uint256 rate) OrgWallet( token, rate)public{
        _transferOwnership(_owner);
        admin = _admin;
       
        userFactory = new UserFactory( _owner,  _admin,this);
}

// modifier
modifier onlyAdmin() {
    require(admin.isYCAdmin(_msgSender()),"onlyAdmin: caller does not have the YCAdmin role");
    _;
}
modifier onlyCollector(address account) {
    require(userFactory.getCollector(account)==_msgSender(),"onlyCollector: caller does not have the Collector role");
    _;
}
modifier onlyResident(address account) {
    require(userFactory.getResident(account)==_msgSender(),"onlyResident: caller does not have the Resident role");
    _;
}
modifier isApproved() {
    require(status,"isApproved: caller is not Approved");
    _;
}



function calcCollectorPoints(uint256  code, uint256 amount) public view returns (uint256) {

    return  trashList[code].price.mul(amount.div(trashList[code].unitMaltiplier)).mul(collectorRate).div(10);
}
function calcResidentPoints(uint256  code, uint256 amount) public view returns (uint256) {
 
    return  trashList[code].price.mul(amount.div(trashList[code].unitMaltiplier)).mul(residentRate).div(10);
}

// setter functions     
function manageTrashType(uint256  code,string memory name,string memory UnitName,uint256 unitMaltiplier, uint256 price) public returns (bool) {
    
    trashList[code] = TrashDetails ( name, UnitName, unitMaltiplier, price);
    return true;
}
function _redeemToken(uint256 points) internal returns (bool ) {
    _transferTokens(_msgSender(),points);
    return true;
}

function approve() public onlyAdmin() returns (bool) {
    
status = true;
    return true;
}

       function addDelivery(string calldata location,uint256 time, uint256 code, uint256 amount,
       address residnet,uint256 mapHash , address account ) external onlyCollector(account) returns (bool) {
        
        require(_addDelivery(mapHash, _msgSender(), residnet,
     location, time, code, amount)," calling _addDeliverables function has issues ");
        // emit event
                return true;

    }

    function validateDeliverables( uint256  mapHash, uint256 points, address account )external  onlyCollector(account)  returns (bool) {
         require(_validateDeliverables(mapHash, true)," calling _validateDeliverables function has issues ");
                _redeemToken(points);

        return true;
    }
    function confirmPickup( uint256  mapHash,uint256 points , address account )external onlyResident(account) returns (bool) {
                require(_confirmPickup(mapHash,true),"calling _validateDeliverables function has issues ");
                _redeemToken(points);


  
        return true;
    }
 


  
}