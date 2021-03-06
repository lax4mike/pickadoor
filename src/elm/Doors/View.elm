module Doors.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Doors.Door.View as Door


render : GameModel -> Html Msg
render model =
    div [ class "doors" ]
        (List.map
            (\door ->
                let
                    open =
                        (isDoorOpen model door)

                    clickMsg : Door -> Msg
                    clickMsg =
                        case getProgress model of
                            Start ->
                                SelectFirstDoor

                            -- change selection, or confirm
                            FirstDoorSelected door ->
                                case model.selectedDoor of
                                    Nothing ->
                                        SelectFirstDoor

                                    Just selected ->
                                        (\clickedDoor ->
                                            if clickedDoor == selected then
                                                ConfirmDoor
                                            else
                                                SelectFirstDoor clickedDoor
                                        )

                            RandomDoorRevealed door ->
                                SelectFinalDoor

                            SwitchedOrStayed door ->
                                (\clickedDoor -> Reset)
                in
                    Door.render
                        { isSelected = (isSelected model.selectedDoor door)
                        , isOpen = open
                        , onClick = clickMsg
                        , door = door
                        }
            )
            model.doors
        )


isSelected : Maybe Door -> Door -> Bool
isSelected selectedDoor door =
    case selectedDoor of
        Just d ->
            (d == door)

        Nothing ->
            False
