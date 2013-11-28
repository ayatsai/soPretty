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
% list of shown cards to other players
:- dynamic shownCard/2.


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
% valid player index, record
getStartingPlayerTurnLoop(X) :- 
	setPlayerTurn(X).

% delete database
resetAll :- retractall(knownCard(_,_)), retractall(playernum(_)).


/* Initialize Game Components */

% add all possible cards
card(X) :- unknownCard(X,_,_).
card(X) :- knownCard(X,_).
card(_) :- println('Card does not exist').

% initialize all rooms
unknownCard(kitchen, room, 0).
unknownCard(patio, room, 0).
unknownCard(spa, room, 0).
unknownCard(theatre, room, 0).
unknownCard(livingroom, room, 0).
unknownCard(observatory, room, 0).
unknownCard(hall, room, 0).
unknownCard(guesthouse, room, 0).
unknownCard(diningroom, room, 0).
% initialize all weapons
unknownCard(knife, weapon, 0).
unknownCard(candlestick, weapon, 0).
unknownCard(pistol, weapon, 0).
unknownCard(rope, weapon, 0).
unknownCard(bat, weapon, 0).
unknownCard(axe, weapon, 0).
% initialize all persons
unknownCard(mustard, person, 0).
unknownCard(scarlet, person, 0).
unknownCard(plum, person, 0).
unknownCard(green, person, 0).
unknownCard(white, person, 0).
unknownCard(peacock, person, 0).


/* Game Play */
playGame :- currentPlayer(X), checkState(X), !.

% my turn
% add playGame call
checkState(X) :- X =:= 0, myTurn, nextPlayer(X).

% add playGame call
% other player turn
checkState(X) :- X =\= 0, oppGetSuggestion, nextPlayer(X), playGame.
% get suggestion made by player if any
oppGetSuggestion :- 
	println('Did opponent make a suggestion?'), 
	println('Enter done if no suggestions.'),
	println('Otherwise input each card one by one'),
	read(X),
	oppGetSuggestionCheck(X).
% check if player suggested
oppGetSuggestionCheck(done).
oppGetSuggestionCheck(X) :- oppRecordSuggestionLoop(X, 3).
% record the three objects suggested
oppRecordSuggestionLoop(X, I) :- I is 1, incHeuristics(X), oppGetShownCard.
oppRecordSuggestionLoop(X, I) :- card(X), incHeuristics(X), read(Y), IN is I - 1, oppRecordSuggestionLoop(Y, IN).
oppRecordSuggestionLoop(_, I) :- read(Y), oppRecordSuggestionLoop(Y, I).

oppGetShownCard :- 
	println('Did you show a card?'),
	println('If not, input done.'),
	println('Else, input card.'),
	read(X),
	oppRecordShownCard(X).

oppRecordShownCard(done).
oppRecordShownCard(X) :- card(X), addShownCard(X).
oppRecordShownCard(_) :- read(Y), oppRecordShownCard(Y).


/* Game Mechanics */

% Player Turn Operations
nextPlayer(X) :- playernum(Y), X >= Y, Z is 0, setPlayerTurn(Z).
nextPlayer(X) :- Z is X + 1, setPlayerTurn(Z).
setPlayerTurn(X) :- retractall(currentPlayer(_)), assert(currentPlayer(X)).

% Record Data Operations
% track cards shown to me
addKnownCard(X) :- retract(unknownCard(X, Y, _)), assert(knownCard(X, Y)). 
% increment heuristics of unknown cards
incHeuristics(X) :- knownCard(X, _).
incHeuristics(X) :- 
	unknownCard(X, Y, H), 
	retract(unknownCard(X, Y, H)), 
	HI is H + 1,
	assert(unknownCard(X, Y, HI)).
addShownCard(X) :- currentPlayer(P), assert(shownCard(X, P)).


/* My Turn Mechanics */
myTurn :- println('Your Turn'), myClosestRoom.

% Ask what room is closest and check whether it's already known
myClosestRoom :- println('What is the closest room to you?'), read(X), myCheckRoomUnknown(X). 
myCheckRoomUnknown(X) :- unknownCard(X, room, _), println('That room has not been confirm, check it out!'), myInRoom.
myCheckRoomUnKnown(X) :- knownCard(X, room), println('You have already been to that room, do not go in'), myClosestRoom. 

myInRoom.
/* Output Database Operations */

printAllCards :- printAllKnownCards, printAllUnknownCards.
printAllUnknownCards :- printUnknownTitle, printAllUnknownRooms, printAllUnknownWeapons, printAllUnknownPeople.
printAllKnownCards :- printKnownTitle, printAllKnownRooms, printAllKnownWeapons, printAllKnownPeople.

printAllUnknownRooms :- printRoomsTitle, forall(unknownCard(X, room, H), printlist([X,H])), nl.
printAllUnknownWeapons :- printWeaponsTitle, forall(unknownCard(X, weapon, H), printlist([X,H])), nl.
printAllUnknownPeople :- printPeopleTitle, forall(unknownCard(X, person, H), printlist([X,H])), nl.

printAllKnownRooms :- printRoomsTitle, forall(knownCard(X, room), println(X)), nl.
printAllKnownWeapons :- printWeaponsTitle, forall(knownCard(X, weapon), println(X)), nl.
printAllKnownPeople :- printPeopleTitle, forall(knownCard(X, person), println(X)), nl.

printlist([]) :- nl.
printlist([H|T]) :- write(H), tab(3), printlist(T).
println(X) :- write(X), nl.

printUnknownTitle :- println('         ***Unknown Cards***').
printKnownTitle :- println('           ***Known Cards***').
printRoomsTitle :- println('*==============Rooms==============*'), nl.
printWeaponsTitle :- println('*=============Weapons=============*'), nl.
printPeopleTitle :- println('*=============Suspects============*'), nl.

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
