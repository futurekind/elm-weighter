module ListPage exposing (Model, init, view)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra
import Numeral


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
        , { date = convertToMaybeDate "2017-05-11"
          , value = 91.3
          , title = ""
          }
        , { date = convertToMaybeDate "2017-05-12"
          , value = 91.3
          , title = ""
          }
        , { date = convertToMaybeDate "2017-05-22"
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
    div [ class "list__item" ]
        [ span [ class "list__date" ] [ getDateString weight.date |> text ]
        , span [ class "list__value" ]
            [ weight.value
                |> Numeral.format "0.00"
                |> text
            ]
        ]


viewHeader : String -> List Weight -> Html msg
viewHeader title data =
    let
        dataForRow =
            getWeightsForTitle title data
    in
    div [ class "list__block" ]
        [ h2 [ class "list__head" ] [ text title ]
        , div [] (List.map viewRow dataForRow)
        ]


view : Model -> Html msg
view model =
    let
        data =
            dataWithTitles model.data

        headers =
            createHeaders data
    in
    div [ class "list" ]
        (List.map (\title -> viewHeader title data) headers)
