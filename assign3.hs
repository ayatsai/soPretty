-- assign3.hs
--
-- Chin-Tsai Tsai 42698100

--rush_hour :: [String] -> [[String]]
--rush_hour startState = statesearch startState [[]]

--pegpuzzle start goal = reverse (statesearch [start] goal [])

--statesearch :: [String] -> [[String]] -> [[String]]
--statesearch unexplored path
--   | null unexplored              = []
--   | checkGoal (head explored)    = goal:path
--   | (not (null result))          = result
--   | otherwise                    = 
--        statesearch (tail unexplored) path
--     where result = statesearch 
--                       (generateNewStates (head unexplored)) 
--                       ((head unexplored):path)


--generateNew currState pos oldSegment newSegment
--   | pos + (length oldSegment) > length currState    = []
--   | segmentEqual currState pos oldSegment           =
--        (replaceSegment currState pos newSegment):
--        (generateNew currState (pos + 1) oldSegment newSegment)
--   | otherwise                                       =
--        (generateNew currState (pos + 1) oldSegment newSegment)

--generateNewRedSlides currState =
--   generateNew currState 0 "R_" "_R"


--generateNewRedJumps currState = 
--   generateNew currState 0 "RB_" "_BR"

--generateNewBlueSlides currState =
--   reverseEach (generateNew (reverse currState) 0 "B_" "_B")

--generateNewBlueJumps currState = 
--   reverseEach (generateNew (reverse currState) 0 "BR_" "_RB")

--generateNewStates :: [String] -> [[String]]
--generateNewStates currState =
--	generateNewStatesHelper (head currState) currState 0 0
--	concat  [CheckRow currState [], CheckColumn currState []]

--generateNewStatesHelper :: String -> [String] -> Integer -> Integer -> [[String]]
--generateNewStatesHelper row currState rowIndex colIndex 
--	| checkRow (head row) rowIndex row		= concat [moveLeft currState rowIndex colIndex, moveRight currState rowIndex colIndex]
--	| checkCol currState colIndex  			= concat [moveUp currState rowIndex colIndex, moveDown currState rowIndex colIndex]
--	| otherwise								= []

getCars :: [String] -> String
getCars null = []
getCars (x:xs) = removeduplicates((removeduplicates x):(getCars xs))

removeduplicates :: (Eq a) => [a] -> [a]
removeduplicates (x:xs)
	| null xs				= x:[]
	| elem x xs				= removeduplicates xs
	| otherwise				= x:removeduplicates xs


	
-- the row to check, and the index to start checking 
checkHorizontalCar :: Char -> String -> Integer -> Bool
checkHorizontalCar car row index
	| null row								= False
	| index > 0 							= checkHorizontalCar car (tail row) (index - 1)
	| car == (head row)						= checkHorizontalCarHelper car (tail row)
	| otherwise								= False

checkHorizontalCarHelper :: Char -> [Char] -> Bool
checkHorizontalCarHelper car row
	| car == (head row)						= True
	| otherwise								= False
	
-- the rows left to check and the index of the column
checkVerticalCar :: Char -> [String] -> Integer -> Bool
checkVerticalCar car map index
	| getElementOfRow (head map) index == car	= True
	| otherwise									= False

getElementOfRow :: String -> Integer -> Char
getElementOfRow row index 
	| index > 0 								= getElementOfRow (tail row) (index - 1)
	| otherwise									= head row
			 
-- Solve rush_hour, but outputs nicely in the console
--rush_print :: [String] -> IO ()
--rush_print start = printStrMatrix (rush_hour start)

-- Get a list of lists of strings and output them nicely.
--printStrMatrix :: [[String]] -> IO ()
--printStrMatrix [] = printStrList []
--printStrMatrix (x:xs) = do
--    printStrList x
--    printStrMatrix xs

-- Print nicely a list of strings.
-- Eg: printStrList ["aabb", "ccdd", "eeff"] prints in the console:
-- aabb
-- ccdd
-- eeff
--printStrList :: [String] -> IO ()
--printStrList [] = putStrLn ""
--printStrList (x:xs) = do
--    putStrLn x
--    printStrList xs