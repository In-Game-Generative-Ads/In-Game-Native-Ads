// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HolderData is ERC721URIStorage, Ownable{  

    // create a struct for the campaign data
    struct HolderDatainfo {
        string holderName;        
        string holderPrompt;
        address gameID;
        uint256 gameClientHolderID;
        uint256 campaigns;
        uint256 activeCampaigns;
        uint256 users;
        uint256 views;
        uint256 leads;
        bool paused;

    }

    mapping(uint256 => HolderDatainfo) public _holders;

    struct GameDatainfo {
        string gameName;
        string gameOwner;
        address payable wallet;
        uint256 gameCount;
        string gamePrompt;
        uint256 gameHolders;
        uint256 activeGameHolders;
        uint256 campaigns;
        uint256 activeCampaigns;
        uint256 users;
        uint256 views;
        uint256 leads;
        bool paused;

    }

    mapping(uint256 => GameDatainfo) public _games;
    //NFT Events
    event NFTMinted(address indexed owner, uint256 indexed tokenId, string tokenURI);

    //Holder Events
    event HolderPromptUpdated(uint256 _holderID, string newPrompt);
    event gameClientHolderIDUpdated(uint256 _holderID, uint256 newID);
    event holderNameUpdated(uint256 _holderID, string newName);
    
    //Game Events
    event gamePromptUpdated(uint256 _gameINFO, string _newPrompt);
    event gameOwnerUpdated (uint256 _gameINFO, string _newOwner);
    event walletAddressUpdated(uint _gameINFO, address _newWallet);
    event gameNameUpdated(uint256 _gameINFO, string _newName);

    constructor() Ownable(msg.sender) ERC721("Holder NFT", "HNFT") {}
    

    //Holder Functions

    function viewUsers(uint256 _holdersID) public view returns (HolderDatainfo memory) {
        //View Holders
        return _holders[_holdersID];
    }
    function addUsers(uint256 _holdersID, uint256 value) public {
        _holders[_holdersID].users += value;
    }

    function setHolderPrompt(uint256 _holderID, string memory _newPrompt) public {
        require(ownerOf(_holderID) == msg.sender, "Only the ID owner can update the prompt");
        _holders[_holderID].holderPrompt = _newPrompt;
        emit HolderPromptUpdated(_holderID, _newPrompt);
    }

    function setGameClientHolderID(uint256 _holderID, uint256 _newID) public {
        require(ownerOf(_holderID) == msg.sender, "Only the ID owner can update the ID");
        _holders[_holderID].gameClientHolderID = _newID;
        emit gameClientHolderIDUpdated(_holderID, _newID);
    }

    function setHolderName(uint256 _holderID, string memory _newName) public {
        require(ownerOf(_holderID) == msg.sender, "Only the ID owner can update the name");
        _holders[_holderID].holderName = _newName;
        emit holderNameUpdated(_holderID, _newName);
    }

    function pauseCampaign(uint256 _holderID) public {
        _holders[_holderID].paused = true;  
    }

    function unpauseCampaign(uint256 _holderID) public {
        _holders[_holderID].paused = false;
    }

    function campaignPaused(uint256 _holderID) public view returns (bool){
        return _holders[_holderID].paused == true;
    }

    //Game Functions

    function addGame(uint256 _gameINFO, uint256 value) public {
        _games[_gameINFO].gameCount += value;
    }

    function setGamePrompt(uint256 _gameINFO, string memory _newPrompt) public {
        require(ownerOf(_gameINFO) == msg.sender, "Only the game owner can set the prompt");
        _games[_gameINFO].gamePrompt = _newPrompt;
        emit gamePromptUpdated(_gameINFO, _newPrompt);
    }

    function setGameOwner(uint256 _gameINFO, string memory _newOwner) public {
        require(ownerOf(_gameINFO) == msg.sender, "Only the game owner is allowed");
        _games[_gameINFO].gameOwner = _newOwner;
        emit gameOwnerUpdated(_gameINFO, _newOwner);
    }

    function setWalletAddress(uint256 _gameINFO, address _newWallet) public {
        require(ownerOf(_gameINFO) == msg.sender, "Only the game owner can update the wallet");
        _games[_gameINFO].wallet = payable(_newWallet);
        emit walletAddressUpdated(_gameINFO, _newWallet);
    }

    function setGameName(uint256 _gameINFO, string memory _newName) public {
        require(ownerOf(_gameINFO) == msg.sender, "Only the game owner can update the name");
        _games[_gameINFO].gameName = _newName;
        emit gameNameUpdated(_gameINFO, _newName);
    }

    function pauseGame(uint256 _gameINFO) public {
        _games[_gameINFO].paused = true;  
    }

    function unpauseGame(uint256 _gameINFO) public {
        _games[_gameINFO].paused = false;
    }

    function gamePaused(uint256 _gameINFO) public view returns (bool){
        return _games[_gameINFO].paused == true;
    }

    function viewBallance(uint256 _gameINFO) public view returns(uint256) {
        return _games[_gameINFO].wallet.balance;
    }

    function withdrawRevenue(uint256 _gameINFO) public payable onlyOwner {
        uint256 balance = _games[_gameINFO].wallet.balance;
        _games[_gameINFO].wallet.transfer(balance);
    }

    // Function to mint an NFT using ID
 
    function mintHolderNFT(uint256 _holdersID) public {
        // Get campaign data
        HolderDatainfo memory holderInfo = _holders[_holdersID];

        // Mint NFT
        uint256 tokenId = holderInfo.gameClientHolderID;
        _safeMint(msg.sender, tokenId); // Minting the NFT

        // Emit event
        emit NFTMinted(msg.sender, tokenId, ""); // Assuming the tokenURI is empty for now
    }
}
