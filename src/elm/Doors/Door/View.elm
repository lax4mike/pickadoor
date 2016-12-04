module Doors.Door.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias DoorParams =
    { isSelected : Bool
    , isOpen : Bool
    , onClick : Door -> Msg
    , door : Door
    }


render : DoorParams -> Html Msg
render { isSelected, isOpen, onClick, door } =
    div
        [ classList
            [ ( "door", True )
            , ( "is-open", isOpen )
            , ( "is-selected", isSelected )
            ]
        , (Html.Events.onClick <| onClick door)
        ]
        [ div [ class "door__prize" ] [ renderPrize door ]
        , div [ class "door__frame" ]
            [ div
                [ class "door__door"
                ]
                [ div [ class "door__knob" ] []
                , div [ class "door__sign" ] [ text door.name ]
                ]
            ]
        ]


renderPrize : Door -> Html Msg
renderPrize { prize } =
    case prize of
        Banana ->
            img [ src "img/banana.gif" ] []

        Goat ->
            img [ src "img/goat.png" ] []
