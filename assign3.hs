-- assign3.hs
--

-- Test functions
-- get car tuple
test = getCarStats ["ddaa","-bbc","---c"]
-- check goal function
testgoal = checkGoal ["-aa---","aa--aa","--aaXX","--AA--","------","------"]
-- check move left
testMoveLeft = moveLeft ('a', [1, 0]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveLeft1 = moveLeft ('a', [1, 1]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveLeft2 = moveLeft ('a', [1, 5]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveLeft3 = moveLeft ('a', [1, 2]) ["-----a","a-----","-aaa-b","-baa--","-a-a-a", "-aa---"] 0
testMoveLeft4 = moveLeft ('a', [1, 4]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "aa----"] 0


testMoveRight = moveLeft ('a', [1, 0]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveRight1 = moveLeft ('a', [1, 1]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveRight2 = moveLeft ('a', [1, 5]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveRight3 = moveLeft ('a', [1, 2]) ["-----a","a-----","-aaa-b","-baa--","-a-a-a", "-aa---"] 0
testMoveRight4 = moveLeft ('a', [1, 4]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "aa----"] 0



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
--MoveUp :: (Char, [Int]) -> [String] -> [String]
--MoveUp CarTuple Map
--	| 

-- move down


-- move left
moveLeft :: (Char, [Int]) -> [String] ->  Int -> [String]
moveLeft carTuple map index
	| index > 4									= map
	| carRow !! index == fst carTuple			= map
	| carRow !! index /= '-' 					= moveLeft carTuple map (index + 1)
	| carRow !! (index + 1) /= fst carTuple		= moveLeft carTuple map (index + 1)
	| otherwise 								= 
		moveLeft 
			carTuple 
			((nthhead (((snd carTuple) !! 1)) map) ++
			[(nthhead (index) carRow) ++ 
			((fst carTuple):'-':(nthtail (index + 1) (carRow)))] ++
			(nthtail ((snd carTuple) !! 1 ) map))
			(index + 1)
	where carRow = (map !! ((snd carTuple) !! 1))

-- move right
moveRight :: (Char, [Int]) -> [String] ->  Int -> [String]
moveRight carTuple map index
	| index > 4									= map
	| carRow !! index /= fst carTuple			= moveRight carTuple map (index + 1)
	| carRow !! (index + 1) /= '-'				= moveRight carTuple map (index + 1)
	| otherwise 								= 
		moveRight 
			carTuple 
			((nthhead (((snd carTuple) !! 1)) map) ++
			[(nthhead (index) carRow) ++ 
			('-':(fst carTuple):(nthtail (index + 1) (carRow)))] ++
			(nthtail ((snd carTuple) !! 1 ) map))
			(index + 1)
	where carRow = (map !! ((snd carTuple) !! 1))

-- Move Helpers
-- return the elements after the index, not including the index row
nthtail :: Int -> [a] -> [a]
nthtail index [] = []
nthtail index (x:xs)
	| index == 0				= xs
	| otherwise					= nthtail (index-1) xs  

-- return the elements before the index, not including the index row
nthhead :: Int -> [a] -> [a]
nthhead index [] = []
nthhead index (x:xs)
	| index < 1					= []
	| index == 1				= [x]
	| otherwise					= x:(nthhead (index-1) xs)


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