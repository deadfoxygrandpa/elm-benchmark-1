module Main where

import Perf.Runner (..)
import Perf.Benchmark (..)

fib : Int -> Int
fib n =  case n of
          0 -> 1
          1 -> 1
          _ -> fib (n-1) + fib (n-2)

fibWrapper : Int -> ()
fibWrapper n = let _ = fib n in ()

fibMark : Benchmark
fibMark = logicGroup "high fibonacci" fibWrapper [35..40]



circleWrapper : Int -> Element
circleWrapper n = collage 200 200 [filled red <| circle <| toFloat n]

visMark : Benchmark
visMark = view "Circle" circleWrapper [10..50]

visSimple : Benchmark
visSimple = view "asText" asText ["Hello","World"]

groupMark : Benchmark
groupMark = Group "groupMark"
                [ visMark
                , visMark
                ]

runner : Signal Result
runner = run <| groupMark

showBoth : (Element, [Time]) -> Element
showBoth (element, times) = asText times `above` element



main : Signal Element
main = lift display runner