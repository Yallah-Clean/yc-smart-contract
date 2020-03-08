pragma solidity ^0.5.0;
import '../node_modules/@openzeppelin/contracts/ownership/Ownable.sol';

import '../node_modules/@openzeppelin/contracts/math/SafeMath.sol';

import './YCAdminRole.sol';
import './OrgWallet.sol';
import './UserFactory.sol';
import './DeliverableService.sol';

contract OrgRegistry is Ownable ,   OrgWallet , DeliverableService{
    using SafeMath for uint256;
    YCAdminRole admin ;
    UserFactory userFactory ;
    
    // var
    uint256 public residentRate =2;
    uint256 public collectorRate = 8;
    bool status ;
     mapping   (uint=>TrashDetails) public trashList;
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
modifier onlyCollector() {
    require(!userFactory.isNewCollector(_msgSender()),"onlyCollector: caller does not have the Collector role");
    _;
}
modifier onlyResident() {
    require(!userFactory.isNewResident(_msgSender()),"onlyResident: caller does not have the Resident role");
    _;
}
modifier isApproved() {
    require(status,"isApproved: caller is not Approved");
    _;
}



function calcCollectorPoints(uint256  code, uint256 amount) public returns (uint256) {
    
    return  trashList[code].price.mul(amount.div(trashList[code].unitMaltiplier)).mul(collectorRate/10);
}
function calcResidentPoints(uint256  code, uint256 amount) public returns (uint256) {
    
    return  trashList[code].price.mul(amount.div(trashList[code].unitMaltiplier)).mul(residentRate/10);
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

       function addDelivery(uint256 location,uint256 time, uint256 code, uint256 amount,
       address residnet,uint256 mapHash ) external onlyCollector() returns (bool) {
        
        require(_addDelivery(mapHash, _msgSender(), residnet,
     location, time, code, amount)," calling _addDeliverables function has issues ");
        // emit event
                return true;

    }

    function validateDeliverables( uint256  mapHash, uint256 points)external  onlyCollector()  returns (bool) {
         require(_validateDeliverables(mapHash, true)," calling _validateDeliverables function has issues ");
                _redeemToken(points);

        return true;
    }
    function confirmPickup( uint256  mapHash,uint256 points)external onlyResident() returns (bool) {
                require(_confirmPickup(mapHash,true),"calling _validateDeliverables function has issues ");
                _redeemToken(points);


  
        return true;
    }
 


  
}