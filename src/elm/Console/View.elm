module Console.View exposing (..)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


render : Model -> Html Msg
render model =
    div [ class "console" ]
        [ div [ class "console__instructions" ] (renderInstructions model)
        , div [ class "console__action" ] [ renderButton model ]
        ]


renderInstructions : Model -> List (Html Msg)
renderInstructions model =
    case getProgress model of
        Start ->
            [ p []
                [ text "Behind one of these doors is a car."
                , br [] []
                , text "Behind the other two are goats."
                ]
            , p [] [ text "Pick the car to win!" ]
            ]

        FirstDoorSelected selectedDoor ->
            [ p [] [ text ("You have chosen door " ++ selectedDoor.name ++ ".") ]
            , p [] [ text ("We will now show you another door.") ]
            ]

        RandomDoorRevealed revealedDoor ->
            [ p []
                [ text ("There is a goat behind door " ++ revealedDoor.name ++ ".")
                , br [] []
                , text "Would you like to change your choice?"
                ]
            , p []
                [ text "Click the same door if you wish to stay"
                , br [] []
                , text "or click the other door to change"
                ]
            ]

        SwitchedOrStayed door ->
            case door.prize of
                Banana ->
                    [ p []
                        [ text "You win!!"
                        , br [] []
                        , text "but I lied..."
                        , br [] []
                        , text "You won a Banana!!"
                        ]
                    ]

                Goat ->
                    [ div []
                        [ p [] [ text "You lose." ]
                        , p [] [ text "You got a stinking goat." ]
                        ]
                    ]


renderButton : Model -> Html Msg
renderButton model =
    case getProgress model of
        Start ->
            div [] []

        FirstDoorSelected door ->
            div [] [ button [ type_ "button", (onClick ConfirmDoor) ] [ text "Show me!" ] ]

        RandomDoorRevealed revealedDoor ->
            div [] []

        SwitchedOrStayed door ->
            div [] [ button [ type_ "button", (onClick Reset) ] [ text "Play again?" ] ]
