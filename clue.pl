% Clue Project

/*
 * Chin-Tsai Tsai  42698100
 * Wesley Tsai     44396109
 */


/*
 * Reminders
 */
 
/* documentation on the works */
/* easy to use interface */


/*
 * Set-Up
 */

/* dynamic function initialize */
% number of players playing
:- dynamic playernum/1.
% index of current player
:- dynamic currentPlayer/1.
% list of innocent objects
:- dynamic knownCard/2.
% list of suspects
:- dynamic unknownCard/3.
% room player is closest to and should check.
:- dynamic myClosestRoomIs/1.


clue :- setup, !, playGame.

/* Setup Game */

% set number of players
% set cards on hand
% set starting player
setup :- resetAll, !, getNumPlayers, !, getStartingCards, !, getStartingPlayerTurn.
getNumPlayers :- println('How many people are playing?'), read(X), assert(playernum(X)).

% get cards on hand
getStartingCards :- println('What cards are in your hand? Enter done. when you are finished. (status)'), read(X), getStartingCardsLoop(X).
% recorded all cares
getStartingCardsLoop(done).
% print the status of all cards
getStartingCardsLoop(status) :- printAllCards.
% valid card, record and ask for more 
getStartingCardsLoop(X) :- card(X), addKnownCard(X), read(Y), getStartingCardsLoop(Y).
% invalid card, do nothing and ask for more
getStartingCardsLoop(_) :- read(Y), getStartingCardsLoop(Y).

% Get Starting Player Index
getStartingPlayerTurn :- 
	println('Whos turn is it? (Player after you is 1 and increment until current player, enter 0 for you)'), 
	read(X), 
	getStartingPlayerTurnLoop(X).
% invalid player index input
getStartingPlayerTurnLoop(X) :- 
	playernum(Y), 
	X > Y, 
	getStartingPlayerTurn.
% invalid player index input
getStartingPlayerTurnLoop(X) :- 
	X < 0, 
	getStartingPlayerTurn.
% valide player index, record
getStartingPlayerTurnLoop(X) :- 
	setPlayerTurn(X).

% delete database
resetAll :- retractall(knownCard(_,_)), 
	retractall(playernum(_)), 
	retractall(currentPlayer(_)), 
	retractall(myClosestRoomIs(_)),
	assertAllCards.


/* Initialize Game Components */

% add all possible cards
card(X) :- unknownCard(X,_,_).
card(X) :- knownCard(X,_).
card(_) :- println('Card does not exist').

% initialize all rooms
assertAllCards :-
	assert(unknownCard(kitchen, room, 0)),
	assert(unknownCard(patio, room, 0)),
	assert(unknownCard(spa, room, 0)),
	assert(unknownCard(theatre, room, 0)),
	assert(unknownCard(livingroom, room, 0)),
	assert(unknownCard(observatory, room, 0)),
	assert(unknownCard(hall, room, 0)),
	assert(unknownCard(guesthouse, room, 0)),
	assert(unknownCard(diningroom, room, 0)),
% initialize all weapons
	assert(unknownCard(knife, weapon, 0)),
	assert(unknownCard(candlestick, weapon, 0)),
	assert(unknownCard(pistol, weapon, 0)),
	assert(unknownCard(rope, weapon, 0)),
	assert(unknownCard(bat, weapon, 0)),
	assert(unknownCard(axe, weapon, 0)),
% initialize all persons
	assert(unknownCard(mustard, person, 0)),
	assert(unknownCard(scarlet, person, 0)),
	assert(unknownCard(plum, person, 0)),
	assert(unknownCard(green, person, 0)),
	assert(unknownCard(white, person, 0)),
	assert(unknownCard(peacock, person, 0)).


/* Game Play */
playGame :- currentPlayer(X), checkState(X), !.

% my turn
% add playGame call
checkState(X) :- X is 0, myTurn, nextPlayer(X).

% add playGame call
% other player turn
checkState(X) :- X =\= 0, myTurn, nextPlayer(X).



/* Game Mechanics */

% Player Turn Operations
nextPlayer(X) :- playernum(Y), X >= Y, Z is 0, setPlayerTurn(Z).
nextPlayer(X) :- Z is X + 1, setPlayerTurn(Z).
setPlayerTurn(X) :- retractall(currentPlayer(_)), assert(currentPlayer(X)).

% Record Data Operations
addKnownCard(X) :- retract(unknownCard(X, Y, _)), assert(knownCard(X, Y)). 

/* My Turn Mechanics */
myTurn :- myClosestRoom.

% Ask what room is closest and check whether it's already known
myClosestRoom :- myClosestRoomIs(_), myInRoom.
myClosestRoom :- println('What is the closest room to you? (status)'), read(X), nl, myCheckRoomUnknown(X). 
myCheckRoomUnknown(status) :- printAllCards, myClosestRoom.
myCheckRoomUnknown(X) :- unknownCard(X, room, _), println('That room has not been confirm, check it out!'), retractall(myClosestRoomIs(X)), assert(myClosestRoomIs(X)), !, myInRoom.
myCheckRoomUnknown(X) :- knownCard(X,room), println('You have already been to that room, enter the next closest.'), myClosestRoom. 
myCheckRoomUnknown(_) :- println('Invalid Input. Try Again.'), myClosestRoom. 

% Ask whether player is in the room yet, if yes, move on to suggesting cards, if no, move on to next player's turn
myInRoom :- write('Are you in the '), myClosestRoomIs(X), write(X), write(' yet? (y/n)'), nl, read(Y), nl, myInRoomResponse(Y).
myInRoomResponse(y) :- mySuggestCards.
myInRoomResponse(n) :- println('Go there.').
myInRoomResponse(_) :- println('Not a valid input.'), myInRoom.

% TODO: use the damn heuristics in unknownCard
% Give card suggestions, ask which card is shown.
mySuggestCards :- println('Suggest these cards: '), myClosestRoomIs(Room), println(Room), unknownCard(X, weapon, _), println(X), unknownCard(Y, person, _), println(Y), retractall(myClosestRoomIs(_)), nl, myQueryShownCard.

% Add shown card to the database
myQueryShownCard :- println('Which card were you shown? (status)'), read(X), nl, myAddShownCard(X).
myAddShownCard(status) :- printAllCards, myQueryShownCard.
myAddShownCard(none) :- println('Well then, you win! Congradulations!').
myAddShownCard(X) :- unknownCard(X,Type,_), retractall(unknownCard(X,_,_)), assert(knownCard(X, Type)).
myAddShownCard :- println('Not a valid input. Try Again.'), myQueryShownCard.

/* Output Database Operations */
status :- printAllCards.
printAllCards :- printAllKnownCards, printAllUnknownCards.
printAllUnknownCards :- printUnknownTitle, printAllUnknownRooms, printAllUnknownWeapons, printAllUnknownPeople.
printAllKnownCards :- printKnownTitle, printAllKnownRooms, printAllKnownWeapons, printAllKnownPeople.

printAllUnknownRooms :- printRoomsTitle, forall(unknownCard(X, room, _), println(X)), nl.
printAllUnknownWeapons :- printWeaponsTitle, forall(unknownCard(X, weapon, _), println(X)), nl.
printAllUnknownPeople :- printPeopleTitle, forall(unknownCard(X, person, _), println(X)), nl.

printAllKnownRooms :- printRoomsTitle, forall(knownCard(X, room), println(X)), nl.
printAllKnownWeapons :- printWeaponsTitle, forall(knownCard(X, weapon), println(X)), nl.
printAllKnownPeople :- printPeopleTitle, forall(knownCard(X, person), println(X)), nl.

println(X) :- write(X), nl.

printUnknownTitle :- println('       ***Unknown Cards***').
printKnownTitle :- println('        ***Known Cards***').
printRoomsTitle :- println('*=============Rooms===============*'), nl.
printWeaponsTitle :- println('*============Weapons=============*'), nl.
printPeopleTitle :- println('*============Suspects=============*'), nl.

/*
 * Minimal GamePlay
 */


/* Track Suggestions */

/* Make Accusations */

/*
 * Intermediate GamePlay
 */

/* Suggestions Inferred by Other Players */
% should modify heuristics (based on occurrence?)

/* Suggest Next Suggestion */
% based on location?

/* Suggest Card to Show */
% track shown cards

% show already showed card to same player


/*
 * Advanced GamePlay
 */

/* Assess How Close Others are to Winning */
% heuristics: known information count?

/* Advice Suggestions for Tricking Others  */
% make accusations of own card
