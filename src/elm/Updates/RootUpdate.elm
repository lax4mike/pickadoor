module Updates.RootUpdate exposing (..)

import Types exposing (..)
import Updates.GameUpdate as GameUpdate
import Updates.ResultsUpdate as ResultsUpdate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newCurrentGame, gameCmd ) =
            GameUpdate.update msg model.currentGame

        -- pass the new game to the results updater so it can update as
        -- soon as the game is finished (before it resets)
        newResults =
            ResultsUpdate.update msg model.results newCurrentGame

        newIsCheating =
            case msg of
                ToggleCheat cheat ->
                    cheat

                _ ->
                    model.isCheating
    in
        ( { model
            | currentGame = newCurrentGame
            , results = newResults
            , isCheating = newIsCheating
          }
        , gameCmd
        )
