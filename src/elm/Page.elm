module Page exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


getTranslateValue : Int -> Int -> String
getTranslateValue index pageIndex =
    let
        value =
            if index == pageIndex then
                0
            else if index < pageIndex then
                -100
            else
                100
    in
        "translateX(" ++ toString value ++ "%)"


view : Int -> Int -> Html msg
view index currentIndex =
    div
        [ class "page"
        , style [ ( "transform", getTranslateValue index currentIndex ) ]
        ]
        [ text <| "Page " ++ toString index ]
