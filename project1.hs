testBoard = ["wwww","---", "--", "---", "bbbb"]
testGetCharPos = getWhitePos ["w---","-w-", "w-", "--w", "bbbb"] 
testMoveBL = moveBL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (0,0)
testMoveBL2 = moveBL ["w---","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveBL3 = moveBL ["w---","-w-", "-w", "--w", "bbbw"] 'w' (3,4)
testMoveBL4 = moveBL ["w---","-w-", "-w", "--w", "bb--"] 'w' (2,3)

-- Should return ["w---","---", "-w", "w-w", "bb--"]
testMoveBL5 = moveBL ["w---","-w-", "bb", "--w", "bb--"] 'w' (1,1)
testMoveBL6 = moveBL ["---w","-wb", "bw", "b-w", "----"] 'w' (1,1)
testMoveBL7 = moveBL ["w---","-w-", "-b", "--w", "bb--"] 'w' (1,1)

testMoveBR = moveBR ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveBR2 = moveBR ["w--w","-w-", "-w", "--w", "bbbb"] 'w' (3,0)
testMoveBR3 = moveBR ["w---","-w-", "-w", "--w", "bbbw"] 'w' (3,4)
testMoveBR4 = moveBR ["w---","-w-", "-w", "--w", "bbb-"] 'w' (2,3)

testMoveBR5 = moveBR ["w---","-w-", "bb", "---", "bb--"] 'w' (1,1)
testMoveBR6 = moveBR ["---w","-wb", "bw", "b-w", "----"] 'w' (1,1)

testMoveUL = moveUL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveUL2 = moveUL ["ww--","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveUL3 = moveUL ["w---","-w-", "--", "---", "bbbw"] 'w' (3,4)
testMoveUL4 = moveUL ["w---","-w-", "--", "w--", "bb--"] 'w' (2,3)

testMoveUL5 = moveUL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveUL6 = moveUL ["ww--","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveUL7 = moveUL ["w---","-w-", "--", "--b", "bbbw"] 'w' (3,4)
testMoveUL8 = moveUL ["w---","-w-", "bb", "-w-", "bb--"] 'w' (1,3)

testMoveUR = moveUR ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveUR2 = moveUR ["w-w-","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveUR3 = moveUR ["w---","-w-", "--", "--w", "bbbw"] 'w' (3,4)
testMoveUR4 = moveUR ["w---","-w-", "--", "--w", "bb--"] 'w' (2,3)
testMoveUR5 = moveUR ["w---","-w-", "bb", "-ww", "bb--"] 'w' (1,3)

-- should return 1
testCheckMoveBL = checkMoveBL ["---w","-w-", "bw", "--w", "bb--"] 'w' (3,0)
-- should return 2
testCheckMoveBL2 = checkMoveBL ["---w","-wb", "--", "--w", "bb--"] 'w' (3,0)
-- should return 0
testCheckMoveBL3 = checkMoveBL ["---w","-wb", "-w", "-bw", "----"] 'w' (3,0)
-- should return 2 
testCheckMoveBL4 = checkMoveBL ["---w","-wb", "bw", "-bw", "----"] 'w' (1,1)
-- should return 1
testCheckMoveBL5 = checkMoveBL ["---w","-wb", "bw", "--w", "----"] 'w' (1,2)
-- Bug. jumps over two enemies. Handled by MoveBL_helper instead
testCheckMoveBL6 = checkMoveBL ["---w","-wb", "bw", "b-w", "----"] 'w' (1,1)

testCheckMoveBR = checkMoveBR ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testCheckMoveBR2 = checkMoveBR ["w--w","-w-", "-w", "--w", "bbbb"] 'w' (3,0)
testCheckMoveBR3 = checkMoveBR ["w---","-w-", "-w", "--w", "bbbw"] 'w' (3,4)
testCheckMoveBR4 = checkMoveBR ["w---","ww-", "bw", "--w", "bbb-"] 'w' (0,1)

testCheckMoveUL = checkMoveUL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testCheckMoveUL2 = checkMoveUL ["ww--","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testCheckMoveUL3 = checkMoveUL ["w---","-w-", "--", "--b", "bbbw"] 'w' (3,4)
testCheckMoveUL4 = checkMoveUL ["w---","-w-", "bb", "-w-", "bb--"] 'w' (1,3)

testCheckMoveUR = checkMoveUR ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testCheckMoveUR2 = checkMoveUR ["ww--","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testCheckMoveUR3 = checkMoveUR ["w---","-w-", "--", "--b", "bbbw"] 'w' (3,4)
testCheckMoveUR4 = checkMoveUR ["w---","-w-", "bb", "-w-", "bb--"] 'w' (1,3)

testEvaluateBoard = evaluateBoard ["w---","-w-", "--", "---", "bb-w"] 'w'
testEvaluateBoard2 = evaluateBoard ["w--w","---", "--", "---", "bb--"] 'b'
testEvaluateBoard3 = evaluateBoard ["----","---", "--", "---", "bb--"] 'b'
testEvaluateBoard4 = evaluateBoard ["----","---", "--", "---", "bb--"] 'w'
testEvaluateBoard5 = evaluateBoard ["----","---", "--", "---", "bbww"] 'w'
testEvaluateBoard6 = evaluateBoard ["----","---", "--", "---", "bbww"] 'b'
testEvaluateBoard7 = evaluateBoard ["-bbb","---", "--", "---", "--ww"] 'w'
testEvaluateBoard8 = evaluateBoard ["--bb","---", "--", "---", "--ww"] 'b'
testGNS = generateNewStates ["w---","-w-", "--", "---", "bb-w"] 'w'
testGNS2 = generateNewStates ["w-b-","-wb", "--", "---", "b--w"] 'b'
testSS = statesearch ["w-b-","-wb", "--", "---", "b--w"] 'b'
testGMaxH = getMaxHeuristics [(["a"],3),(["f"],0),(["g"],5)] (negate(3*3))
testGMinH = getMinHeuristics [(["a"],3),(["f"],-5),(["g"],5)] (3*3)






-- TODO: white moves first??? do we need to check for this?

-- TODO: minimax algorithm here
statesearch :: [String] -> Char -> [([String], Int)]
statesearch board player = generateNewStates board player

getMaxHeuristics :: [([String], Int)] -> Int -> Int
getMaxHeuristics states value
	| null states					= value
	| (snd (head states)) > value	= getMaxHeuristics (tail states) (snd (head states))
	| otherwise						= getMaxHeuristics (tail states) value

getMinHeuristics :: [([String], Int)] -> Int -> Int
getMinHeuristics states value
	| null states					= value
	| (snd (head states)) < value	= getMinHeuristics (tail states) (snd (head states))
	| otherwise						= getMinHeuristics (tail states) value

	

-- generateNewStates
generateNewStates :: [String] -> Char -> [([String], Int)]
generateNewStates board player
	| player == 'w' 			= filter 
								  (/= (board, evaluateBoard board player))
						          (generateNewStatesIterator board player (getWhitePos board))
	| otherwise					= filter 
								  (/= (board, evaluateBoard board player))
								  (generateNewStatesIterator board player (getBlackPos board))

generateNewStatesIterator :: [String] -> Char -> [(Int, Int)] -> [([String], Int)]
generateNewStatesIterator board player pos
	| null pos				= []
	| otherwise				= 
		(generateNewStatesHelper board player (head pos)) ++ (generateNewStatesIterator board player (tail pos))
	
generateNewStatesHelper :: [String] -> Char -> (Int,Int) -> [([String], Int)]
generateNewStatesHelper board player pos 
	| player == 'w'				= [(moveBL board player pos, evaluateBoard (moveBL board player pos) player)] ++ 
								  [(moveBR board player pos, evaluateBoard (moveBR board player pos) player)]
	| otherwise					= [(moveUL board player pos, evaluateBoard (moveUL board player pos) player)] ++ 
								  [(moveUR board player pos, evaluateBoard (moveUR board player pos) player)]


-- heuristics
-- value			: description
-- +n^2				: own pieces are at the back of the opponent's end
-- -n^2				: opponent pieces are at the back of the own end
-- +n^2				: opponent pieces are removed
-- -n^2				: own pieces are removed
-- opponent - own	: steps to the end zone
-- ASSUME: w is always moving down
evaluateBoard :: [String] -> Char -> Int
evaluateBoard board player
	-- TODO return what for draw???
	| checkDraw board 						= ((length board) * (length board))
	| checkPlayerWin board player			= ((length board) * (length board))
	| checkOpponentWin board player			= negate ((length board) * (length board))
	| otherwise								= getOpponentDistance board player - getPlayerDistance board player

checkDraw :: [String] -> Bool
checkDraw board = (checkBothAtEndZone board) && ((length (getWhitePos board)) == (length (getBlackPos board)))

checkPlayerWin :: [String] -> Char -> Bool
checkPlayerWin board player 
	| player == 'w' && null (getWhitePos board)					= False
	| player == 'b' && null (getBlackPos board)					= False
	| player == 'w' && (checkBothAtEndZone board) && 
	  (length (getWhitePos board) > length (getBlackPos board)) = True
	| player == 'w' && (checkBothAtEndZone board) &&
	  (length (getBlackPos board) > length (getWhitePos board)) = False
	| player == 'b' && (checkBothAtEndZone board) &&
	  (length (getBlackPos board) > length (getWhitePos board)) = True
	| player == 'b' && (checkBothAtEndZone board) &&
	  (length (getBlackPos board) < length (getWhitePos board)) = False
	| player == 'w'	&& 
	  ((length (getBlackPos board)) == 0 || 
	  (checkEndZone (getWhitePos board) ((length board) - 1)))	= True
	| player == 'b'	&& 
	  ((length (getWhitePos board)) == 0 || 
	  (checkEndZone (getBlackPos board) 0))						= True
	| otherwise													= False

checkOpponentWin :: [String] -> Char -> Bool
checkOpponentWin board player
	| player == 'w'							= checkPlayerWin board 'b'
	| otherwise								= checkPlayerWin board 'w'
	
checkEndZone :: [(Int, Int)] -> Int -> Bool
checkEndZone pos n
	| null pos							= True
	| (snd (head pos)) == n				= checkEndZone (tail pos) n
	| otherwise							= False

checkBothAtEndZone :: [String] -> Bool
checkBothAtEndZone board = (checkEndZone (getWhitePos board) ((length board) - 1)) &&
								  (checkEndZone (getBlackPos board) 0)
	
getPlayerDistance :: [String] -> Char -> Int
getPlayerDistance board player
	| player == 'w'							= getDistance (getWhitePos board) ((length board) - 1)
	| otherwise								= getDistance (getBlackPos board) 0

getOpponentDistance :: [String] -> Char -> Int
getOpponentDistance board player
	| player == 'w'							= getDistance (getBlackPos board) 0
	| otherwise								= getDistance (getWhitePos board) ((length board) - 1)
	
getDistance :: [(Int, Int)] -> Int -> Int
getDistance pos endZone
	| null pos								= 0
	| endZone == 0							= (snd (head pos)) + (getDistance (tail pos) endZone)
	| otherwise								= endZone - (snd (head pos)) + (getDistance (tail pos) endZone)
	
--complete 
--getCharPos: returns the tuple (x,y) position of a given character in the game board
getWhitePos :: [String] -> [(Int, Int)]
getWhitePos a = getCharPos a 'w'
getBlackPos :: [String] -> [(Int, Int)]
getBlackPos a = getCharPos a 'b'

getCharPos :: [String] -> Char -> [(Int, Int)] 
getCharPos board char = getCharPos_helper board char 0

getCharPos_helper :: [String] -> Char -> Int -> [(Int, Int)] 
getCharPos_helper board char y
	| board == []			= []
	| otherwise 			= (getCharPosInRow (head board) char y)++(getCharPos_helper (tail board) char (y+1))

getCharPosInRow :: String -> Char -> Int -> [(Int, Int)]
getCharPosInRow row char y = getCharPosInRow_helper row char 0 y

getCharPosInRow_helper :: String -> Char -> Int -> Int -> [(Int, Int)] 
getCharPosInRow_helper row char x y
	| row == []			= []
	| head row == char		= (x,y):getCharPosInRow_helper (tail row) char (x+1) y
	| otherwise			= getCharPosInRow_helper (tail row) char (x+1) y

	
-- complete
--moveBL: Moves a char to the bottom left
moveBL :: [String] -> Char -> (Int, Int) -> [String]
moveBL board char piece = moveBL_helper board char piece (checkMoveBL board char piece)

moveBL_helper :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveBL_helper board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsBottomHalf board piece
				= moveBL_helper (moveDirectlyBelow board char piece) char ((fst piece) -1, (snd piece) +1) (n-1)
	| pieceIsTopHalf board piece	
				= moveBL_helper (moveLeftBelow board char piece) char ((fst piece) -1, (snd piece) +1) (n-1)


-- complete
--moveBR: Moves a char to the bottom right
moveBR :: [String] -> Char -> (Int, Int) -> [String]
moveBR board char piece = moveBR_helper  board char piece (checkMoveBR board char piece)

moveBR_helper :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveBR_helper board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsBottomHalf board piece
				= moveBR_helper (moveRightBelow board char piece) char ((fst piece) +1, (snd piece) +1) (n-1)
	| pieceIsTopHalf board piece	
				= moveBR_helper (moveDirectlyBelow board char piece) char ((fst piece), (snd piece) +1) (n-1)


--complete
--moveUL: Moves a char to the upper left
moveUL :: [String] -> Char -> (Int, Int) -> [String]
moveUL board char piece =  moveUL_helper  board char piece (checkMoveUL board char piece)
	
moveUL_helper :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveUL_helper  board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsTopHalf board piece	
				=  moveUL_helper (moveDirectlyAbove board char piece) char ((fst piece), (snd piece) -1) (n-1)
	| pieceIsBottomHalf board piece
				=  moveUL_helper (moveLeftAbove board char piece) char ((fst piece) -1, (snd piece) -1) (n-1)


-- complete
moveUR :: [String] -> Char -> (Int, Int) -> [String]
moveUR board char piece = moveUR_helper board char piece (checkMoveUR board char piece)

moveUR_helper :: [String] -> Char -> (Int, Int) -> Int -> [String]
moveUR_helper board char piece n
	| n == 0		= board
	| n > 2			= board
	| pieceIsTopHalf board piece	
				= moveUR_helper (moveRightAbove board char piece) char ((fst piece) +1, (snd piece) -1) (n-1)
	| pieceIsBottomHalf board piece
				= moveUR_helper (moveDirectlyAbove board char piece) char ((fst piece), (snd piece) -1) (n-1)



--complete
checkMoveBL :: [String] -> Char -> (Int, Int) -> Int
checkMoveBL board char piece
	| (pieceIsBottomHalf board piece) /= True && 
	  (fst piece) == 0
											= 0
	| (snd piece) == ((length board) -1)						= 0
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) /= char)
					= (2 * checkMoveBL board char (movePieceDirectlyBelow piece))

	| (pieceIsTopHalf board piece) && 
	  (pieceIsCenter board piece) /= True &&
	  ((board !! ((snd piece) + 1)) !! ((fst piece) - 1) == '-')
											= 1
	-- Checks for jumping over
	| (pieceIsTopHalf board piece) && 
	  (pieceIsCenter board piece) /= True &&
	  ((board !! ((snd piece) + 1)) !! ((fst piece) - 1) /= char)			
					= (2 * checkMoveBL board char (movePieceLeftBelow piece))
	| otherwise					 				= 0
	


-- complete
checkMoveBR :: [String] -> Char -> (Int, Int) -> Int
checkMoveBR board char piece
	| (pieceIsBottomHalf board piece) /= True && 
	  (fst piece) == ((length (board !! snd piece)) - 1)
											= 0
	| (snd piece) == ((length board) -1)						= 0
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) + 1) == '-')
											= 1
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) + 1) /= char)							
					= (2 * checkMoveBR board char (movePieceRightBelow piece))
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) /= char)				
					= (2 * checkMoveBR board char (movePieceDirectlyBelow piece))
	
	| otherwise					 				= 0


-- complete
checkMoveUL :: [String] -> Char -> (Int, Int) -> Int
checkMoveUL board char piece 
	| (pieceIsTopHalf board piece) /= True && 
	  (fst piece) == 0
											= 0
	| (snd piece) == 0								= 0
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) /= char)
					= (2 * checkMoveUL board char (movePieceDirectlyAbove piece))
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) - 1) == '-')
											= 1
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) - 1) /= char)
					= (2 * checkMoveUL board char (movePieceLeftAbove piece))
	| otherwise					 			= 0
	


-- incomplete
checkMoveUR :: [String] -> Char -> (Int, Int) -> Int
checkMoveUR board char piece
	| (pieceIsTopHalf board piece) /= True && 
	  (fst piece) == ((length (board !! snd piece)) - 1)
											= 0
	| (snd piece) == 0								= 0
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) + 1) == '-')
											= 1
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) + 1) == char)
					=  (2 * checkMoveUR board char (movePieceRightAbove piece))
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) == '-')
											= 1
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) /= char)
					=  (2 * checkMoveUR board char (movePieceDirectlyAbove piece))
	| otherwise					 			= 0

	
-- complete
-- Move Helpers

-- move char to x, y+1 relative to current x, y
moveDirectlyBelow :: [String] -> Char -> (Int, Int) -> [String]
moveDirectlyBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) (fst piece)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) (fst piece)))]) ++
				(nthtail board ((snd piece) + 1))

movePieceDirectlyBelow piece =	((fst piece), (snd piece + 1))

-- move char to x+1, y+1 relative to current x, y
moveRightBelow :: [String] -> Char -> (Int, Int) -> [String]
moveRightBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) ((fst piece) + 1)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) ((fst piece) + 1)))]) ++
				(nthtail board ((snd piece) + 1))
				
movePieceRightBelow piece = ((fst piece + 1), (snd piece + 1))

-- move char to x-1, y+1 relative to current x, y
moveLeftBelow :: [String] -> Char -> (Int, Int) -> [String]
moveLeftBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) ((fst piece) - 1)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) ((fst piece) - 1)))]) ++
				(nthtail board ((snd piece) + 1))

movePieceLeftBelow piece = ((fst piece - 1), (snd piece + 1))

-- move char to x, y-1 relative to current x, y
moveDirectlyAbove :: [String] -> Char -> (Int, Int) -> [String]
moveDirectlyAbove board char piece	=
				(nthhead board ((snd piece) - 1)) ++
				([(nthhead (board !! ((snd piece) - 1)) (fst piece)) ++
				(char:(nthtail (board !! ((snd piece) - 1)) (fst piece)))]) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				(nthtail board (snd piece))

movePieceDirectlyAbove piece = ((fst piece), (snd piece - 1))

-- move char to x-1, y-1 relative to current x, y
moveLeftAbove :: [String] -> Char -> (Int, Int) -> [String]
moveLeftAbove board char piece	=
				(nthhead board ((snd piece) - 1)) ++
				([(nthhead (board !! ((snd piece) - 1)) ((fst piece) - 1)) ++
				(char:(nthtail (board !! ((snd piece) - 1)) ((fst piece) - 1)))]) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				(nthtail board (snd piece))

movePieceLeftAbove piece = ((fst piece - 1), (snd piece - 1))
				
-- move char to x+1, y-1 relative to current x, y
moveRightAbove :: [String] -> Char -> (Int, Int) -> [String]
moveRightAbove board char piece	=
				(nthhead board ((snd piece) - 1)) ++
				([(nthhead (board !! ((snd piece) - 1)) ((fst piece) + 1)) ++
				(char:(nthtail (board !! ((snd piece) - 1)) ((fst piece) + 1)))]) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				(nthtail board (snd piece))

movePieceRightAbove piece = ((fst piece + 1), (snd piece - 1))

-- return the elements after the index, not including the index row
nthtail :: [a] -> Int -> [a]
nthtail [] index = []
nthtail (x:xs) index
	| index == 0				= xs
	| otherwise					= nthtail xs (index-1)  

-- return the elements before the index, not including the index row
nthhead :: [a] -> Int -> [a]
nthhead [] index = []
nthhead (x:xs) index
	| index < 1					= []
	| index == 1				= [x]
	| otherwise					= x:(nthhead xs (index-1))

	
--complete
--pieceIsTopHalf: Checks whether the row to move to is shorter or longer. Middle counts as True.
pieceIsTopHalf board piece = length board > ((snd piece) + (snd piece))
--pieceIsBottomHalf: Checks whether the row to move to is shorter or longer. Middle counts as True.
pieceIsBottomHalf board piece = length board <= ((snd piece) + (snd piece) + 1)

pieceIsCenter board piece = length board == ((snd piece) + (snd piece) + 1)

