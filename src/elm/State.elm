module State exposing (..)

import Types exposing (..)
import Random


-- INIT


initialModel : Model
initialModel =
    { doors =
        [ (Door "#1" Banana)
        , (Door "#2" Goat)
        , (Door "#3" Goat)
        ]
    , selectedDoor = Nothing
    , revealedDoor = Nothing
    , finalDoor = Nothing
    }



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
                    ( { model | revealedDoor = openedDoor }, Cmd.none )

        SelectFinalDoor clickedDoor ->
            ( { model | finalDoor = Just clickedDoor }, Cmd.none )

        Reset ->
            ( initialModel, Cmd.none )

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
