module RandomGenerators exposing (..)

import Random
import Types exposing (..)
import GameHelpers exposing (getUnselectedGoatDoors, getUnopenedDoors)


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


{-| generate values for selectedDoor, revealedDoor, and finalDoor
-}
gameGenerator : GameModel -> Random.Generator GameModel
gameGenerator gameModel =
    -- start with no selections
    gameModel
        |> (\gameModel ->
                -- randomly select the first door
                Random.map
                    (\randomDoor ->
                        { gameModel
                            | selectedDoor = randomDoor
                        }
                    )
                    (randomDoorGenerator gameModel.doors)
           )
        |> Random.andThen
            (\gameModel ->
                -- randomly selected a revealed door
                Random.map
                    (\randomDoor ->
                        { gameModel
                            | revealedDoor = randomDoor
                        }
                    )
                    (randomDoorGenerator (getUnselectedGoatDoors gameModel))
            )
        |> Random.andThen
            (\gameModel ->
                -- randomly stay or switch
                Random.map
                    (\randomDoor ->
                        { gameModel
                            | finalDoor = randomDoor
                        }
                    )
                    (randomDoorGenerator (getUnopenedDoors gameModel))
            )


randomDoorGenerator : List Door -> Random.Generator (Maybe Door)
randomDoorGenerator doors =
    Random.map
        (\i ->
            List.drop i doors |> List.head
        )
        (Random.int 0 ((List.length doors) - 1))
