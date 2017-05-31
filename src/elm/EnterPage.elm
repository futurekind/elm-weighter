module EnterPage exposing (view, init, Model)

import Numeral
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { weight : Float
    , dirty : Bool
    }


type BtnType
    = Up
    | Down


init : Float -> Model
init weight =
    { weight = weight
    , dirty = False
    }


view : msg -> msg -> msg -> Model -> Html msg
view increaseMsg decreaseMsg saveMsg model =
    div [ class "enter-page" ]
        [ h1
            [ class "enter-page__count"
            ]
            [ Numeral.format "0,00.00" model.weight |> text ]
        , buttonView Down decreaseMsg
        , buttonView Up increaseMsg
        , div
            [ classList
                [ ( "enter-page__save", True )
                , ( "enter-page__save--active", model.dirty )
                ]
            ]
            [ button [ onClick saveMsg ] [ text "Save" ] ]
        ]


buttonView : BtnType -> msg -> Html msg
buttonView btnType msg =
    let
        className =
            case btnType of
                Up ->
                    " enter-page__btn--up"

                Down ->
                    " enter-page__btn--down"
    in
        input
            [ type_ "button"
            , class <| "enter-page__btn" ++ className
            , onClick msg
            ]
            [ text "down" ]
