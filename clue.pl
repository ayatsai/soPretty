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
:- dynamic unknownCard/2.


clue :- setup, !, playGame.

/* Setup Game */

% set number of players
% set cards on hand
% set starting player
setup :- resetAll, !, getNumPlayers, !, getStartingCards, !, getStartingPlayerTurn.
getNumPlayers :- println('How many people are playing?'), read(X), assert(playernum(X)).

% get cards on hand
getStartingCards :- println('What cards are in your hand? Enter done. when you are finished.'), read(X), getStartingCardsLoop(X).
% recorded all cares
getStartingCardsLoop(done).
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
resetAll :- retractall(knownCard(_,_)), retractall(playernum(_)).


/* Initialize Game Components */

% add all possible cards
card(X) :- unknownCard(X,_).
card(X) :- knownCard(X,_).
card(_) :- println('Card does not exist').

% initialize all rooms
unknownCard(kitchen, room).
unknownCard(patio, room).
unknownCard(spa, room).
unknownCard(theatre, room).
unknownCard(livingroom, room).
unknownCard(observatory, room).
unknownCard(hall, room).
unknownCard(guesthouse, room).
unknownCard(diningroom, room).
% initialize all weapons
unknownCard(knife, weapon).
unknownCard(candlestick, weapon).
unknownCard(pistol, weapon).
unknownCard(rope, weapon).
unknownCard(bat, weapon).
unknownCard(axe, weapon).
% initialize all persons
unknownCard(mustard, person).
unknownCard(scarlet, person).
unknownCard(plum, person).
unknownCard(green, person).
unknownCard(white, person).
unknownCard(peacock, person).


/* Game Play */
playGame :- currentPlayer(X), checkState(X), !.

% my turn
% add playGame call
checkState(X) :- X is 0, nextPlayer(X).

% add playGame call
% other player turn
checkState(X) :- X =\= 0, nextPlayer(X).



/* Game Mechanics */

% Player Turn Operations
nextPlayer(X) :- playernum(Y), X >= Y, Z is 0, setPlayerTurn(Z).
nextPlayer(X) :- Z is X + 1, setPlayerTurn(Z).
setPlayerTurn(X) :- retractall(currentPlayer(_)), assert(currentPlayer(X)).

% Record Data Operations
addKnownCard(X) :- retract(unknownCard(X, Y)), assert(knownCard(X, Y)). 

/* Output Database Operations */

printAllCards :- printAllKnownCards, printAllUnknownCards.
printAllUnknownCards :- printUnknownTitle, printAllUnknownRooms, printAllUnknownWeapons, printAllUnknownPeople.
printAllKnownCards :- printKnownTitle, printAllKnownRooms, printAllKnownWeapons, printAllKnownPeople.

printAllUnknownRooms :- printRoomsTitle, forall(unknownCard(X, room), println(X)), nl.
printAllUnknownWeapons :- printWeaponsTitle, forall(unknownCard(X, weapon), println(X)), nl.
printAllUnknownPeople :- printPeopleTitle, forall(unknownCard(X, person), println(X)), nl.

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
