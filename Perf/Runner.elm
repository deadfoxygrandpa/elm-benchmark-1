module Perf.Runner
    ( run
    ) where

import Perf.Types (..)
import Native.Runner
import Either (..)
import Window
import Perf.LineGraph (..)

numRepeats = 10

duplicateEach : Int -> [a] -> [a]
duplicateEach n xs = foldr (++) [] <| map (repeat n) xs

{-| Condenses every N elements in a list with `f`
-}
condenseEach : Int -> ([a] -> a) -> [a] -> [a]
condenseEach n f xs = case xs of
    [] -> []
    ys -> f (take n ys) :: condenseEach n f (drop n ys)

{-| Implicit assumption that we've got the same type of result.
They should all have the same name and the same number of elements in .times
-}
averageResults : [Result] -> Result
averageResults results =
    let n = length results
        times = map .times results
        numberOfData = length <| head times
        summed = foldr (\t s -> zipWith (+) t s) (repeat numberOfData 0) times
        avgs = map (\x -> toFloat (round ((x / toFloat n) * 10))/10 ) summed
    in { name=(head results).name, times=avgs }


{-| For each benchmark, run it 10 times in a row and average the times. If the
benchmark needs to render something, it goes to screen. Once the benchmarks are
completed, the screen will change to display them as a line graph
    
    benchmarks = [ render "Blur image" blurPonyPNG [1..50]
                 , logic  "Compute determinant" [m1, m2, m3, m4]
                 ]
    main = run benchmarks
-}
run : [Benchmark] -> Signal Element
run bms =
    let repeatedBms = duplicateEach numRepeats bms
    in  lift2 display Window.width <| Native.Runner.runMany repeatedBms


display : Int -> Either Element [Result] -> Element
display w elementString = case elementString of
    Left element  -> element
    Right results -> 
        let avgs = condenseEach numRepeats averageResults results
        in  showResults w avgs
