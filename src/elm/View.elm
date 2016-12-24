module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import Doors.View as Doors
import Console.View as Console
import GameResults.View as GameResults
import Controls.View as Controls


rootView : Model -> Html Msg
rootView model =
    case List.length model.currentGame.doors of
        0 ->
            div [ class "container" ] [ text "Randomizing..." ]

        _ ->
            div [ classList [ ( "container", True ), ( "is-cheating", model.isCheating ) ] ]
                [ Doors.render model.currentGame
                , div [ class "bottom" ]
                    [ div []
                        [ GameResults.render model.results
                        , Controls.render model
                        ]
                    , Console.render model.currentGame
                    ]
                ]
