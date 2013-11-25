% Clue Project

/*
 * Chin-Tsai Tsai  42698100
 * Wesley Tsai     44396109
 */
 
% Notes
% documentation on the works
% easy to use interface

/*
 * Set-Up
 */

% dynamic function initialize
:- dynamic innocentroom/1.
:- dynamic innocentweapon/1.
:- dynamic innocentperson/1.


% Order of Play (whose turn next) - idk why we need this


% number of players
% Cards On Hand
setup(PlayerNum, COH) :- assert(playernum(PlayerNum)), innocent(COH).

% will add all rooms, weapons, persons if called with no input
% should restrict usage
innocent(NG) :- validateroom(NG), assert(innocentroom(NG)).
innocent(NG) :- validateweapon(NG), assert(innocentweapon(NG)).
innocent(NG) :- validateperson(NG), assert(innocentperson(NG)).

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

% Track Suggestions
% Record Learned Data
% Make Accusations

% See Database Contents
seeinnocent(A) :- innocentroom(A).
seeinnocent(A) :- innocentweapon(A).
seeinnocent(A) :- innocentperson(A).

/*
 * Advanced GamePlay
 */
 
% Suggestions Inferred by Other Players
% Suggest Next Suggestion
%	- based on location?
% Suggest Card to Show
%	- show already showed card

% Advance GamePlay
% Assess How Close Others are to Winning
%	- heuristics: known information count?
% Advice Suggestions for Tricking Others 
%	- make accusations of own card
