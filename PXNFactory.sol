//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract PXNFactory is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    uint256 public totalAPY = 400000000000000000000000000; // 400 000 000 ghosty
    uint256 public GhostAPY = 18250000000000000000000000; // amount for Ghost for a year
    uint256 public WraithsAPY = 18250000000000000000000000; // amount for Wraiths for a year
    uint256 public RegimentUpkeepAPY = 13500000000000000000000000; // amount for RegimentUpkeep for a year
    uint256 public CommunityRankRewardAPY = 100000000000000000000000000; // amount for CommunityRankReward for a year
    uint256 public EngagementRewardAPY = 100000000000000000000000000; // amount for EngagementReward for a year
    uint256 public EcosystemIncubatorAPY = 50000000000000000000000000; // amount for Ecosystem Incubator for a year
    uint256 public DeveloperFundAPY = 100000000000000000000000000; // amount for develper fund for a year

    uint256 public currentGhostamount;
    uint256 public currentWraithsamount;
    uint256 public currentRegimentUpkeepamount;
    uint256 public currentCommunityRankRewardamount;
    uint256 public currentEngagementRewardamount;
    uint256 public currentEcosystemIncubatoramount;
    uint256 public currentDeveloperFundamount;

    uint256 mintedTime;

    uint256 constant MaxLevel = 11; // number of max rank tier  11
    uint256 constant MinLevel = 1; // number of min rank tier  1
    uint256 constant LevelWithPhantom = 6; // phantom holder's initial level 6
    uint256 constant LevelWithNFT = 3; // our nft holder's initial level 3
    uint256 constant LevelWithOutNFT = 1; // Not nft holders's initial level 1
    address phantomAddress; // phantom nft contract address
    address ghostAddress; // ghost nft contract address
    address spectreAddress; // sprectre nft contract address
    address wraithsAddress; // wraiths nft contract address

    uint256[] public levelReward; // array of daily reward amount for each rank    [1,3,5,10,15,25,50,100,150,500,1000]

    mapping(address => uint256) currentLevel; // mapping current level for each user

    function initialize() public initializer {
        __Ownable_init();
        __ERC20_init("Phantom Token", "PXN");
    }

    function setLevelReward(uint256[] memory _levelReward) external onlyOwner {
        levelReward = _levelReward;
    }

    function mintGhosty() external onlyOwner {
        require(
            block.timestamp > mintedTime + 31556926,
            "Already minted this year"
        );
        mintedTime = block.timestamp;
        _mint(address(this), totalAPY);
        _approve(address(this), owner(), totalAPY);
        setAllTokenAmount();
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        uint256 realamount = (amount * 101) / 100;
        require(realamount < balanceOf(from), "Insufficient Balance");
        require(to != address(0), "Invalid Address");
        require(amount > 0, "Insufficient value");

        uint256 burnamount = amount / 100;
        super.transferFrom(from, to, amount);
        _burn(from, burnamount);
        return true;
    }

    // DISTRIBUTION

    function claimGhost(address _address, uint256 amount) external onlyOwner {
        require(currentGhostamount + amount < GhostAPY, "Already Claimed");
        require(_address != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        super.transferFrom(address(this), _address, amount);
        currentGhostamount += amount;
    }

    function claimWraiths(address _address, uint256 amount) external onlyOwner {
        require(currentWraithsamount + amount < WraithsAPY, "Already Claimed");
        require(_address != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        super.transferFrom(address(this), _address, amount);
        currentWraithsamount += amount;
    }

    function claimRegimentUpkeep(address _address, uint256 amount)
        external
        onlyOwner
    {
        require(
            currentRegimentUpkeepamount + amount < RegimentUpkeepAPY,
            "Already Claimed"
        );
        require(_address != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        super.transferFrom(address(this), _address, amount);
        currentRegimentUpkeepamount += amount;
    }

    function claimCommunityReward(address _address, uint256 amount)
        external
        onlyOwner
    {
        require(
            currentCommunityRankRewardamount + amount < CommunityRankRewardAPY,
            "Already Claimed"
        );
        require(_address != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        super.transferFrom(address(this), _address, amount);
        currentCommunityRankRewardamount += amount;
    }

    function claimEngagementReward(address _address, uint256 amount)
        external
        onlyOwner
    {
        require(
            currentEngagementRewardamount + amount < EngagementRewardAPY,
            "Already Claimed"
        );
        require(_address != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        super.transferFrom(address(this), _address, amount);
        currentEngagementRewardamount += amount;
    }

    function claimEcosystemIncubator(address _address, uint256 amount)
        external
        onlyOwner
    {
        require(
            currentEcosystemIncubatoramount + amount < EcosystemIncubatorAPY,
            "Already Claimed"
        );
        require(_address != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        super.transferFrom(address(this), _address, amount);
        currentEcosystemIncubatoramount += amount;
    }

    function claimDeveloperFund(address _address, uint256 amount)
        external
        onlyOwner
    {
        require(
            currentDeveloperFundamount + amount < DeveloperFundAPY,
            "Already Claimed"
        );
        require(_address != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        super.transferFrom(address(this), _address, amount);
        currentDeveloperFundamount += amount;
    }

    function setAllTokenAmount() internal {
        currentGhostamount = 0;
        currentWraithsamount = 0;
        currentRegimentUpkeepamount = 0;
        currentCommunityRankRewardamount = 0;
        currentEngagementRewardamount = 0;
        currentEcosystemIncubatoramount = 0;
        currentDeveloperFundamount = 0;
    }
}
