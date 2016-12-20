module RandomGenerators exposing (..)

import Random
import Types exposing (..)


scrambleDoorsCmd : Cmd Msg
scrambleDoorsCmd =
    Random.generate ScrambleDoors (scrambleDoorsGenerator 3)


scrambleDoorsGenerator : Int -> Random.Generator (List Door)
scrambleDoorsGenerator doorCount =
    Random.map
        -- random bananaIndex
        (\bananaIndex ->
            -- create a list of length doorCount
            (List.range 1 doorCount)
                |> List.indexedMap
                    (\index num ->
                        let
                            prize =
                                if (bananaIndex == index) then
                                    Banana
                                else
                                    Goat
                        in
                            (Door ("#" ++ (toString num)) prize)
                    )
        )
        (Random.int 0 (doorCount - 1))


randomDoorGenerator : List Door -> Random.Generator (Maybe Door)
randomDoorGenerator doors =
    Random.map
        (\i ->
            List.drop i doors |> List.head
        )
        (Random.int 0 ((List.length doors) - 1))
