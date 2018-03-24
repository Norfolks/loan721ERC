pragma solidity ^0.4.18;

import "./ERC721BasicToken.sol";
import "./ERC721Holder.sol";
import "./LoanToken.sol";


contract Loan is ERC721Holder {

	using SafeMath for uint256;

	address public debtor;
	uint256 public amount;
	uint256 public percent;
	uint256 public blockNumber;
	uint256 public tokenID;
	ERC721BasicToken public asset;


	LoanToken public loanToken;

	function Loan(address _deptor, uint256 _amount, uint256 _percent, uint256 _blockNumber, address _asset, uint256 _tokenID, LoanToken _loanToken) {
		debtor = _deptor;
		amount = _amount;
		percent = _percent;
		blockNumber = _blockNumber;
		asset = ERC721BasicToken(_asset);
		tokenID = _tokenID;
		loanToken = _loanToken;
	}

	function () payable {}

	function lendETH() public payable {
		require(asset.getApproved(tokenID) == address(this));
		require(msg.value == amount);
		asset.transferFrom(debtor, this, tokenID);
		loanToken.setLoanCreditor(msg.sender);
	}

	function releaseAssetToDeptor() public payable {
		require(msg.value == amount.add(amount.mul(percent).div(100)));
		loanToken.ownerOf(uint256(address(this))).transfer(msg.value);
		asset.transferFrom(this, debtor, tokenID);
	}

	function releaseAssetToCreditor() public {
		require(block.number > blockNumber);
		asset.transferFrom(this, loanToken.ownerOf(uint256(address(this))), tokenID);
	}


}

