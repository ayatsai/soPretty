-- assign3.hs
--

-- Test functions
-- get car tuple
test = getCarStats ["ddaa","-bbc","---c"]
-- check goal function
testgoal = checkGoal ["-aa---","aa--aa","--aaXX","--AA--","------","------"]


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


checkGoal :: [String] -> Bool
checkGoal map = ('X' == ((map !! 2) !! 5))


-- generateNewStates
-- move up
-- move down
-- move left
-- move right

--generateNewStatesHelper :: String -> [String] -> Integer -> Integer -> [[String]]
--generateNewStatesHelper row currState rowIndex colIndex 
--	| checkRow (head row) rowIndex row		= concat [moveLeft currState rowIndex colIndex, moveRight currState rowIndex colIndex]
--	| checkCol currState colIndex  			= concat [moveUp currState rowIndex colIndex, moveDown currState rowIndex colIndex]
--	| otherwise								= []






-- tuple: car [dir, row/col]
-- get All cars' direction and location
getCarStats :: [String] -> [(Char,[Int])]
getCarStats map = getCarStatsHelper map 0
	
getCarStatsHelper :: [String] -> Int -> [(Char,[Int])]
getCarStatsHelper map index 
	| null map					= []
	| otherwise					= removeTupleDuplicates((findCars cars (head map) index)++(getCarStatsHelper (tail map) (index+1)))
	where cars = getCars map

getCars :: [String] -> String
getCars map 
	| null map				= []
	| otherwise				= removeduplicates(getCars (tail map)++(removeduplicates (head map)))

removeduplicates :: String -> String
removeduplicates (x:xs)
	| null xs				= x:[]
	| x == '-'				= removeduplicates xs
	| elem x xs				= removeduplicates xs
	| otherwise				= x:removeduplicates xs
	
findCars :: String -> String -> Int -> [(Char,[Int])]
findCars cars row rowIndex 
	| null cars			= []
	| countChar (head cars) row > 1		= ((head cars), [1, rowIndex]):(findCars (tail cars) row rowIndex)
	| countChar (head cars) row == 1 	= ((head cars), [0, (getFirstIndex (head cars) row)]):(findCars (tail cars) row rowIndex)
	| otherwise							= findCars (tail cars) row rowIndex
	
removeTupleDuplicates :: [(Char,[Int])] -> [(Char,[Int])]
removeTupleDuplicates tuple
	| null tuple								= []
	| elem (fst (head tuple)) (getKeys (tail tuple))	= removeTupleDuplicates (tail tuple)
	| otherwise									= (head tuple):removeTupleDuplicates (tail tuple)

getKeys :: [(Char,[Int])] -> [Char]
getKeys tuple
	| null tuple						= []
	| otherwise							= (fst (head tuple)):(getKeys (tail tuple))
	
countChar :: (Eq a) => a -> [a] -> Int
countChar c check
	| null check 			= 0
	| head check == c		= 1 + countChar c (tail check)
	| otherwise				= countChar c (tail check)
	
getFirstIndex :: (Eq a) => a -> [a] -> Int
getFirstIndex c check
	| null check 			= 0
	| head check == c		= 0
	| otherwise				= 1 + getFirstIndex c (tail check)

-- end getting car tuple
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
-- not used, delete?
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