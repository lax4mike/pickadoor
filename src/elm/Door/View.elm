module Door.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


render : Bool -> Door -> Html Msg
render isSelected door =
    div [ (class "door__frame "), (onClick <| SelectDoor door) ]
        [ div
            [ classList
                [ ( "door", True )
                , ( "is-open", door.isOpened )
                , ( "is-selected", isSelected )
                ]
            ]
            [ div [ class "door__knob" ] []
            ]
        , div [ class "door__prize" ] [ renderPrize door ]
        ]


renderPrize : Door -> Html Msg
renderPrize { prize } =
    case prize of
        Banana ->
            img [ src "img/banana.gif" ] []

        Goat ->
            img [ src "img/goat.png" ] []
