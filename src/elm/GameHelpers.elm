module GameHelpers exposing (..)

import Types exposing (..)


getUnselectedGoatDoors : GameModel -> List Door
getUnselectedGoatDoors model =
    case model.selectedDoor of
        Nothing ->
            List.filter
                (\d -> (d.prize /= Banana))
                model.doors

        Just selectedDoor ->
            List.filter
                (\d -> (d /= selectedDoor) && (d.prize /= Banana))
                model.doors


getUnopenedDoors : GameModel -> List Door
getUnopenedDoors model =
    let
        isMaybeDoor : Maybe Door -> Door -> Bool
        isMaybeDoor maybeDoor door =
            case maybeDoor of
                Just m ->
                    (door == m)

                Nothing ->
                    False
    in
        model.doors
            |> List.filter (not << isMaybeDoor model.revealedDoor)
            |> List.filter (not << isMaybeDoor model.finalDoor)
