module Updates.GameUpdate exposing (update)

import Types exposing (..)
import Random
import RandomGenerators exposing (randomDoorGenerator, scrambleDoorsCmd)
import Ports exposing (playSound)


bananaSound : String
bananaSound =
    "img/banana.wav"


goatSound : String
goatSound =
    "img/bleeeat.wav"


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
                    case model.selectedDoor of
                        Nothing ->
                            (Debug.crash "What are you confirming??")

                        Just selectedDoor ->
                            List.filter
                                (\d -> (d /= selectedDoor) && (d.prize /= Banana))
                                model.doors
            in
                ( model
                , Random.generate
                    RandomlyOpenDoor
                    (randomDoorGenerator unSelectedGoatDoors)
                )

        RandomlyOpenDoor openedDoor ->
            case openedDoor of
                Nothing ->
                    (Debug.crash "There should be a goat to reveal! But I couldn't find one...")

                Just door ->
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

        ScrambleDoors scrambledDoors ->
            ( { model | doors = scrambledDoors }, Cmd.none )

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

        NoOp ->
            ( model, Cmd.none )
