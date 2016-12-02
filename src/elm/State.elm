module State exposing (..)

import Types exposing (..)
import Random


-- INIT


initialModel : Model
initialModel =
    { doors =
        [ (Door "#1" False Banana)
        , (Door "#2" False Goat)
        , (Door "#3" False Goat)
        ]
    , selectedDoor = Nothing
    }



-- randomizeDoors
-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectDoor clickedDoor ->
            let
                openDoors =
                    (List.filter (.isOpened) model.doors)
            in
                case List.length openDoors of
                    -- first selection
                    0 ->
                        ( { model | selectedDoor = Just clickedDoor }, Cmd.none )

                    -- stay or confirm
                    1 ->
                        let
                            newDoors =
                                openThisDoor clickedDoor model.doors

                            newModel =
                                { model | doors = newDoors, selectedDoor = Just clickedDoor }
                        in
                            ( newModel, Cmd.none )

                    -- otherwise, don't do anything
                    _ ->
                        ( model, Cmd.none )

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

        RandomlyOpenDoor maybeDoor ->
            case maybeDoor of
                Nothing ->
                    ( model, Cmd.none )

                Just door ->
                    let
                        newDoors =
                            openThisDoor door model.doors
                    in
                        ( { model | doors = newDoors }, Cmd.none )

        Reset ->
            ( initialModel, Cmd.none )


{-| mini update just for the doors
-}
openThisDoor : Door -> Doors -> Doors
openThisDoor doorToOpen doors =
    (List.map
        (\door ->
            if door == doorToOpen then
                { door | isOpened = True }
            else
                door
        )
        doors
    )


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
