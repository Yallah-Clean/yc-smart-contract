pragma solidity ^0.5.0;
import '../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '../node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import '../node_modules/@openzeppelin/contracts/GSN/Context.sol';
import '../node_modules/@openzeppelin/contracts/math/SafeMath.sol';


contract OrgWallet is  Context, ReentrancyGuard{
    using SafeMath for uint256;

    IERC20 _token ;
    
    // var
    uint private _rate;
    uint private _pointRaised;





    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value points paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    constructor( IERC20 token,uint256 rate) public{
 
        _rate = rate;
        _token = token;
}





    /**
     * @dev fallback function 
     Don't Accepts ETH
     */
    function () external payable {
       revert("Eth is not accepted");
    }

    /**
     * @return the token being sold.
     */
    function token() public view returns (IERC20) {
        return _token;
    }



    /**
     * @return the number of token units a buyer gets per point.
     */
    function rate() public view returns (uint256) {
        return _rate;
    }

    /**
     * @return the amount of point raised.
     */
    function pointRaised() public view returns (uint256) {
        return _pointRaised;
    }

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * This function has a non-reentrancy guard, so it shouldn't be called by
     * another `nonReentrant` function.
     * @param beneficiary Recipient of the token purchase
     */
    function _transferTokens(address beneficiary, uint256 pointAmount) internal  nonReentrant  {
        _preValidatePurchase(beneficiary, pointAmount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(pointAmount);
        _postValidatePurchase(pointAmount);
        // update state
        _pointRaised = _pointRaised.add(pointAmount);

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(_msgSender(), beneficiary, pointAmount, tokens);


    }
       /**
     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
     * conditions are not met.
     * @param pointAmount Value in point involved in the purchase
     */
    function _postValidatePurchase(uint256 pointAmount) internal view {
        // solhint-disable-previous-line no-empty-blocks
               require(_token.balanceOf(address(this)) > pointAmount,"insufficient funds");

    }

    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
     * Use `super` in contracts that inherit from Crowdsale to extend their validations.
     * Example from CappedCrowdsale.sol's _preValidatePurchase method:
     *     super._preValidatePurchase(beneficiary, pointAmount);
     *     require(pointRaised().add(pointAmount) <= cap);
     * @param beneficiary Address performing the token purchase
     * @param pointAmount Value in point involved in the purchase
     */
    function _preValidatePurchase(address beneficiary, uint256 pointAmount) internal view {
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(pointAmount != 0, "Crowdsale: pointAmount is 0");
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    }

 
    /**
     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
     * its tokens.
     * @param beneficiary Address performing the token purchase
     * @param tokenAmount Number of tokens to be emitted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        _token.transfer(beneficiary, tokenAmount);
    }

    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
     * tokens.
     * @param beneficiary Address receiving the tokens
     * @param tokenAmount Number of tokens to be purchased
     */
    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        _deliverTokens(beneficiary, tokenAmount);
    }





  /**
     * @dev Override to extend the way in which tokener is converted to tokens.
     * @param pointAmount Value in point to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _pointAmount
     */
    function _getTokenAmount(uint256 pointAmount) internal view returns (uint256) {
        return pointAmount.div(_rate);
    }
  
}