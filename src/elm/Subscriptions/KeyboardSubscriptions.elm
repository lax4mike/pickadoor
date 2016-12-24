module Subscriptions.KeyboardSubscriptions exposing (..)

import Types exposing (..)
import Keyboard exposing (KeyCode)
import Char


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


isSpaceOrEnter : KeyCode -> Bool
isSpaceOrEnter keyCode =
    (keyCode == 32) || (keyCode == 13)


subscription : Model -> Sub Msg
subscription { currentGame } =
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
                    if (isSpaceOrEnter keyCode) then
                        ConfirmDoor
                    else
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
