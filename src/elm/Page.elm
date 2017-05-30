module Page exposing (view, Page)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Page =
    { class : String
    }


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


view : Int -> Int -> Html msg -> Page -> Html msg
view index currentIndex children model =
    div
        [ class <| "page " ++ model.class
        , style [ ( "transform", getTranslateValue index currentIndex ) ]
        ]
        [ children ]
