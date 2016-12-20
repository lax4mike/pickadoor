module GameResults.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


render : GameResults -> Html Msg
render results =
    div [ class "results" ]
        [ table []
            [ tr []
                [ th [] []
                , th [] [ text "Win" ]
                , th [] [ text "Lose" ]
                , th [] [ text "Win %" ]
                ]
            , tr []
                [ th [] [ text "Stayed" ]
                , td [] [ text (toString results.stayed.win) ]
                , td [] [ text (toString results.stayed.lose) ]
                , td [] [ text (getWinPercentage results.stayed) ]
                ]
            , tr []
                [ th [] [ text "Switched" ]
                , td [] [ text (toString results.switched.win) ]
                , td [] [ text (toString results.switched.lose) ]
                , td [] [ text (getWinPercentage results.switched) ]
                ]
            ]
        ]


getWinPercentage : { win : Int, lose : Int } -> String
getWinPercentage { win, lose } =
    if (win + lose == 0) then
        "0%"
    else
        ((toFloat win / toFloat (win + lose))
            |> (*) 100
            |> round
            |> toString
        )
            ++ "%"
