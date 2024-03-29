% Clue Project

/*
 * Chin-Tsai Tsai  42698100
 * Wesley Tsai     44396109
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
% my cards
:- dynamic myCards/1.
% list of shown cards to other players
:- dynamic oppShownCard/2.
% list of possible card to show
:- dynamic oppToShow/2.

clue :- setup, !, playGame.

/* Setup Game */

% set number of players
% set cards on hand
% set starting player
setup :- resetAll, !, getNumPlayers, !, getStartingCards, !, getStartingPlayerTurn.
getNumPlayers :- println('How many people are playing?'), read(X), nl, assert(playernum(X)).

% get cards on hand
getStartingCards :- println('What cards are in your hand? Enter done. when you are finished. (done; status)'), read(X), getStartingCardsLoop(X).
% recorded all cares
getStartingCardsLoop(done) :- nl.
% print the status of all cards
getStartingCardsLoop(status) :- printAllCards, read(Y), getStartingCardsLoop(Y).
% valid card, record and ask for more 
getStartingCardsLoop(X) :- card(X), addKnownCard(X),assert(myCards(X)), read(Y), getStartingCardsLoop(Y).
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
	X > Y - 1, 
	getStartingPlayerTurn.
% invalid player index input
getStartingPlayerTurnLoop(X) :- 
	X < 0, 
	getStartingPlayerTurn.
% valid player index, record
getStartingPlayerTurnLoop(X) :- 
	nl, setPlayerTurn(X).

% delete database
resetAll :- retractall(knownCard(_,_)), 
	retractall(unknownCard(_,_,_)),
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
checkState(X) :- X =:= 0, myTurn, nextPlayer(X), playGame.

% add playGame call
% other player turn
checkState(X) :- X =\= 0, oppTurn, nextPlayer(X), playGame.


/* Game Mechanics */

% Player Turn Operations
nextPlayer(X) :- playernum(Y), X >= Y-1, Z is 0, setPlayerTurn(Z).
nextPlayer(X) :- Z is X + 1, setPlayerTurn(Z).
setPlayerTurn(X) :- retractall(currentPlayer(_)), assert(currentPlayer(X)).

% Record Data Operations

% track cards shown to me
addKnownCard(X) :- unknownCard(X, Y, _), retractall(unknownCard(X, Y, _)), assert(knownCard(X,Y)).
% increment heuristics of unknown cards
incHeuristics(X) :- knownCard(X, _).
incHeuristics(X) :- 
	unknownCard(X, Y, H), 
	retract(unknownCard(X, Y, H)), 
	HI is H + 1,
	assert(unknownCard(X, Y, HI)).
addShownCard(X) :- currentPlayer(P), assert(oppShownCard(X, P)).

% find card with lowest huristic of Type
lowestHeuristic(X, Type) :- 
	unknownCard(X,Type,H1),
	\+ (unknownCard(Y,Type,H2), Y \= X, H2 < H1).

% Win/Loss
win :- println('Looks like you\'ve won. Congratulations!'), break.
lose :- println('You lost? Better luck next time!'), break.


/* My Turn Mechanics */
myTurn :- println('Your Turn'), myClosestRoom.

% Ask what room is closest and check whether it's already known
myClosestRoom :- println('What is the closest room to you? (status)'), read(X), nl, myCheckRoomUnknown(X). 
myCheckRoomUnknown(status) :- printAllCards, myClosestRoom.
myCheckRoomUnknown(X) :- unknownCard(X, room, _), println('That room has not been confirmed. Go to it!'), retractall(myClosestRoomIs(X)), assert(myClosestRoomIs(X)), !, myInRoom.
myCheckRoomUnknown(X) :- knownCard(X,room), println('You have already been to that room, enter the next closest.'), myClosestRoom. 
myCheckRoomUnknown(_) :- println('Invalid Input. Try Again.'), myClosestRoom. 

% Ask whether player is in the room yet, if yes, move on to suggesting cards, if no, move on to next player's turn
myInRoom :- write('Are you in the '), myClosestRoomIs(X), write(X), write(' yet? (y/n)'), nl, read(Y), nl, myInRoomResponse(Y).
myInRoomResponse(y) :- mySuggestCards.
myInRoomResponse(n) :- println('Go there.'), nl.
myInRoomResponse(_) :- println('Not a valid input.'), myInRoom.

% Give card suggestions, ask which card is shown.
% Uses the card with the lowest heuristic as suggestion (least asked card)
mySuggestCards :- println('Suggest these cards: '), 
	myClosestRoomIs(Room), println(Room), 
	lowestHeuristic(X, weapon), unknownCard(X, weapon, _), println(X), 
	lowestHeuristic(Y, person), unknownCard(Y, person, _), println(Y), 
	retractall(myClosestRoomIs(_)), nl, myQueryShownCard.

% Add shown card to the database
myQueryShownCard :- println('Which card were you shown? (status; none; win)'), read(X), nl, myAddShownCard(X).
myAddShownCard(status) :- printAllCards, myQueryShownCard.
myAddShownCard(none) :- win.
myAddShownCard(win) :- win.
myAddShownCard(X) :- unknownCard(X,_,_), addKnownCard(X).
myAddShownCard :- println('Not a valid input. Try Again.'), myQueryShownCard.

/* Opponent Turn Mechanics */

oppTurn :- oppGetSuggestion.
% get suggestion made by player if any
oppGetSuggestion :- 
	write('Did player '),
	currentPlayer(Player),
        write(Player),
	write(' make a suggestion? (n for no; input card name; status; lose)'), 
	nl, 
	read(X),
	oppGetSuggestionCheck(X).
% check if player suggested
oppGetSuggestionCheck(lose) :- lose.
oppGetSuggestionCheck(status) :- status, oppGetSuggestion.
oppGetSuggestionCheck(n).
oppGetSuggestionCheck(X) :- oppRecordSuggestionLoop(X, 3).
% record the three objects suggested
oppRecordSuggestionLoop(X, I) :- I is 1, incHeuristics(X), oppTrackSuggestion(X), oppGetShownCard.
oppRecordSuggestionLoop(X, I) :- card(X), incHeuristics(X), oppTrackSuggestion(X), read(Y), IN is I - 1, oppRecordSuggestionLoop(Y, IN).
oppRecordSuggestionLoop(_, I) :- read(Y), oppRecordSuggestionLoop(Y, I).

oppGetShownCard :- 
	println('Do you need to show a card? (y/n)'),
	read(X),
	oppReturnShownCard(X).

oppReturnShownCard(y) :- oppGetCardToShow(X), print('Show this card: '), println(X), retractall(oppToShow(_,_)), addShownCard(X).
oppReturnShownCard(y) :- println('Cannot refute'), retractall(oppToShow(_,_)).
oppReturnShownCard(n) :- retractall(oppToShow(_)).

% change card to show
% already shown card to this opponent
oppTrackSuggestion(X) :- currentPlayer(Y), oppShownCard(X, Y), assert(oppToShow(X, 3)).
% card already shown to someone
oppTrackSuggestion(X) :- oppShownCard(X, _), assert(oppToShow(X, 2)).
% have card but shown no one
oppTrackSuggestion(X) :- myCards(X), assert(oppToShow(X, 1)).
% not a match
oppTrackSuggestion(_).

oppGetCardToShow(X) :- oppToShow(X, 3).
oppGetCardToShow(X) :- oppToShow(X, 2).
oppGetCardToShow(X) :- oppToShow(X, 1).


/* Output Database Operations */
status :- printAllCards.
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

printUnknownTitle :- println('       *** Unknown Cards ***').
printKnownTitle :- println('        *** Known Cards ***').
printRoomsTitle :- println('*==============Rooms==============*'), nl.
printWeaponsTitle :- println('*=============Weapons=============*'), nl.
printPeopleTitle :- println('*=============Suspects============*'), nl.
