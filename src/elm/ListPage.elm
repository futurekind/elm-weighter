module ListPage exposing (view, init, Model)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)


type alias Weight =
    { date : Maybe Date
    , value : Float
    }


type alias Model =
    { data : List Weight }


init : Model
init =
    { data =
        [ { date = convertToMaybeDate "2017-05-02"
          , value = 90.1
          }
        , { date = convertToMaybeDate "2017-05-03"
          , value = 90.0
          }
        , { date = convertToMaybeDate "2017-05-05"
          , value = 91.3
          }
        ]
    }


convertToMaybeDate : String -> Maybe Date
convertToMaybeDate dateString =
    case Date.fromString dateString of
        Ok value ->
            Just value

        Err e ->
            Nothing


view : Model -> Html msg
view model =
    div [] [ toString model |> text ]
