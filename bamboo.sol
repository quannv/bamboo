pragma solidity ^0.6.2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = now + time;
        emit OwnershipTransferred(_owner, address(0));
    }

    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(
            _previousOwner == msg.sender,
            "You don't have permission to unlock"
        );
        require(now > _lockTime, "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

contract Bamboo is Context, Ownable {
    using SafeMath for uint256;
    mapping(uint256 => bytes32) public reviewDataHashes;
    mapping(address => bool) private airdrop;
    address[] private _recipients;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSuply = 100000000000;
    string public name = "Bamboo Review";
    string public symbol = "BBR";
    //Total token is sent to reviewer for each approved content
    uint256 public rewardToken = 50;
    uint256 public decimal = 18;
    uint256 public advertisingPrice = 100;
    uint256 public medalPrice = 100;
    uint256 public airdropAmount = 200;

    constructor() public {
        balances[msg.sender] = totalSuply;
    }

    //TODO define review data for mapping with backend
    struct ReviewStruct {
        uint256 bbr_id;
        address reviewerAddress;
        bytes32 hashed;
    }

    //event
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed from, address indexed to, uint256 value);
    event Aidrop(address claimant, uint256 amount);
    event SubmitReview(address reviewer, uint256 amount);
    event BuyVoucher(address buyer, uint256 amount);

    // Airdrop to 1000 members
    //TODO: update airdrop function using Merkle Airdrop
    function getAirdrop(address claimant) public returns (bool) {
        require(!airdrop[claimant], "This address has received airdrop token");
        approve(owner(), airdropAmount);
        if (_recipients.length < 1000) {
            transferFrom(owner(), claimant, airdropAmount);
            airdrop[claimant] = true;
            _recipients.push(claimant);
            emit Aidrop(claimant, airdropAmount);
        }
    }

    function getReviews() public onlyOwner() {
        //return this.reviewDataHashes;
    }

    //upload review and receive token
    function storeReview(
        uint256 _reviewId,
        address receiver,
        bytes32 _dataHash
    ) public onlyOwner() returns (bool) {
        reviewDataHashes[_reviewId] = _dataHash;
        this.transferFrom(owner(), receiver, rewardToken);
        emit SubmitReview(receiver, rewardToken);
    }

    //seller want to get signed medal
    function buyMedal() public returns (bool) {
        return transferFrom(msg.sender, owner(), medalPrice);
    }

    //buyer send number of token to get voucher of a seller on marketplace
    // 20% token will be sent to owner contract
    // 80% token will be sent to seller
    function buyVoucher(address seller, uint256 amount) public returns (bool) {
        transferFrom(msg.sender, owner(), (amount * 20) / 100);
        transferFrom(msg.sender, seller, (amount * 80) / 100);
        emit BuyVoucher(msg.sender, rewardToken);
    }

    //Seller buy advertising banner
    function buyBanner() public returns (bool) {
        return transferFrom(msg.sender, owner(), advertisingPrice);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function getAllowance(address anyone) public view returns (uint256) {
        return allowance[anyone][msg.sender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf(msg.sender) > value, "balance is not enough");
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(balanceOf(from) >= value, "balance is not enough");
        require(allowance[from][msg.sender] >= value, "allowance too low");
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
}
