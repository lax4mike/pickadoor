module Updates.ResultsUpdate exposing (update)

import Types exposing (..)


type alias WinLose =
    { win : Int, lose : Int }


incrementWin : WinLose -> WinLose
incrementWin { win, lose } =
    { win = win + 1, lose = lose }


incrementLose : WinLose -> WinLose
incrementLose { win, lose } =
    { win = win, lose = lose + 1 }


getGameResult : GameModel -> GameResult
getGameResult game =
    Maybe.withDefault NotDone
        (Maybe.map2
            (\finalDoor selectedDoor ->
                if (finalDoor == selectedDoor) then
                    case finalDoor.prize of
                        Banana ->
                            StayedWon

                        Goat ->
                            StayedLost
                else
                    case finalDoor.prize of
                        Banana ->
                            SwitchedWon

                        Goat ->
                            SwitchedLost
            )
            game.finalDoor
            game.selectedDoor
        )


update : GameResults -> GameModel -> GameResults
update results currentGame =
    case getGameResult currentGame of
        StayedWon ->
            { results
                | stayed = incrementWin results.stayed
            }

        StayedLost ->
            { results
                | stayed = incrementLose results.stayed
            }

        SwitchedWon ->
            { results
                | switched = incrementWin results.switched
            }

        SwitchedLost ->
            { results
                | switched = incrementLose results.switched
            }

        _ ->
            results
