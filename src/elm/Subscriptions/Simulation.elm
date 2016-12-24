module Subscriptions.Simulation exposing (..)

import Time
import Types exposing (..)


subscription : Model -> Sub Msg
subscription model =
    -- Time.every (100) (always SimulateOnce)
    Sub.none
