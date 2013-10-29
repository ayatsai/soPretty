-- assign3.hs
--
-- Chin-Tsai Tsai 42698100
-- Wesley Tsai 44396109

-- Test functions
-- get car tuple
test = getCarStats ["--B---","--B---","XXB---","--AA--","------", "------"]
-- check goal function
testgoal = checkGoal ["-aa---","aa--aa","--aaXX","--AA--","------","------"]
-- check moves
testMoveLeft = moveLeft ('a', [1, 0]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveLeft1 = moveLeft ('a', [1, 1]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveLeft2 = moveLeft ('a', [1, 5]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveLeft3 = moveLeft ('a', [1, 2]) ["-----a","a-----","-aaa-b","-baa--","-a-a-a", "-aa---"] 0
testMoveLeft4 = moveLeft ('a', [1, 4]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "aa----"] 0

testMoveRight = moveRight ('a', [1, 0]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 5
testMoveRight1 = moveRight ('a', [1, 1]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 5
testMoveRight2 = moveRight ('a', [1, 5]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 5
testMoveRight3 = moveRight ('a', [1, 2]) ["-----a","a-----","-aaa-b","-baa--","-a-a-a", "-aa---"] 5
testMoveRight4 = moveRight ('a', [1, 4]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "aa----"] 5

testMoveUp = moveUp ('a', [1, 0]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveUp1 = moveUp ('a', [1, 1]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveUp2 = moveUp ('a', [1, 5]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 0
testMoveUp3 = moveUp ('a', [1, 2]) ["-----a","a-----","-aaa-b","-baa--","-a-a-a", "-aa---"] 0
testMoveUp4 = moveUp ('a', [1, 4]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "aa----"] 0

testMoveDown = moveDown ('a', [1, 0]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 5
testMoveDown1 = moveDown ('a', [1, 1]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 5
testMoveDown2 = moveDown ('a', [1, 5]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "-aa---"] 5
testMoveDown3 = moveDown ('a', [1, 2]) ["-----a","a-----","-aaa-b","-baa--","-a-a-a", "-aa---"] 5
testMoveDown4 = moveDown ('a', [1, 4]) ["-----a","a-----","-aaa--","--aa--","-a-a-a", "aa----"] 5

testGNS = printStrMatrix (generateNewStates ["--B---","--B---","XXB---","--AA--","------", "------"])
testGNS2 = printStrMatrix (generateNewStates ["--B---","--B---","XXB---","AA----","------", "------"])
testGNS3 = printStrMatrix (generateNewStates ["------","------","XX----","AAB---","--B---", "--B---"])

testRushHour = printStrMatrix (rush_hour ["--B---","--B---","XXB---","--AA--","------", "------"])
-- End Test Functions

rush_hour :: [String] -> [[String]]
rush_hour startState = reverse (statesearch [startState] [[]])

statesearch :: [[String]] -> [[String]] -> [[String]]
statesearch unexplored path
   | null unexplored              = []
   | elem (head unexplored) path  = statesearch (tail unexplored) path 
   | checkGoal (head unexplored)  = (head unexplored):path
   | (not (null result))          = result
   | otherwise                    = 
        statesearch (tail unexplored) path
     where result = statesearch 
                       (generateNewStates (head unexplored)) 
                       ((head unexplored):path)


checkGoal :: [String] -> Bool
checkGoal map = ('X' == ((map !! 2) !! 5))

					   
-- generateNewStates
generateNewStates :: [String] -> [[String]]
generateNewStates map = generateNewStatesIterator (getCarStats map) map

generateNewStatesIterator :: [(Char, [Int])] -> [String] -> [[String]]
generateNewStatesIterator carTuple map
	| null carTuple				= []
	| otherwise				= 
		(generateNewStatesHelper (head carTuple) map) ++ (generateNewStatesIterator (tail carTuple) map)
	
generateNewStatesHelper :: (Char, [Int]) -> [String] -> [[String]]
generateNewStatesHelper carTuple map
	-- horizontal car
	| (snd carTuple) !! 0 == 1		= [moveLeft carTuple map 0] ++ [moveRight carTuple map 5]
	-- vertical car
	| otherwise  					= [moveUp carTuple map 0] ++ [moveDown carTuple map 5]


-- Moving Cars
-- move up
moveUp :: (Char, [Int]) -> [String] -> Int -> [String]
moveUp carTuple map index
	| index > 4									= map
--	| current == (fst carTuple)					= map
	-- check the current cell
	| currentCell /= '-'						= moveUp carTuple map (index + 1)
	-- check the cell below
	| ((map !! (index + 1)) !! (snd carTuple !! 1)) /= (fst carTuple)	
												= moveUp carTuple map (index + 1)
	| otherwise									=
		moveUp
			carTuple
			-- get head of unaffected map
			((nthhead index map) ++
			-- get the current row + replace cell with car
			[(nthhead ((snd carTuple) !! 1) (map !! index)) ++ 
			((fst carTuple):(nthtail ((snd carTuple) !! 1) (map !! index)))] ++ 
			-- get the next row + replace cell with space
			[(nthhead ((snd carTuple) !! 1) (map !! (index + 1))) ++ 
			('-':(nthtail ((snd carTuple) !! 1) (map !! (index + 1))))] ++ 
			-- get rest of unaffected map
			(nthtail (index + 1) map))
			(index + 1)
	where currentCell = ((map !! index) !! (snd carTuple !! 1))
	
-- move down
moveDown :: (Char, [Int]) -> [String] -> Int -> [String]
moveDown carTuple map index
	| index <= 0								= map
	-- check the current cell
	| currentCell /= '-'				= moveDown carTuple map (index - 1)
	-- check the cell above
	| ((map !! (index - 1)) !! (snd carTuple !! 1)) /= 	(fst carTuple)
												= moveDown carTuple map (index - 1)
	| otherwise									=
		moveDown
			carTuple
			-- get head of unaffected map
			((nthhead (index - 1) map) ++
			-- get the above row + replace cell with space
			[(nthhead ((snd carTuple) !! 1) (map !! (index - 1))) ++ 
			('-':(nthtail ((snd carTuple) !! 1) (map !! (index - 1))))] ++
			-- get the current row + replace cell with car
			[(nthhead ((snd carTuple) !! 1) (map !! index)) ++ 
			((fst carTuple):(nthtail ((snd carTuple) !! 1) (map !! index)))] ++ 
			-- get rest of unaffected map
			(nthtail (index) map))
			(index - 1)
	where currentCell = ((map !! index) !! (snd carTuple !! 1))

-- move left
moveLeft :: (Char, [Int]) -> [String] ->  Int -> [String]
moveLeft carTuple map index
	| index > 4									= map
--	| carRow !! index == fst carTuple			= map
	| carRow !! index /= '-' 					= moveLeft carTuple map (index + 1)
	| carRow !! (index + 1) /= fst carTuple		= moveLeft carTuple map (index + 1)
	| otherwise 								= 
		moveLeft 
			carTuple 
			((nthhead ((snd carTuple) !! 1) map) ++
			[(nthhead (index) carRow) ++ 
			((fst carTuple):'-':(nthtail (index + 1) (carRow)))] ++
			(nthtail ((snd carTuple) !! 1 ) map))
			(index + 1)
	where carRow = (map !! ((snd carTuple) !! 1))

-- move right
moveRight :: (Char, [Int]) -> [String] ->  Int -> [String]
moveRight carTuple map index
	| index <= 0								= map
	| carRow !! (index - 1) /= fst carTuple		= moveRight carTuple map (index - 1)
	| carRow !! index /= '-'					= moveRight carTuple map (index - 1)
	| otherwise 								= 
		moveRight 
			carTuple 
			((nthhead ((snd carTuple) !! 1) map) ++
			[(nthhead (index - 1) carRow) ++ 
			('-':(fst carTuple):(nthtail (index) (carRow)))] ++
			(nthtail ((snd carTuple) !! 1 ) map))
			(index - 1)
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



-- tuple: car [dir, row/col]
-- get All cars' direction and location
-- row car = 1
-- col car = 0
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
removeduplicates check
	| null check					= []
	| (head check) == '-'				= removeduplicates (tail check)
	| elem (head check) (tail check)	= removeduplicates (tail check)
	| otherwise							= (head check):removeduplicates (tail check)
	
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
printStrMatrix :: [[String]] -> IO ()
printStrMatrix [] = printStrList []
printStrMatrix (x:xs) = do
    printStrList x
    printStrMatrix xs

-- Print nicely a list of strings.
-- Eg: printStrList ["aabb", "ccdd", "eeff"] prints in the console:
-- aabb
-- ccdd
-- eeff
printStrList :: [String] -> IO ()
printStrList [] = putStrLn ""
printStrList (x:xs) = do
    putStrLn x
    printStrList xs