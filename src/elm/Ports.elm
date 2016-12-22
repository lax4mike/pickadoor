port module Ports exposing (..)


bananaSound : String
bananaSound =
    "img/banana.wav"


goatSound : String
goatSound =
    "img/bleeeat.wav"


port playSound : String -> Cmd msg
