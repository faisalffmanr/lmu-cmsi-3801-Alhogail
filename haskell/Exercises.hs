module Exercises
    ( change,
      firstThenApply,
      powers,
      meaningfulLineCount,
      Shape(..),
      volume,
      surfaceArea,
      BST(Empty),
      emptyTree,
      insert,
      contains,
      size,
      inorder
    ) where

import qualified Data.Map as Map
import Data.List (isPrefixOf, find)
import Data.Char (isSpace)
import Data.Maybe (listToMaybe)
import Data.Text (pack, unpack, toLower)

-- Change function
change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
  where
    changeHelper [] _ counts = counts
    changeHelper (d:ds) remaining counts =
        changeHelper ds newRemaining (Map.insert d count counts)
      where
        (count, newRemaining) = remaining `divMod` d

-- firstThenApply function
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs p f = fmap f (find p xs)

-- Infinite powers generator
powers :: Integral a => a -> [a]
powers base = map (base ^) [0..]

-- Meaningful line count function
meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount filePath = do
    contents <- readFile filePath
    let linesOfFile = lines contents
    let meaningfulLines = filter isMeaningfulLine linesOfFile
    return (length meaningfulLines)

isMeaningfulLine :: String -> Bool
isMeaningfulLine line =
    any (not . isSpace) trimmed && not (isPrefixOf "#" trimmed)
  where
    trimmed = dropWhile isSpace line

-- Shape data type with volume and surface area functions
data Shape 
  = Sphere Double
  | Box Double Double Double
  deriving (Eq, Show)

-- Calculate the volume of a shape
volume :: Shape -> Double
volume (Sphere r) = (4 / 3) * pi * r^3
volume (Box l w h) = l * w * h

-- Calculate the surface area of a shape
surfaceArea :: Shape -> Double
surfaceArea (Sphere r) = 4 * pi * r^2
surfaceArea (Box l w h) = 2 * (l * w + l * h + w * h)

-- Binary Search Tree implementation
data BST a
  = Empty
  | Node a (BST a) (BST a)
  deriving (Eq)

-- Show instance for BST to match expected format in tests
instance Show a => Show (BST a) where
    show Empty = "()"
    show (Node value Empty Empty) = "(" ++ show value ++ ")"  -- Single node
    show (Node value left right) =
        "(" ++ show left ++ show value ++ show right ++ ")"

-- Create an empty tree
emptyTree :: BST a
emptyTree = Empty

-- Insert a value into the binary search tree
insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
    | x < y = Node y (insert x left) right
    | x > y = Node y left (insert x right)
    | otherwise = Node y left right -- Ignore duplicates

-- Check if a value is contained in the binary search tree
contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains x (Node y left right)
    | x < y = contains x left
    | x > y = contains x right
    | otherwise = True

-- Calculate the size of the binary search tree
size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

-- In-order traversal of the binary search tree
inorder :: BST a -> [a]
inorder Empty = []
inorder (Node x left right) = inorder left ++ [x] ++ inorder right
