module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Doors.View as Doors
import Console.View as Console
import GameResults.View as GameResults


rootView : Model -> Html Msg
rootView model =
    case List.length model.currentGame.doors of
        0 ->
            div [ class "container" ] [ text "Randomizing..." ]

        _ ->
            div [ class "container" ]
                [ Doors.render model.currentGame
                , div [ class "bottom" ]
                    [ GameResults.render model.results
                    , Console.render model.currentGame
                    ]
                ]
