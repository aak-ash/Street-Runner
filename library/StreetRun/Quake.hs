module StreetRun.Quake where

import StreetRun.Types
import StreetRun.CFL
import StreetRun.Step

data Quake
  = Quake'Progress Percent
  | Quake'Dormant Seconds
  deriving (Show, Eq)

stepQuake :: Quake -> Step Quake
stepQuake q@(Quake'Progress p)
  | p' >= 1 = Step'Change q (Quake'Dormant 30)
  | otherwise = Step'Sustain (Quake'Progress p')
  where
    p' = p + 0.02
stepQuake q@(Quake'Dormant s)
  | s' <= 0 = Step'Change q (Quake'Progress 0)
  | otherwise = Step'Sustain (Quake'Dormant s')
  where
    s' = s - frameDeltaSeconds

startQuake :: Step Quake -> Bool
startQuake (Step'Change _ (Quake'Progress _)) = True
startQuake _ = False

quakeAdjust :: Int -> Int -> Quake -> (Int, Int)
quakeAdjust rate scale (Quake'Progress p) =
  ( truncate $ cos (p * 4 * pi * fromIntegral rate) * fromIntegral scale
  , truncate $ sin (p * 2 * pi * fromIntegral rate) * fromIntegral scale )
quakeAdjust _ _ _ = (0,0)

applyQuake :: Int -> Int -> Quake -> (Int, Int) -> (Int, Int)
applyQuake rate scale q (x,y) = (x + x', y + y')
  where
    (x', y') = quakeAdjust rate scale q
