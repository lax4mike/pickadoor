module Types exposing (..)

-- MSG


type Msg
    = SelectDoor Door
    | ConfirmDoor
    | OpenDoor (Maybe Door)
    | Reset



-- MODEL


type alias Model =
    { doors : Doors
    , selectedDoor : Maybe Door
    }


type alias Doors =
    List Door


type alias Door =
    { name : String
    , isOpened : Bool
    , prize : Prize
    }


type Prize
    = Banana
    | Goat



-- PROGRESS


type Progress
    = Start
    | FirstDoorSelected Door
    | FirstDoorConfirmed Door
    | SwitchedOrStayed Door


getProgress : Model -> Progress
getProgress model =
    let
        openDoors =
            (List.filter (.isOpened) model.doors)
    in
        case (List.length openDoors) of
            0 ->
                case model.selectedDoor of
                    Nothing ->
                        Start

                    Just selectedDoor ->
                        FirstDoorSelected selectedDoor

            1 ->
                case model.selectedDoor of
                    Nothing ->
                        Debug.crash "can't happen"

                    Just selectedDoor ->
                        case List.head openDoors of
                            Nothing ->
                                Debug.crash "head?"

                            Just openDoor ->
                                FirstDoorConfirmed openDoor

            2 ->
                case model.selectedDoor of
                    Nothing ->
                        Debug.crash "should't happen"

                    Just selectedDoor ->
                        SwitchedOrStayed selectedDoor

            _ ->
                Debug.crash "How did you open all those doors??"
