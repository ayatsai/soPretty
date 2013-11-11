testBoard = ["wwww","---", "--", "---", "bbbb"]
testGetCharPos = getWhitePos ["w---","-w-", "w-", "--w", "bbbb"] 
testMoveBL = moveBL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveBL2 = moveBL ["w---","-w-", "--", "--w", "bbbb"] 'w' (1,1)
testMoveBL3 = moveBR ["w---","-w-", "-w", "--w", "bbbb"] 'w' (2,3)
testMoveBL4 = moveBR ["w---","-w-", "-w", "--w", "bb--"] 'w' (2,3)
testMoveBR = moveBR ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveBR2 = moveBR ["w---","-w-", "-w", "--w", "bbbb"] 'w' (1,1)
testMoveBR3 = moveBR ["w---","-w-", "-w", "--w", "bbbb"] 'w' (2,3)
testMoveBR4 = moveBR ["w---","-w-", "-w", "--w", "bbb-"] 'w' (2,3)

--complete 
--getCharPos: returns the tuple (x,y) position of a given character in the game board
getWhitePos a = getCharPos a 'w'
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

moveBR :: [String] -> Char -> (Int, Int) -> [String]
moveBR board char piece
	| checkMoveBR board piece && pieceIsTopHalf board piece	
				= moveDirectlyBelow board char piece
	| checkMoveBR board piece && pieceIsBottomHalf board piece
				= moveLeftBelow board char piece
	| otherwise							= board

--incomplete
--moveBR
--moveUL
--moveUR

--complete
checkMoveBL :: [String] -> (Int, Int) -> Bool
checkMoveBL board piece
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) - 1) == '-')
									= True
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
									= True
	| otherwise					 	= False
	where togo = ((board !! ((snd piece) + 1)) !! ((fst piece) - 1))
	
--
checkMoveBR :: [String] -> (Int, Int) -> Bool
checkMoveBR board piece
	| (pieceIsTopHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! (fst piece) == '-')
									= True
	| (pieceIsBottomHalf board piece) && 
	  ((board !! ((snd piece) + 1)) !! ((fst piece) + 1) == '-')
									= True
	| otherwise					 	= False

--checkMoveUL
--checkMoveUR
	
-- complete
-- Move Helpers

moveDirectlyBelow :: [String] -> Char -> (Int, Int) -> [String]
moveDirectlyBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) (fst piece)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) (fst piece)))]) ++
				(nthtail board ((snd piece) + 1))

moveRightBelow :: [String] -> Char -> (Int, Int) -> [String]
moveRightBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) ((fst piece) - 1)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) ((fst piece) - 1)))]) ++
				(nthtail board ((snd piece) + 1))
				
moveLeftBelow :: [String] -> Char -> (Int, Int) -> [String]
moveLeftBelow board char piece	=
				(nthhead board (snd piece)) ++
				([(nthhead (board !! (snd piece)) (fst piece)) ++
				('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
				([(nthhead (board !! ((snd piece) + 1)) ((fst piece) + 1)) ++
				(char:(nthtail (board !! ((snd piece) + 1)) ((fst piece) + 1)))]) ++
				(nthtail board ((snd piece) + 1))

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

