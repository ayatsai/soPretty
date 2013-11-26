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
:- dynamic playernum/1.
:- dynamic innocentroom/1.
:- dynamic innocentweapon/1.
:- dynamic innocentperson/1.
:- dynamic owncards/1.
:- dynamic suggestions/3.
:- dynamic suggestionsbyothers/4.


/* initialize game */
% number of players
% Cards On Hand
setup(PlayerNum, COH) :- 
	assert(playernum(PlayerNum)), 
	addowncardsiterator(COH),
	innocentiterator(COH).

/* Order of Play (whose turn next) - idk why we need this */
% input list of players in playing order
% with last player first in list
% ?? use for guessing their cards + estimating how close they are to winning
addplayers(P) :- playernum(PN), addplayershelper(P, PN).
addplayershelper([H|T], PN) :- 
	addplayershelper(T, PN1),
	PN is PN1 + 1,
	assert(player(H, PN)).
addplayershelper([], 0).
getplayer(P, I) :- player(P, I).

% initialize game components
validateroom('kitchen').
validateroom('patio').
validateroom('spa').
validateroom('theatre').
validateroom('living room').
validateroom('observatory').
validateroom('hall').
validateroom('guest house').
validateroom('dining room').

validateweapon('knife').
validateweapon('candlestick').
validateweapon('pistol').
validateweapon('rope').
validateweapon('bat').
validateweapon('ax').

validateperson('colonel mustard').
validateperson('miss scarlet').
validateperson('professor plum').
validateperson('mr. green').
validateperson('mrs. white').
validateperson('mrs. peacock').

validateboolean(1).
validateboolean(0).


/*
 * Minimal GamePlay
 */

/* See Database Contents */
% implement for all as necessary

/* Track Suggestions */

% make suggestion
% restrict usage
suggest(ROOM, WEAPON, PERSON) :- 
	validateroom(ROOM), 
	validateweapon(WEAPON), 
	validateperson(PERSON), 
	assert(suggestions(ROOM, WEAPON, PERSON)).

% output all suggestions of check if already suggested
checksuggestion(ROOM, WEAPON, PERSON) :- 
	suggestions(ROOM, WEAPON, PERSON).

/* Record Learned Data */

% Record own cards
% restrict usage
addowncardsiterator([H|T]) :- addowncards(H), addowncardsiterator(T).
addowncardsiterator([]).
addowncards(NG) :- validateroom(NG), assert(owncards(NG)).
addowncards(NG) :- validateweapon(NG), assert(owncards(NG)).
addowncards(NG) :- validateperson(NG), assert(owncards(NG)).
addowncards([]).

% Record innocent objects
% restrict usage
innocentiterator([H|T]) :- innocent(H), innocentiterator(T).
innocentiterator([]).
innocent(NG) :- validateroom(NG), assert(innocentroom(NG)).
innocent(NG) :- validateweapon(NG), assert(innocentweapon(NG)).
innocent(NG) :- validateperson(NG), assert(innocentperson(NG)).
innocent([]).

% output known innocent objects
seeinnocent(A) :- innocentroom(A).
seeinnocent(A) :- innocentweapon(A).
seeinnocent(A) :- innocentperson(A).

/* Make Accusations */
accusations(ROOM, WEAPON, PERSON) :- 
	validateroom(ROOM), \+innocentroom(ROOM),
	validateweapon(WEAPON), \+innocentweapon(WEAPON),
	validateperson(PERSON), \+innocentperson(PERSON).



/*
 * Intermediate GamePlay
 */

/* Suggestions Inferred by Other Players */
% refute - (1) is refuted, (0) is undeterred
% should modify heuristics (based on occurrence?)
% restrict usage
suggestbyothers(ROOM, WEAPON, PERSON, REFUTE) :- 
	validateroom(ROOM), 
	validateweapon(WEAPON), 
	validateperson(PERSON),
	validateboolean(REFUTE),
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
