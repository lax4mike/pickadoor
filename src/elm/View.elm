module View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Doors.View as Doors
import Console.View as Console


rootView : Model -> Html Msg
rootView model =
    div [ class "container" ]
        [ Doors.render model
        , Console.render model
        ]
