module Doors.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Door.View as Door


render : Model -> Html Msg
render { doors, selectedDoor } =
    div [ class "doors" ]
        (List.map
            (\d ->
                (Door.render (isSelected selectedDoor d) d)
            )
            doors
        )


isSelected : Maybe Door -> Door -> Bool
isSelected selectedDoor door =
    case selectedDoor of
        Just d ->
            d == door

        Nothing ->
            False
