testBoard = ["wwww","---", "--", "---", "bbbb"]
testGetCharPos = getWhitePos ["w---","-w-", "w-", "--w", "bbbb"] 
testMoveBL = moveBL ["w---","-w-", "w-", "--w", "bbbb"] 'w' (1,1)
testMoveBL2 = moveBL ["w---","-w-", "--", "--w", "bbbb"] 'w' (1,1)

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
	| checkMoveBL board piece 		 	= updatedBoard
	| otherwise							= board
	where updatedBoard = 
		(nthhead board (snd piece)) ++
		([(nthhead (board !! (snd piece)) (fst piece)) ++
		('-':(nthtail (board !! (snd piece)) (fst piece)))]) ++
		([(nthhead (board !! ((snd piece) + 1)) ((fst piece) - 1)) ++
		(char:(nthtail (board !! ((snd piece) + 1)) ((fst piece) - 1)))]) ++
		(nthtail board ((snd piece) + 1))
	

--incomplete
--moveBR
--moveUL
--moveUR

--complete
checkMoveBL :: [String] -> (Int, Int) -> Bool
checkMoveBL board piece
	| (fst piece) == 0				= False
	|  togo == '-'					= True
	| otherwise					 	= False
	where togo = ((board !! ((snd piece) + 1)) !! ((fst piece) - 1))
	
--incomplete
--checkMoveBR
--checkMoveUL
--checkMoveUR
	
-- complete
-- Move Helpers
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
-- not used yet
--pieceIsTopHalf: Checks whether the row to move to is shorter or longer. Middle counts as True.
pieceIsTopHalf board piece = length board > ((snd piece) + (snd piece))

