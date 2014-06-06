module Main where

import Perf.Runner (..)
import Perf.Benchmark (..)

--fib : Int -> Int
--fib n =  case n of
--          0 -> 1
--          1 -> 1
--          _ -> fib (n-1) + fib (n-2)

--fibWrapper : Int -> ()
--fibWrapper n = let _ = fib n in ()

--fibMark : Benchmark
--fibMark = logicGroup "high fibonacci" fibWrapper [20..30]



--circleWrapper : Int -> Element
--circleWrapper n = collage 200 200 [filled red <| circle <| toFloat n]

--visMark : Benchmark
--visMark = view "Circle" circleWrapper [10,50]

benchmark : (Signal Element, Signal Time)
benchmark = run <| view "asText" asText ["Hello","World"]

showBoth : Element -> Time -> Element
showBoth element time = asText time `above` element

main : Signal Element
main = case benchmark of
  (selement, stime) -> lift2 showBoth selement stime
  _ -> lift (\_ -> asText "The impossible has happened") (constant 0)