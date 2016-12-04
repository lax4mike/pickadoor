module State exposing (..)

import Types exposing (..)
import Random
import Ports exposing (..)


-- INIT


bananaSound =
    "img/banana.wav"


goatSound =
    "img/bleeeat.wav"


initialModel : Model
initialModel =
    { doors = []
    , selectedDoor = Nothing
    , revealedDoor = Nothing
    , finalDoor = Nothing
    }


scrambleDoorsCmd : Cmd Msg
scrambleDoorsCmd =
    Random.generate ScrambleDoors (scrambleDoorsGenerator 3)


init =
    ( initialModel, scrambleDoorsCmd )


scrambleDoorsGenerator : Int -> Random.Generator (List Door)
scrambleDoorsGenerator doorCount =
    Random.map
        (\bananaIndex ->
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



-- randomizeDoors
-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
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
                    Debug.crash "There should be a goat to reveal! But I couldn't find one..."

                Just door ->
                    ( { model | revealedDoor = openedDoor }, playSound goatSound )

        SelectFinalDoor clickedDoor ->
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


randomDoorGenerator : List Door -> Random.Generator (Maybe Door)
randomDoorGenerator doors =
    Random.map
        (\i ->
            List.drop i doors |> List.head
        )
        (Random.int 0 ((List.length doors) - 1))



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
