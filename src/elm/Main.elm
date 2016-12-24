module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import View
import RandomGenerators exposing (scrambleDoorsCmd)
import Updates.RootUpdate as RootUpdate
import Subscriptions.KeyboardSubscriptions as KeyboardSubscriptions
import Subscriptions.Simulation as Simulation


initialModel : Model
initialModel =
    { currentGame =
        { doors = []
        , selectedDoor = Nothing
        , revealedDoor = Nothing
        , finalDoor = Nothing
        }
    , results =
        { stayed =
            { win = 0, lose = 0 }
        , switched =
            { win = 0, lose = 0 }
        }
    , isCheating = False
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, scrambleDoorsCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    -- pass the model to each subscription,
    -- then batch so Html.program can consume it
    Sub.batch
        (List.map
            ((|>) model)
            [ KeyboardSubscriptions.subscription, Simulation.subscription ]
        )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = RootUpdate.update
        , subscriptions = subscriptions
        , view = View.rootView
        }
