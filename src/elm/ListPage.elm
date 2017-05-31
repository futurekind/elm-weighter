module ListPage exposing (view, init, Model)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import List.Extra


type alias Weight =
    { date : Maybe Date
    , value : Float
    , title : String
    }


type alias Model =
    { data : List Weight }


init : Model
init =
    { data =
        [ { date = convertToMaybeDate "2017-06-01"
          , value = 100.2
          , title = ""
          }
        , { date = convertToMaybeDate "2017-05-02"
          , value = 90.1
          , title = ""
          }
        , { date = convertToMaybeDate "2017-05-03"
          , value = 90.0
          , title = ""
          }
        , { date = convertToMaybeDate "2017-05-05"
          , value = 91.3
          , title = ""
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


dataWithTitles : List Weight -> List Weight
dataWithTitles list =
    List.map
        (\weight ->
            case weight.date of
                Just date ->
                    { weight | title = getTitle date }

                Nothing ->
                    { weight | title = "No date" }
        )
        list


createHeaders : List Weight -> List String
createHeaders list =
    List.map (\weight -> weight.title) list |> List.Extra.unique


getTitle : Date -> String
getTitle date =
    let
        month =
            Date.month date |> toString

        year =
            Date.year date |> toString
    in
        month ++ " " ++ year


getWeightsForTitle : String -> List Weight -> List Weight
getWeightsForTitle title list =
    List.filter (\weight -> weight.title == title) list


getDateString : Maybe Date -> String
getDateString date =
    case date of
        Just aDate ->
            toString (Date.day aDate)
                ++ ". "
                ++ toString (Date.month aDate)

        Nothing ->
            "-"


viewRow : Weight -> Html msg
viewRow weight =
    div []
        [ span [] [ getDateString (weight.date) |> text ]
        , span [] [ toString (weight.value) |> text ]
        ]


viewHeader : String -> List Weight -> Html msg
viewHeader title data =
    let
        dataForRow =
            getWeightsForTitle title data
    in
        div []
            [ h2 [] [ text title ]
            , div [] (List.map viewRow dataForRow)
            ]


view : Model -> Html msg
view model =
    let
        data =
            dataWithTitles model.data

        header =
            createHeaders data
    in
        div []
            (List.map (\title -> viewHeader title data) header)
