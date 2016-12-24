module Controls.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Json.Decode


{-| only show this if the user has won at least once by switching and staying
-}
render : Model -> Html Msg
render model =
    let
        cheat =
            if (model.results.stayed.win > 0 && model.results.switched.win > 0) then
                div [ class "controls__cheat" ]
                    [ label []
                        [ input [ type_ "checkbox", onCheck ToggleCheat ] []
                        , text " cheat"
                        ]
                    ]
            else
                text ""

        onClickPreventDefault : Msg -> Attribute Msg
        onClickPreventDefault msg =
            onWithOptions "click" { stopPropagation = True, preventDefault = True } (Json.Decode.succeed msg)
    in
        div [ class "controls" ]
            [ a [ href "#", onClickPreventDefault SimulateABunch ]
                [ text "simulate 100 times" ]
            , text " - "
            , a
                [ href "#", onClickPreventDefault SimulateOnce ]
                [ text "simulate once" ]
            , cheat
            ]
