module ListPage exposing (Model, Weight, init, view)

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


init : List Weight -> Model
init list =
    { data =
        list
    }


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
            let
                day =
                    toFloat (Date.day aDate)
                        |> Numeral.format "00"
            in
                day ++ ". " ++ toString (Date.month aDate)

        Nothing ->
            "-"


getGainLoss : List Weight -> String
getGainLoss list =
    let
        last =
            case List.Extra.last list of
                Just item ->
                    item.value

                Nothing ->
                    0.0

        first =
            case List.head list of
                Just item ->
                    item.value

                Nothing ->
                    0.0
    in
        first
            - last
            |> Numeral.format "0.00"


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
            [ h2 [ class "list__head" ]
                [ span [ class "list__title" ] [ text title ]
                , span [ class "list__gain" ] [ getGainLoss dataForRow |> text ]
                ]
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
