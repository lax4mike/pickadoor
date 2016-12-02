module Doors.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Door.View as Door


render : Model -> Html Msg
render model =
    let
        clickMsg =
            case getProgress model of
                Start ->
                    SelectFirstDoor

                -- change selection
                FirstDoorSelected door ->
                    SelectFirstDoor

                RandomDoorRevealed door ->
                    SelectFinalDoor

                _ ->
                    (\d -> NoOp)
    in
        div [ class "doors" ]
            (List.map
                (\door ->
                    Door.render
                        { isSelected = (isSelected model.selectedDoor door)
                        , isOpen = (isOpen model door)
                        , onClick = clickMsg
                        , door = door
                        }
                )
                model.doors
            )


isOpen : Model -> Door -> Bool
isOpen { revealedDoor, finalDoor } door =
    let
        isMaybeEqual a maybeB =
            case maybeB of
                Nothing ->
                    False

                Just b ->
                    a == b
    in
        List.any (isMaybeEqual door) [ revealedDoor, finalDoor ]


isSelected : Maybe Door -> Door -> Bool
isSelected selectedDoor door =
    case selectedDoor of
        Just d ->
            (d == door)

        Nothing ->
            False
