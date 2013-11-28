% Clue Project

/*
 * Chin-Tsai Tsai  42698100
 * Wesley Tsai     44396109
 */


/*
 * Notes
 */
 
/* documentation on the works */
/* easy to use interface */


/*
 * Set-Up
 */

/* dynamic function initialize */
:- dynamic knownCard/2.
:- dynamic unknownCard/2.
:- dynamic playernum/1.
:- dynamic currentPlayer/1.
:- dynamic innocentroom/1.
:- dynamic innocentweapon/1.
:- dynamic innocentperson/1.
:- dynamic owncards/1.
:- dynamic suggestions/3.
:- dynamic suggestionsbyothers/4.

clue :- setup, !, startGame.

/* initialize game */
% number of players
% Cards On Hand
setup :- resetAll, !, getNumPlayers, !, getStartingCards, !, getStartingPlayerTurn.
getNumPlayers :- println('How many people are playing?'), read(X), assert(playernum(X)).

getStartingCards :- println('What cards are in your hand? Enter done. when you are finished.'), read(X), getStartingCardsLoop(X).
getStartingCardsLoop(done).
getStartingCardsLoop(X) :- card(X), addKnownCard(X), read(Y), getStartingCardsLoop(Y).
getStartingCardsLoop(X) :- read(Y), getStartingCardsLoop(Y).

getStartingPlayerTurn :- println('Whos turn is it? (Player 0 is on your left if going clockwise'), read(X), getStartingPlayerTurnLoop(X).
getStartingPlayerTurnLoop(X) :- playernum(Y), X >= Y, getStartingPlayerTurn.
getStartingPlayerTurnLoop(X) :- playernum(Y), X < 0, getStartingPlayerTurn.
getStartingPlayerTurnLoop(X) :- setPlayerTurn(X), println(lol).

resetAll :- retractall(knownCard(_,_)), retractall(playernum(_)).

% Card adding operations
addKnownCard(X) :- retract(unknownCard(X, Y)), assert(knownCard(X, Y)). 
setPlayerTurn(X) :- retractall(currentPlayer(_)), assert(currentPlayer(X)).

startGame.
% initialize game components
card(X) :- unknownCard(X,_).
card(X) :- knownCard(X,_).
card(_) :- println('Card does not exist').

unknownCard(kitchen, room).
unknownCard(patio, room).
unknownCard(spa, room).
unknownCard(theatre, room).
unknownCard(livingroom, room).
unknownCard(observatory, room).
unknownCard(hall, room).
unknownCard(guesthouse, room).
unknownCard(diningroom, room).

unknownCard(knife, weapon).
unknownCard(candlestick, weapon).
unknownCard(pistol, weapon).
unknownCard(rope, weapon).
unknownCard(bat, weapon).
unknownCard(axe, weapon).

unknownCard(mustard, person).
unknownCard(scarlet, person).
unknownCard(plum, person).
unknownCard(green, person).
unknownCard(white, person).
unknownCard(peacock, person).

unknownboolean(1).
unknownboolean(0).

printAllCards :- printAllRooms, printSeparator, printAllWeapons, printSeparator, printAllPerson.
printAllRooms :- forall(unknownCard(X, room), println(X)).
printAllWeapons :- forall(unknownCard(X, weapon), println(X)).
printAllPerson :- forall(unknownCard(X, person), println(X)).

println(X) :- write(X), nl.
printSeparator :- write(================================================), nl.
/*
 * Minimal GamePlay
 */

/* See Database Contents */
% implement for all as necessary

/* Track Suggestions */

% make suggestion
% restrict usage
suggest(ROOM, WEAPON, PERSON) :- 
	unknownCard(ROOM), 
	unknownCard(WEAPON), 
	unknownCard(PERSON), 
	assert(suggestions(ROOM, WEAPON, PERSON)).

% output all suggestions of check if already suggested
checksuggestion(ROOM, WEAPON, PERSON) :- 
	suggestions(ROOM, WEAPON, PERSON).

/* Record Learned Data */

% Record own cards
% restrict usage
addowncardsiterator([H|T]) :- addowncards(H), addowncardsiterator(T).
addowncardsiterator([]).
addowncards(NG) :- unknownCard(NG), assert(owncards(NG)).
addowncards(NG) :- unknownCard(NG), assert(owncards(NG)).
addowncards(NG) :- unknownCard(NG), assert(owncards(NG)).
addowncards([]).

% Record innocent objects
% restrict usage
innocentiterator([H|T]) :- innocent(H), innocentiterator(T).
innocentiterator([]).
innocent(NG) :- unknownCard(NG), assert(innocentroom(NG)).
innocent(NG) :- unknownCard(NG), assert(innocentweapon(NG)).
innocent(NG) :- unknownCard(NG), assert(innocentperson(NG)).
innocent([]).

% output known innocent objects
seeinnocent(A) :- innocentroom(A).
seeinnocent(A) :- innocentweapon(A).
seeinnocent(A) :- innocentperson(A).

/* Make Accusations */
accusations(ROOM, WEAPON, PERSON) :- 
	unknownCard(ROOM), \+innocentroom(ROOM),
	unknownCard(WEAPON), \+innocentweapon(WEAPON),
	unknownCard(PERSON), \+innocentperson(PERSON).



/*
 * Intermediate GamePlay
 */

/* Suggestions Inferred by Other Players */
% refute - (1) is refuted, (0) is undeterred
% should modify heuristics (based on occurrence?)
% restrict usage
suggestbyothers(ROOM, WEAPON, PERSON, REFUTE) :- 
	unknownCard(ROOM), 
	unknownCard(WEAPON), 
	unknownCard(PERSON),
	unknownboolean(REFUTE),
	assert(suggestionsbyothers(ROOM, WEAPON, PERSON, REFUTE)).

% output all suggestions of check if already suggested
checksuggestionsbyothers(ROOM, WEAPON, PERSON, REFUTE) :- 
	suggestionsbyothers(ROOM, WEAPON, PERSON, REFUTE).
getfalsesuggestionsbyothers(ROOM, WEAPON, PERSON) :-
	suggestionsbyothers(ROOM, WEAPON, PERSON, 1).
getunprovensuggestionsbyothers(ROOM, WEAPON, PERSON) :-
	suggestionsbyothers(ROOM, WEAPON, PERSON, 0).

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
