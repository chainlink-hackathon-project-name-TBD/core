pragma solidity 0.8.4;

//This contract is a log of the created events

contract EventLog {
    // all events ever created are stored in these structures
    uint256 s_numberOfEvents;
    uint256[] s_eventIds;
    mapping(uint256 => Event) s_events; // s_eventId => Event

    // every user events are stored as userAddress => Event
    mapping(address => uint256[]) s_registeredEvents;
    mapping(address => uint256[]) s_createdEvents;

    // the winners of each event are stored as s_eventId => userAddress => true
    mapping(uint256 => mapping(address => bool)) s_winners;

    struct Event {
        address eventGameAddress;
        address eventOwner;
        string eventName;
        uint256 numberOfTickets;
        uint256 ticketPrice;
        bool isOpen;
    }

    constructor() {
        s_numberOfEvents = 0;
    }

    function _logEvent(
        uint256 _eventId,
        address _eventGameAddress,
        address _eventOwner,
        string memory _eventName,
        uint256 _numberOfTickets,
        uint256 _ticketPrice
    ) external {
        s_events[_eventId] = Event(
            _eventGameAddress,
            _eventOwner,
            _eventName,
            _numberOfTickets,
            _ticketPrice,
            true
        );
        s_numberOfEvents += 1;
        s_eventIds.push(_eventId);
    }

    function _updateName(uint256 _eventId, string memory _newName) external {
        s_events[_eventId].eventName = _newName;
    }

    function _updateTickets(uint256 _eventId, uint256 _newTickets) external {
        s_events[_eventId].numberOfTickets = _newTickets;
    }

    function _updatePrice(uint256 _eventId, uint256 _newPrice) external {
        s_events[_eventId].ticketPrice = _newPrice;
    }

    function _closeEvent(uint256 _eventId) external {
        s_events[_eventId].isOpen = false;
    }

    function getEventAddress(uint256 _eventId) public view returns (address) {
        return s_events[_eventId].eventGameAddress;
    }

    function getOpenEvents() public view returns (Event[] memory) {
        uint256 availableLength = 0;
        for (uint256 i = 0; i < s_numberOfEvents; i++) {
            if (s_events[i].isOpen == true) {
                availableLength += 1;
            }
        }

        Event[] memory openEvents = new Event[](availableLength);
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < s_numberOfEvents; i++) {
            if (s_events[i].isOpen == true) {
                openEvents[currentIndex] = s_events[i];
                currentIndex += 1;
            }
        }
        return openEvents;
    }

    function _addRegisteredEvent(address _userAddress, uint256 _eventId)
        external
    {
        //this visibility must be protected
        s_registeredEvents[_userAddress].push(_eventId);
    }

    function getRegisteredEvents(address _userAddress)
        public
        view
        returns (Event[] memory)
    {
        uint256[] memory registeredEvents = s_registeredEvents[_userAddress];
        uint256 availableLength = registeredEvents.length;
        Event[] memory registeredEventsStruct = new Event[](availableLength);
        for (uint256 i = 0; i < availableLength; i++) {
            uint256 eventId = registeredEvents[i];
            Event memory newEvent = s_events[eventId];
            registeredEventsStruct[i] = newEvent;
        }
        return registeredEventsStruct;
    }

    function _addCreatedEvent(address _userAddress, uint256 _eventId) external {
        //this visibility must be protected
        s_createdEvents[_userAddress].push(_eventId);
    }

    function getCreatedEvents(address _userAddress)
        public
        view
        returns (Event[] memory)
    {
        uint256[] memory createdEvents = s_createdEvents[_userAddress];
        uint256 availableLength = createdEvents.length;
        Event[] memory createdEventsStruct = new Event[](availableLength);
        for (uint256 i = 0; i < availableLength; i++) {
            uint256 eventId = createdEvents[i];
            Event memory newEvent = s_events[eventId];
            createdEventsStruct[i] = newEvent;
        }
        return createdEventsStruct;
    }

    function _addWinner(uint256 _eventId, address _winner) external {
        //this visibility must be protected
        s_winners[_eventId][_winner] = true;
    }
}
