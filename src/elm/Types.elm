module Types exposing (..)

-- MSG


type Msg
    = -- door msg's
      SelectFirstDoor Door
    | ConfirmDoor
    | RandomlyOpenDoor (Maybe Door)
    | SelectFinalDoor Door
    | Reset
    | ScrambleDoors (List Door)
    | NoOp
      --
    | ToggleCheat Bool
    | SimulateOnce
    | SimulateABunch Int
    | RecordSimulation GameModel



-- MODEL


type alias Model =
    { results : GameResults
    , currentGame : GameModel
    , isCheating : Bool
    }


type alias GameResults =
    { stayed :
        { win : Int, lose : Int }
    , switched :
        { win : Int, lose : Int }
    }


type GameResult
    = StayedWon
    | StayedLost
    | SwitchedWon
    | SwitchedLost
    | NotDone


type alias GameModel =
    { doors : List Door
    , selectedDoor : Maybe Door {- the door that the user first chose -}
    , revealedDoor : Maybe Door {- the goat door randomly revealed to the user -}
    , finalDoor : Maybe Door {- the final choice of the user, if they stay, it's the same as the selectedDoor -}
    }


type alias Door =
    { name : String
    , prize : Prize
    }


isDoorOpen : GameModel -> Door -> Bool
isDoorOpen { revealedDoor, finalDoor } door =
    let
        isMaybeEqual a maybeB =
            case maybeB of
                Nothing ->
                    False

                Just b ->
                    a == b
    in
        List.any (isMaybeEqual door) [ revealedDoor, finalDoor ]


type Prize
    = Banana
    | Goat



-- PROGRESS


type Progress
    = Start
    | FirstDoorSelected Door
    | RandomDoorRevealed Door
    | SwitchedOrStayed Door


getProgress : GameModel -> Progress
getProgress model =
    case model.selectedDoor of
        Nothing ->
            Start

        Just selectedDoor ->
            case model.revealedDoor of
                Nothing ->
                    FirstDoorSelected selectedDoor

                Just revealedDoor ->
                    case model.finalDoor of
                        Nothing ->
                            RandomDoorRevealed revealedDoor

                        Just finalDoor ->
                            SwitchedOrStayed finalDoor
