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
:- dynamic innocentroom/1.
:- dynamic innocentweapon/1.
:- dynamic innocentperson/1.
:- dynamic suggestions/1.


/* Order of Play (whose turn next) - idk why we need this */


/* initialize game */
% number of players
% Cards On Hand
setup(PlayerNum, COH) :- assert(playernum(PlayerNum)), innocent(COH).

% initialize game components
validateroom("kitchen").
validateroom("patio").
validateroom("spa").
validateroom("theatre").
validateroom("living room").
validateroom("observatory").
validateroom("hall").
validateroom("guest house").
validateroom("dining room").

validateweapon("knife").
validateweapon("candlestick").
validateweapon("pistol").
validateweapon("rope").
validateweapon("bat").
validateweapon("ax").

validateperson("colonel mustard").
validateperson("miss scarlet").
validateperson("professor plum").
validateperson("mr. green").
validateperson("mrs. white").
validateperson("mrs. peacock").


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
checksuggestion(ROOM, WEAPON, PERSON) :- suggestions(ROOM, WEAPON, PERSON).

/* Record Learned Data */

% Record innocent objects
% restrict usage
innocent(NG) :- validateroom(NG), assert(innocentroom(NG)).
innocent(NG) :- validateweapon(NG), assert(innocentweapon(NG)).
innocent(NG) :- validateperson(NG), assert(innocentperson(NG)).

% output known innocent objects
seeinnocent(A) :- innocentroom(A).
seeinnocent(A) :- innocentweapon(A).
seeinnocent(A) :- innocentperson(A).

/* Make Accusations */


/*
 * Intermediate GamePlay
 */

/* Suggestions Inferred by Other Players */
% modify heuristics of each

/* Suggest Next Suggestion */
% based on location?

/* Suggest Card to Show */
% show already showed card to same player

/*
 * Intermediate GamePlay
 */

/* Assess How Close Others are to Winning */
% heuristics: known information count?

/* Advice Suggestions for Tricking Others  */
% make accusations of own card