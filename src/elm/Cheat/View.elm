module Cheat.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


{-| only show this if the user has won at least once by switching and staying
-}
render : Model -> Html Msg
render model =
    if (model.results.stayed.win > 0 && model.results.switched.win > 0) then
        div [ class "cheat-container" ]
            [ label []
                [ input [ type_ "checkbox", onCheck ToggleCheat ] []
                , text " cheat"
                ]
            ]
    else
        text ""
