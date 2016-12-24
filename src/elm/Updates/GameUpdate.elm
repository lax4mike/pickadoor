module Updates.GameUpdate exposing (update)

import GameHelpers exposing (getUnselectedGoatDoors)
import Ports exposing (playSound, bananaSound, goatSound)
import Random
import RandomGenerators exposing (randomDoorGenerator, gameGenerator, scrambleDoorsCmd)
import Task
import Time
import Types exposing (..)


update : Msg -> GameModel -> ( GameModel, Cmd Msg )
update msg model =
    case msg of
        SelectFirstDoor clickedDoor ->
            ( { model | selectedDoor = Just clickedDoor }, Cmd.none )

        ConfirmDoor ->
            let
                -- either the other Goat, or both Goats
                -- pass this to the random generator to pick one randomly
                unSelectedGoatDoors =
                    getUnselectedGoatDoors model
            in
                ( model
                , Random.generate RandomlyOpenDoor (randomDoorGenerator unSelectedGoatDoors)
                )

        RandomlyOpenDoor openedDoor ->
            ( { model | revealedDoor = openedDoor }, playSound goatSound )

        SelectFinalDoor clickedDoor ->
            -- don't allow clicking of an open door
            if (isDoorOpen model clickedDoor) then
                ( model, Cmd.none )
            else
                let
                    doorSound : String
                    doorSound =
                        case clickedDoor.prize of
                            Banana ->
                                bananaSound

                            Goat ->
                                goatSound
                in
                    ( { model | finalDoor = Just clickedDoor }, playSound doorSound )

        Reset ->
            let
                newModel =
                    { model
                        | selectedDoor = Nothing
                        , revealedDoor = Nothing
                        , finalDoor = Nothing
                    }
            in
                ( newModel, scrambleDoorsCmd )

        ScrambleDoors scrambledDoors ->
            ( { model | doors = scrambledDoors }, Cmd.none )

        SimulateOnce ->
            ( model, Random.generate RecordSimulation (gameGenerator model) )

        RecordSimulation simulatedGame ->
            -- record the simulateion, then reset the game
            ( simulatedGame, Task.perform (always Reset) Time.now )

        _ ->
            ( model, Cmd.none )
