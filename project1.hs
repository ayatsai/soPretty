testBoard = ["wwww","---", "--", "---", "bbbb"]
testGetCharPos = getWhitePos ["w---","-w-", "w-", "--w", "bbbb"] 
testMoveBL = moveBL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (0,0)
testMoveBL2 = moveBL ["w---","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveBL3 = moveBL ["w---","-w-", "-w", "--w", "bbbw"] 'w' (3,4)
testMoveBL4 = moveBL ["w---","-w-", "-w", "--w", "bb--"] 'w' (2,3)
testMoveBR = moveBR ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveBR2 = moveBR ["w--w","-w-", "-w", "--w", "bbbb"] 'w' (3,0)
testMoveBR3 = moveBR ["w---","-w-", "-w", "--w", "bbbw"] 'w' (3,4)
testMoveBR4 = moveBR ["w---","-w-", "-w", "--w", "bbb-"] 'w' (2,3)
testMoveUL = moveUL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveUL2 = moveUL ["ww--","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveUL3 = moveUL ["w---","-w-", "--", "---", "bbbw"] 'w' (3,4)
testMoveUL4 = moveUL ["w---","-w-", "--", "w--", "bb--"] 'w' (2,3)
testMoveUR = moveUR ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveUR2 = moveUR ["w-w-","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveUR3 = moveUR ["w---","-w-", "--", "--w", "bbbw"] 'w' (3,4)
testMoveUR4 = moveUR ["w---","-w-", "--", "--w", "bb--"] 'w' (2,3)
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




-- TODO
oska :: [String] -> Char -> Int -> [String]
oska board player lookahead = fst (head (statesearch board player lookahead))

-- TODO: white moves first??? do we need to check for this?

-- TODO: minimax algorithm here
statesearch :: [String] -> Char -> Int -> [([String], Int)]
statesearch board player lookahead = generateNewStates board player

-- get the max heuristics value from the list
getMaxHeuristics :: [([String], Int)] -> Int -> Int
getMaxHeuristics states value
	| null states					= value
	| (snd (head states)) > value	= getMaxHeuristics (tail states) (snd (head states))
	| otherwise						= getMaxHeuristics (tail states) value
-- get the min heuristics value from the list
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
moveBL board char piece
	| checkMoveBL board piece && pieceIsTopHalf board piece	
				= moveRightBelow board char piece
	| checkMoveBL board piece && pieceIsBottomHalf board piece
				= moveDirectlyBelow board char piece
	| otherwise							= board
-- complete
--moveBR: Moves a char to the bottom right
moveBR :: [String] -> Char -> (Int, Int) -> [String]
moveBR board char piece
	| checkMoveBR board piece && pieceIsTopHalf board piece	
				= moveDirectlyBelow board char piece
	| checkMoveBR board piece && pieceIsBottomHalf board piece
				= moveLeftBelow board char piece
	| otherwise							= board

--complete
--moveUL: Moves a char to the upper left
moveUL :: [String] -> Char -> (Int, Int) -> [String]
moveUL board char piece
	| checkMoveUL board piece && pieceIsTopHalf board piece	
				= moveDirectlyAbove board char piece
	| checkMoveUL board piece && pieceIsBottomHalf board piece
				= moveLeftAbove board char piece
	| otherwise							= board

-- complete
moveUR :: [String] -> Char -> (Int, Int) -> [String]
moveUR board char piece
	| checkMoveUR board piece && pieceIsTopHalf board piece	
				= moveRightAbove board char piece
	| checkMoveUR board piece && pieceIsBottomHalf board piece
				= moveDirectlyAbove board char piece
	| otherwise							= board

--complete
checkMoveBL :: [String] -> (Int, Int) -> Bool
checkMoveBL board piece
	| (pieceIsTopHalf board piece) && 
	  (fst piece) == 0
											= False
	| (pieceIsBottomHalf board piece) && 
	  ((snd piece) == ((length board) - 1))	= False
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) - 1) == '-')
											= True
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
											= True
	| otherwise					 			= False
	
-- complete
checkMoveBR :: [String] -> (Int, Int) -> Bool
checkMoveBR board piece
	| (pieceIsTopHalf board piece) && 
	  (fst piece) == ((length (board !! snd piece)) - 1)
											= False
	| (pieceIsBottomHalf board piece) && 
	  ((snd piece) == ((length board) - 1))	= False
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
											= True
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) + 1) == '-')
											= True
	| otherwise					 			= False

-- complete
checkMoveUL :: [String] -> (Int, Int) -> Bool
checkMoveUL board piece
	| (pieceIsBottomHalf board piece) && 
	  (fst piece) == 0
											= False
	| (pieceIsTopHalf board piece) && 
	  ((snd piece) == 0)
											= False
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) == '-')
											= True
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) - 1) == '-')
											= True
	| otherwise					 			= False
	
-- complete
checkMoveUR :: [String] -> (Int, Int) -> Bool
checkMoveUR board piece
	| (pieceIsBottomHalf board piece) && 
	  (fst piece) == ((length (board !! snd piece)) - 1)
											= False
	| (pieceIsTopHalf board piece) && 
	  ((snd piece) == 0)					
											= False
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! ((fst piece) + 1) == '-')
											= True
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) - 1)) !! (fst piece) == '-')
											= True
	| otherwise					 			= False
	
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

-- move char to x+1, y+1 relative to current x, y
moveRightBelow :: [String] -> Char -> (Int, Int) -> [String]
moveRightBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) ((fst piece) - 1)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) ((fst piece) - 1)))]) ++
				(nthtail board ((snd piece) + 1))
				
-- move char to x-1, y+1 relative to current x, y
moveLeftBelow :: [String] -> Char -> (Int, Int) -> [String]
moveLeftBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) ((fst piece) + 1)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) ((fst piece) + 1)))]) ++
				(nthtail board ((snd piece) + 1))

-- move char to x, y-1 relative to current x, y
moveDirectlyAbove :: [String] -> Char -> (Int, Int) -> [String]
moveDirectlyAbove board char piece	=
				(nthhead board ((snd piece) - 1)) ++
				([(nthhead (board !! ((snd piece) - 1)) (fst piece)) ++
				(char:(nthtail (board !! ((snd piece) - 1)) (fst piece)))]) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				(nthtail board (snd piece))

-- move char to x-1, y-1 relative to current x, y
moveLeftAbove :: [String] -> Char -> (Int, Int) -> [String]
moveLeftAbove board char piece	=
				(nthhead board ((snd piece) - 1)) ++
				([(nthhead (board !! ((snd piece) - 1)) ((fst piece) - 1)) ++
				(char:(nthtail (board !! ((snd piece) - 1)) ((fst piece) - 1)))]) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				(nthtail board (snd piece))
				
-- move char to x+1, y-1 relative to current x, y
moveRightAbove :: [String] -> Char -> (Int, Int) -> [String]
moveRightAbove board char piece	=
				(nthhead board ((snd piece) - 1)) ++
				([(nthhead (board !! ((snd piece) - 1)) ((fst piece) + 1)) ++
				(char:(nthtail (board !! ((snd piece) - 1)) ((fst piece) + 1)))]) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				(nthtail board (snd piece))

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
pieceIsBottomHalf board piece = length board < ((snd piece) + (snd piece))

