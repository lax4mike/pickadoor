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
        -- make it hidden instead of display none so the simulate link doesn't jump
        shouldShowCheat =
            if (model.results.stayed.win > 0 && model.results.switched.win > 0) then
                "visible"
            else
                "hidden"

        onClickPreventDefault : Msg -> Attribute Msg
        onClickPreventDefault msg =
            onWithOptions "click" { stopPropagation = True, preventDefault = True } (Json.Decode.succeed msg)
    in
        div [ class "controls" ]
            [ a [ href "#", onClickPreventDefault (SimulateABunch 100) ]
                [ text "simulate 100 times" ]
              -- , a
              --     [ href "#", onClickPreventDefault SimulateOnce ]
              --     [ text "simulate once" ]
            , div
                [ class "controls__cheat", style [ ( "visibility", shouldShowCheat ) ] ]
                [ label []
                    [ input [ type_ "checkbox", onCheck ToggleCheat ] []
                    , text " cheat"
                    ]
                ]
            ]
