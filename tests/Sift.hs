{-# LANGUAGE ScopedTypeVariables #-}

module Sift where

import Instances (SizedPositive (SizedPositive), T)
import Properties.StackSet (invariant)
import Utils (applyN, hidden_spaces)
import Test.QuickCheck (quickCheck)

import XMonad.StackSet (index)
import XMonad.Actions.Sift (siftUp, siftDown)

prop_sift_up_I   (SizedPositive n) (x :: T) =
    invariant $ applyN (Just n) siftUp x
prop_sift_down_I (SizedPositive n) (x :: T) =
    invariant $ applyN (Just n) siftDown x

prop_sift_up   (x :: T) = siftUp  (siftDown x) == x
prop_sift_down (x :: T) = siftDown (siftUp  x) == x

prop_sift_up_local   (x :: T) = hidden_spaces x == hidden_spaces (siftUp   x)
prop_sift_down_local (x :: T) = hidden_spaces x == hidden_spaces (siftDown x)

prop_sift_up_cycle (x :: T) =
  foldr (const siftUp)   x [1..k] == x
  where n = length (index x)
        k = n * (n - 1)
prop_sift_down_cycle (x :: T) =
  foldr (const siftDown) x [1..k] == x
  where n = length (index x)
        k = n * (n - 1)

main :: IO ()
main = do
  putStrLn "Testing siftUp invariant"
  quickCheck prop_sift_up_I
  putStrLn "Testing siftDown invariant"
  quickCheck prop_sift_down_I

  putStrLn "Testing siftUp reversible"
  quickCheck prop_sift_up
  putStrLn "Testing siftDown reversible"
  quickCheck prop_sift_down

  putStrLn "Testing siftUp local"
  quickCheck prop_sift_up_local
  putStrLn "Testing siftDown local"
  quickCheck prop_sift_down_local

  putStrLn "Testing siftUp cycle"
  quickCheck prop_sift_up_cycle
  putStrLn "Testing siftDown cycle"
  quickCheck prop_sift_down_cycle
