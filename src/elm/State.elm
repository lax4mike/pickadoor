module State exposing (..)

import Types exposing (..)
import Random
import RandomGenerators exposing (..)
import Ports exposing (..)
import Keyboard exposing (KeyCode)
import Char


-- INIT


bananaSound : String
bananaSound =
    "img/banana.wav"


goatSound : String
goatSound =
    "img/bleeeat.wav"


initialModel : Model
initialModel =
    { currentGame =
        { doors = []
        , selectedDoor = Nothing
        , revealedDoor = Nothing
        , finalDoor = Nothing
        }
    , results =
        { stayed =
            { win = 0, lose = 0 }
        , switched =
            { win = 0, lose = 0 }
        }
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, scrambleDoorsCmd )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newCurrentGame, gameCmd ) =
            updateCurrentGame msg model.currentGame

        oldResults =
            model.results

        incrementWin { win, lose } =
            { win = win + 1, lose = lose }

        incrementLose { win, lose } =
            { win = win, lose = lose + 1 }

        newResults =
            case msg of
                -- if the game is done, add it to the history
                SelectFinalDoor door ->
                    case getGameResult newCurrentGame of
                        StayedWon ->
                            { oldResults
                                | stayed = incrementWin oldResults.stayed
                            }

                        StayedLost ->
                            { oldResults
                                | stayed = incrementLose oldResults.stayed
                            }

                        SwitchedWon ->
                            { oldResults
                                | switched = incrementWin oldResults.switched
                            }

                        SwitchedLost ->
                            { oldResults
                                | switched = incrementLose oldResults.switched
                            }

                        NotDone ->
                            oldResults

                _ ->
                    model.results
    in
        ( { model
            | currentGame = newCurrentGame
            , results = newResults
          }
        , gameCmd
        )


getGameResult : GameModel -> GameResult
getGameResult game =
    Maybe.withDefault NotDone
        (Maybe.map2 (,) game.finalDoor game.selectedDoor
            |> Maybe.andThen
                (\( finalDoor, selectedDoor ) ->
                    if (finalDoor == selectedDoor) then
                        case finalDoor.prize of
                            Banana ->
                                Just StayedWon

                            Goat ->
                                Just StayedLost
                    else
                        case finalDoor.prize of
                            Banana ->
                                Just SwitchedWon

                            Goat ->
                                Just SwitchedLost
                )
        )


updateCurrentGame : Msg -> GameModel -> ( GameModel, Cmd Msg )
updateCurrentGame msg model =
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



-- SUBSCRIPTIONS


keycodeToMaybeDoor : List Door -> KeyCode -> Maybe Door
keycodeToMaybeDoor doors keyCode =
    keyCode
        |> Char.fromCode
        |> String.fromChar
        |> String.toInt
        |> Result.toMaybe
        |> Maybe.map (flip (-) 1)
        |> Maybe.map (flip List.drop doors)
        |> Maybe.andThen List.head


subscriptions : Model -> Sub Msg
subscriptions { currentGame } =
    case getProgress currentGame of
        Start ->
            Keyboard.downs
                (\keyCode ->
                    case (keycodeToMaybeDoor currentGame.doors keyCode) of
                        Just pressedDoor ->
                            (SelectFirstDoor pressedDoor)

                        Nothing ->
                            NoOp
                )

        FirstDoorSelected selectedDoor ->
            Keyboard.downs
                (\keyCode ->
                    case (keycodeToMaybeDoor currentGame.doors keyCode) of
                        Just pressedDoor ->
                            if (pressedDoor == selectedDoor) then
                                ConfirmDoor
                            else
                                SelectFirstDoor pressedDoor

                        Nothing ->
                            NoOp
                )

        RandomDoorRevealed revealedDoor ->
            Keyboard.downs
                (\keyCode ->
                    case (keycodeToMaybeDoor currentGame.doors keyCode) of
                        Just door ->
                            (SelectFinalDoor door)

                        Nothing ->
                            NoOp
                )

        SwitchedOrStayed finalDoor ->
            -- reset on any keypress
            Keyboard.downs
                (\keyCode -> Reset)
