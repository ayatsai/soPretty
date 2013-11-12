oska_l8x7 :: [String] -> Char -> Int -> [String]
oska_l8x7 board player count = statesearch_l8x7 board player count


-- minimax agorithm
-- min and max flag:
-- max = 1
-- min = -1
statesearch_l8x7 :: [String] -> Char -> Int -> [String]
statesearch_l8x7 board player count = fst (statesearch_helper_l8x7 board player count  1 1)

statesearch_iterator_l8x7 :: [([String], Int)] -> Char -> Int -> Int -> [([String], Int)]
statesearch_iterator_l8x7 boards player count minmax
	| null boards								= []
	| otherwise									= [(statesearch_helper_l8x7 (fst (head boards)) player count minmax 0)] ++ 
												  (statesearch_iterator_l8x7 (tail boards) player count minmax)

-- if it is the first call to this function, start = 1
-- start flag used for checking whether the current board is 
-- the very top level
statesearch_helper_l8x7 :: [String] -> Char -> Int -> Int -> Int -> ([String], Int)
statesearch_helper_l8x7 board player count minmax start
	| start == 1 && count == 0 && minmax == 1	= getMaxHeuristics_l8x7 
													(generateNewStates_l8x7 board player player) 
													(board, (negate((length board) * (length board))))
	-- not needed if, this program should be called when 
	-- it is MAX's turn to move
	| start == 1 && count == 0 && minmax == -1	= getMinHeuristics_l8x7 
													(generateNewStates_l8x7 board (getOpponentMarker_l8x7 player) player) 
													(board, ((length board) * (length board)))
	| start == 1 && minmax == 1					= getMaxHeuristics_l8x7 
													(statesearch_iterator_l8x7 
														(generateNewStates_l8x7 board player player) 
														player 
														(count - 1) 
														(negate minmax))
													(board, (negate((length board) * (length board))))
	-- not needed if, this program should be called when 
	-- it is MAX's turn to move
	| start == 1 && minmax == -1				= getMinHeuristics_l8x7 
													(statesearch_iterator_l8x7 
														(generateNewStates_l8x7 board (getOpponentMarker_l8x7 player) player) 
														player 
														(count - 1) 
														(negate minmax)) 
													(board, ((length board) * (length board)))
	-- base case, for MAX's turn
	| count == 0 && minmax == 1					= (board, snd (getMaxHeuristics_l8x7 
													(generateNewStates_l8x7 board player player) 
													(board, (negate((length board) * (length board))))))
	-- base case, for MIN's turn
	| count == 0 && minmax == -1				= (board, snd (getMinHeuristics_l8x7 
													(generateNewStates_l8x7 board (getOpponentMarker_l8x7 player) player) 
													(board, ((length board) * (length board)))))
	| minmax == 1								= (board, snd (getMaxHeuristics_l8x7 
													(statesearch_iterator_l8x7 
														(generateNewStates_l8x7 board player player) 
														player 
														(count - 1) 
														(negate minmax))
													(board, (negate((length board) * (length board))))))
	| otherwise									= (board, snd (getMinHeuristics_l8x7 
													(statesearch_iterator_l8x7 
														(generateNewStates_l8x7 board (getOpponentMarker_l8x7 player) player) 
														player 
														(count - 1) 
														(negate minmax)) 
													(board, ((length board) * (length board)))))
	


getOpponentMarker_l8x7 :: Char -> Char
getOpponentMarker_l8x7 player
	| player == 'w'			= 'b'
	| otherwise				= 'w'
	
-- evalAs will always be the current player
-- player will change depending on whose move

-- generate all possible state different from the current state
generateNewStates_l8x7 :: [String] -> Char -> Char -> [([String], Int)]
generateNewStates_l8x7 board player evalAs
	| player == 'w' 			= filter 
								  (/= (board, evaluateBoard_l8x7 board evalAs))
						          (generateNewStatesIterator_l8x7 board player evalAs (getWhitePos_l8x7 board))
	| otherwise					= filter 
								  (/= (board, evaluateBoard_l8x7 board evalAs))
								  (generateNewStatesIterator_l8x7 board player evalAs (getBlackPos_l8x7 board))

								  -- iterate through each piece and move them
generateNewStatesIterator_l8x7 :: [String] -> Char -> Char -> [(Int, Int)] -> [([String], Int)]
generateNewStatesIterator_l8x7 board player evalAs pos
	| null pos				= []
	| otherwise				= 
		(generateNewStatesHelper_l8x7 board player evalAs (head pos)) ++ (generateNewStatesIterator_l8x7 board player evalAs (tail pos))

		-- return all possible moves for the current board and piece
generateNewStatesHelper_l8x7 :: [String] -> Char -> Char -> (Int,Int) -> [([String], Int)]
generateNewStatesHelper_l8x7 board player evalAs pos 
	| player == 'w'				= [(moveBL_l8x7 board player pos, evaluateBoard_l8x7 (moveBL_l8x7 board player pos) evalAs)] ++ 
								  [(moveBR_l8x7 board player pos, evaluateBoard_l8x7 (moveBR_l8x7 board player pos) evalAs)]
	| otherwise					= [(moveUL_l8x7 board player pos, evaluateBoard_l8x7 (moveUL_l8x7 board player pos) evalAs)] ++ 
								  [(moveUR_l8x7 board player pos, evaluateBoard_l8x7 (moveUR_l8x7 board player pos) evalAs)]


								  
-- get the max heuristics value from the list
getMaxHeuristics_l8x7 :: [([String], Int)] -> ([String], Int) -> ([String], Int)
getMaxHeuristics_l8x7 states best
	| null states							= best
	| (snd (head states)) > (snd best)		= getMaxHeuristics_l8x7 (tail states) (head states)
	| otherwise								= getMaxHeuristics_l8x7 (tail states) best
-- get the min heuristics value from the list
getMinHeuristics_l8x7 :: [([String], Int)] -> ([String], Int) -> ([String], Int)
getMinHeuristics_l8x7 states best
	| null states							= best
	| (snd (head states)) < (snd best)		= getMinHeuristics_l8x7 (tail states) (head states)
	| otherwise								= getMinHeuristics_l8x7 (tail states) best
	

	
-- heuristics
-- value			: description
-- +n^2				: own pieces are at the back of the opponent's end
-- -n^2				: opponent pieces are at the back of the own end
-- +n^2				: opponent pieces are removed
-- -n^2				: own pieces are removed
-- opponent - own	: steps to the end zone
-- ASSUME: w is always moving down
evaluateBoard_l8x7 :: [String] -> Char -> Int
evaluateBoard_l8x7 board player
	-- TODO return what for draw???
	| checkDraw_l8x7 board 						= ((length board) * (length board))
	| checkPlayerWin_l8x7 board player			= ((length board) * (length board))
	| checkOpponentWin_l8x7 board player			= negate ((length board) * (length board))
	| otherwise								= getOpponentDistance_l8x7 board player - getPlayerDistance_l8x7 board player

checkDraw_l8x7 :: [String] -> Bool
checkDraw_l8x7 board = (checkBothAtEndZone_l8x7 board) && ((length (getWhitePos_l8x7 board)) == (length (getBlackPos_l8x7 board)))

checkPlayerWin_l8x7 :: [String] -> Char -> Bool
checkPlayerWin_l8x7 board player 
	| player == 'w' && null (getWhitePos_l8x7 board)					= False
	| player == 'b' && null (getBlackPos_l8x7 board)					= False
	| player == 'w' && (checkBothAtEndZone_l8x7 board) && 
	  (length (getWhitePos_l8x7 board) > length (getBlackPos_l8x7 board)) = True
	| player == 'w' && (checkBothAtEndZone_l8x7 board) &&
	  (length (getBlackPos_l8x7 board) > length (getWhitePos_l8x7 board)) = False
	| player == 'b' && (checkBothAtEndZone_l8x7 board) &&
	  (length (getBlackPos_l8x7 board) > length (getWhitePos_l8x7 board)) = True
	| player == 'b' && (checkBothAtEndZone_l8x7 board) &&
	  (length (getBlackPos_l8x7 board) < length (getWhitePos_l8x7 board)) = False
	| player == 'w'	&& 
	  ((length (getBlackPos_l8x7 board)) == 0 || 
	  (checkEndZone_l8x7 (getWhitePos_l8x7 board) ((length board) - 1)))	= True
	| player == 'b'	&& 
	  ((length (getWhitePos_l8x7 board)) == 0 || 
	  (checkEndZone_l8x7 (getBlackPos_l8x7 board) 0))						= True
	| otherwise													= False

checkOpponentWin_l8x7 :: [String] -> Char -> Bool
checkOpponentWin_l8x7 board player
	| player == 'w'							= checkPlayerWin_l8x7 board 'b'
	| otherwise								= checkPlayerWin_l8x7 board 'w'
	
checkEndZone_l8x7 :: [(Int, Int)] -> Int -> Bool
checkEndZone_l8x7 pos n
	| null pos							= True
	| (snd (head pos)) == n				= checkEndZone_l8x7 (tail pos) n
	| otherwise							= False

checkBothAtEndZone_l8x7 :: [String] -> Bool
checkBothAtEndZone_l8x7 board = (checkEndZone_l8x7 (getWhitePos_l8x7 board) ((length board) - 1)) &&
								  (checkEndZone_l8x7 (getBlackPos_l8x7 board) 0)
	
getPlayerDistance_l8x7 :: [String] -> Char -> Int
getPlayerDistance_l8x7 board player
	| player == 'w'							= getDistance_l8x7 (getWhitePos_l8x7 board) ((length board) - 1)
	| otherwise								= getDistance_l8x7 (getBlackPos_l8x7 board) 0

getOpponentDistance_l8x7 :: [String] -> Char -> Int
getOpponentDistance_l8x7 board player
	| player == 'w'							= getDistance_l8x7 (getBlackPos_l8x7 board) 0
	| otherwise								= getDistance_l8x7 (getWhitePos_l8x7 board) ((length board) - 1)
	
getDistance_l8x7 :: [(Int, Int)] -> Int -> Int
getDistance_l8x7 pos endZone
	| null pos								= 0
	| endZone == 0							= (snd (head pos)) + (getDistance_l8x7 (tail pos) endZone)
	| otherwise								= endZone - (snd (head pos)) + (getDistance_l8x7 (tail pos) endZone)
	
--getCharPos: returns the tuple (x,y) position of a given character in the game board
getWhitePos_l8x7 :: [String] -> [(Int, Int)]
getWhitePos_l8x7 a = getCharPos_l8x7 a 'w'
getBlackPos_l8x7 :: [String] -> [(Int, Int)]
getBlackPos_l8x7 a = getCharPos_l8x7 a 'b'

getCharPos_l8x7 :: [String] -> Char -> [(Int, Int)] 
getCharPos_l8x7 board char = getCharPos_helper_l8x7 board char 0

getCharPos_helper_l8x7 :: [String] -> Char -> Int -> [(Int, Int)] 
getCharPos_helper_l8x7 board char y
	| board == []			= []
	| otherwise 			= (getCharPosInRow_l8x7 (head board) char y)++(getCharPos_helper_l8x7 (tail board) char (y+1))

getCharPosInRow_l8x7 :: String -> Char -> Int -> [(Int, Int)]
getCharPosInRow_l8x7 row char y = getCharPosInRow_helper_l8x7 row char 0 y

getCharPosInRow_helper_l8x7 :: String -> Char -> Int -> Int -> [(Int, Int)] 
getCharPosInRow_helper_l8x7 row char x y
	| row == []			= []
	| head row == char		= (x,y):getCharPosInRow_helper_l8x7 (tail row) char (x+1) y
	| otherwise			= getCharPosInRow_helper_l8x7 (tail row) char (x+1) y

	
--moveBL: Moves a char to the bottom left
moveBL_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveBL_l8x7 board char piece = moveBL_helper_l8x7 board char piece (checkMoveBL_l8x7 board char piece)

moveBL_helper_l8x7 :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveBL_helper_l8x7 board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsBottomHalf_l8x7 board piece
				= moveBL_helper_l8x7 (moveDirectlyBelow_l8x7 board char piece) char ((fst piece) -1, (snd piece) +1) (n-1)
	| pieceIsTopHalf_l8x7 board piece	
				= moveBL_helper_l8x7 (moveLeftBelow_l8x7 board char piece) char ((fst piece) -1, (snd piece) +1) (n-1)


--moveBR: Moves a char to the bottom right
moveBR_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveBR_l8x7 board char piece = moveBR_helper_l8x7  board char piece (checkMoveBR_l8x7 board char piece)

moveBR_helper_l8x7 :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveBR_helper_l8x7 board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsBottomHalf_l8x7 board piece
				= moveBR_helper_l8x7 (moveRightBelow_l8x7 board char piece) char ((fst piece) +1, (snd piece) +1) (n-1)
	| pieceIsTopHalf_l8x7 board piece	
				= moveBR_helper_l8x7 (moveDirectlyBelow_l8x7 board char piece) char ((fst piece), (snd piece) +1) (n-1)


--moveUL: Moves a char to the upper left
moveUL_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveUL_l8x7 board char piece =  moveUL_helper_l8x7  board char piece (checkMoveUL_l8x7 board char piece)
	
moveUL_helper_l8x7 :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveUL_helper_l8x7  board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsTopHalf_l8x7 board piece	
				=  moveUL_helper_l8x7 (moveDirectlyAbove_l8x7 board char piece) char ((fst piece), (snd piece) -1) (n-1)
	| pieceIsBottomHalf_l8x7 board piece
				=  moveUL_helper_l8x7 (moveLeftAbove_l8x7 board char piece) char ((fst piece) -1, (snd piece) -1) (n-1)


--moveUR: Moves a char to the upper right
moveUR_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveUR_l8x7 board char piece = moveUR_helper_l8x7 board char piece (checkMoveUR_l8x7 board char piece)

moveUR_helper_l8x7 :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveUR_helper_l8x7 board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsTopHalf_l8x7 board piece	
				= moveUR_helper_l8x7 (moveRightAbove_l8x7 board char piece) char ((fst piece) +1, (snd piece) -1) (n-1)
	| pieceIsBottomHalf_l8x7 board piece
				= moveUR_helper_l8x7 (moveDirectlyAbove_l8x7 board char piece) char ((fst piece), (snd piece) -1) (n-1)


-- check if it is possible to move or jump to bottom left
checkMoveBL_l8x7 :: [String] -> Char -> (Int, Int) -> Int
checkMoveBL_l8x7 board char piece
	| (pieceIsBottomHalf_l8x7 board piece) /= True && 
	  (fst piece) == 0
											= 0
	| (snd piece) == ((length board) -1)						= 0
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) /= char)
					= (2 * checkMoveBL_l8x7 board char (movePieceDirectlyBelow_l8x7 piece))

	| (pieceIsTopHalf_l8x7 board piece) && 
	  (pieceIsCenter_l8x7 board piece) /= True &&
	  ((board !! ((snd piece) + 1)) !! ((fst piece) - 1) == '-')
											= 1
	-- Checks for jumping over
	| (pieceIsTopHalf_l8x7 board piece) && 
	  (pieceIsCenter_l8x7 board piece) /= True &&
	  ((board !! ((snd piece) + 1)) !! ((fst piece) - 1) /= char)			
					= (2 * checkMoveBL_l8x7 board char (movePieceLeftBelow_l8x7 piece))
	| otherwise					 				= 0
	


-- check if it is possible to move or jump to bottom right
checkMoveBR_l8x7 :: [String] -> Char -> (Int, Int) -> Int
checkMoveBR_l8x7 board char piece
	| (pieceIsBottomHalf_l8x7 board piece) /= True && 
	  (fst piece) == ((length (board !! snd piece)) - 1)
											= 0
	| (snd piece) == ((length board) -1)						= 0
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) + 1) == '-')
											= 1
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) + 1) /= char)							
					= (2 * checkMoveBR_l8x7 board char (movePieceRightBelow_l8x7 piece))
	| (pieceIsTopHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsTopHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) /= char)				
					= (2 * checkMoveBR_l8x7 board char (movePieceDirectlyBelow_l8x7 piece))
	
	| otherwise					 				= 0


-- check if it is possible to move or jump to upper left
checkMoveUL_l8x7 :: [String] -> Char -> (Int, Int) -> Int
checkMoveUL_l8x7 board char piece 
	| (pieceIsTopHalf_l8x7 board piece) /= True && 
	  (fst piece) == 0
											= 0
	| (snd piece) == 0								= 0
	| (pieceIsTopHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsTopHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) /= char)
					= (2 * checkMoveUL_l8x7 board char (movePieceDirectlyAbove_l8x7 piece))
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) - 1) == '-')
											= 1
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) - 1) /= char)
					= (2 * checkMoveUL_l8x7 board char (movePieceLeftAbove_l8x7 piece))
	| otherwise					 			= 0
	


-- check if it is possible to move or jump to upper right
checkMoveUR_l8x7 :: [String] -> Char -> (Int, Int) -> Int
checkMoveUR_l8x7 board char piece
	| (pieceIsTopHalf_l8x7 board piece) /= True && 
	  (fst piece) == ((length (board !! snd piece)) - 1)
											= 0
	| (snd piece) == 0								= 0
	| (pieceIsTopHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) + 1) == '-')
											= 1
	| (pieceIsTopHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) + 1) == char)
					=  (2 * checkMoveUR_l8x7 board char (movePieceRightAbove_l8x7 piece))
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsBottomHalf_l8x7 board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) /= char)
					=  (2 * checkMoveUR_l8x7 board char (movePieceDirectlyAbove_l8x7 piece))
	| otherwise					 			= 0

	
-- Move Helpers

-- move char to x, y+1 relative to current x, y
moveDirectlyBelow_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveDirectlyBelow_l8x7 board char piece	=
				(nthhead_l8x7 board (snd piece)) ++
				([(nthhead_l8x7 (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail_l8x7 (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead_l8x7 (board !! ((snd piece) + 1)) (fst piece)) ++
				(char:(nthtail_l8x7 (board !! ((snd piece) + 1)) (fst piece)))]) ++
				(nthtail_l8x7 board ((snd piece) + 1))

movePieceDirectlyBelow_l8x7 piece =	((fst piece), (snd piece + 1))

-- move char to x+1, y+1 relative to current x, y
moveRightBelow_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveRightBelow_l8x7 board char piece	=
				(nthhead_l8x7 board (snd piece)) ++
				([(nthhead_l8x7 (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail_l8x7 (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead_l8x7 (board !! ((snd piece) + 1)) ((fst piece) + 1)) ++
				(char:(nthtail_l8x7 (board !! ((snd piece) + 1)) ((fst piece) + 1)))]) ++
				(nthtail_l8x7 board ((snd piece) + 1))
				
movePieceRightBelow_l8x7 piece = ((fst piece + 1), (snd piece + 1))

-- move char to x-1, y+1 relative to current x, y
moveLeftBelow_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveLeftBelow_l8x7 board char piece	=
				(nthhead_l8x7 board (snd piece)) ++
				([(nthhead_l8x7 (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail_l8x7 (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead_l8x7 (board !! ((snd piece) + 1)) ((fst piece) - 1)) ++
				(char:(nthtail_l8x7 (board !! ((snd piece) + 1)) ((fst piece) - 1)))]) ++
				(nthtail_l8x7 board ((snd piece) + 1))

movePieceLeftBelow_l8x7 piece = ((fst piece - 1), (snd piece + 1))

-- move char to x, y-1 relative to current x, y
moveDirectlyAbove_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveDirectlyAbove_l8x7 board char piece	=
				(nthhead_l8x7 board ((snd piece) - 1)) ++
				([(nthhead_l8x7 (board !! ((snd piece) - 1)) (fst piece)) ++
				(char:(nthtail_l8x7 (board !! ((snd piece) - 1)) (fst piece)))]) ++
				([(nthhead_l8x7 (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail_l8x7 (board !! (snd piece)) (fst piece)))]) ++
				(nthtail_l8x7 board (snd piece))

movePieceDirectlyAbove_l8x7 piece = ((fst piece), (snd piece - 1))

-- move char to x-1, y-1 relative to current x, y
moveLeftAbove_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveLeftAbove_l8x7 board char piece	=
				(nthhead_l8x7 board ((snd piece) - 1)) ++
				([(nthhead_l8x7 (board !! ((snd piece) - 1)) ((fst piece) - 1)) ++
				(char:(nthtail_l8x7 (board !! ((snd piece) - 1)) ((fst piece) - 1)))]) ++
				([(nthhead_l8x7 (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail_l8x7 (board !! (snd piece)) (fst piece)))]) ++
				(nthtail_l8x7 board (snd piece))

movePieceLeftAbove_l8x7 piece = ((fst piece - 1), (snd piece - 1))
				
-- move char to x+1, y-1 relative to current x, y
moveRightAbove_l8x7 :: [String] -> Char -> (Int, Int) -> [String]
moveRightAbove_l8x7 board char piece	=
				(nthhead_l8x7 board ((snd piece) - 1)) ++
				([(nthhead_l8x7 (board !! ((snd piece) - 1)) ((fst piece) + 1)) ++
				(char:(nthtail_l8x7 (board !! ((snd piece) - 1)) ((fst piece) + 1)))]) ++
				([(nthhead_l8x7 (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail_l8x7 (board !! (snd piece)) (fst piece)))]) ++
				(nthtail_l8x7 board (snd piece))

movePieceRightAbove_l8x7 piece = ((fst piece + 1), (snd piece - 1))

-- return the elements after the index, not including the index row
nthtail_l8x7 :: [a] -> Int -> [a]
nthtail_l8x7 [] index = []
nthtail_l8x7 (x:xs) index
	| index == 0				= xs
	| otherwise					= nthtail_l8x7 xs (index-1)  

-- return the elements before the index, not including the index row
nthhead_l8x7 :: [a] -> Int -> [a]
nthhead_l8x7 [] index = []
nthhead_l8x7 (x:xs) index
	| index < 1					= []
	| index == 1				= [x]
	| otherwise					= x:(nthhead_l8x7 xs (index-1))

	
--pieceIsTopHalf: Checks whether the row to move to is shorter or longer. Middle counts as True.
pieceIsTopHalf_l8x7 board piece = length board > ((snd piece) + (snd piece))
--pieceIsBottomHalf: Checks whether the row to move to is shorter or longer. Middle counts as True.
pieceIsBottomHalf_l8x7 board piece = length board <= ((snd piece) + (snd piece) + 1)

pieceIsCenter_l8x7 board piece = length board == ((snd piece) + (snd piece) + 1)

