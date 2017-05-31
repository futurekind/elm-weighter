module EnterPage exposing (view, init, Model)

import Numeral
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { weight : Float }


type BtnType
    = Up
    | Down


init : Model -> Model
init model =
    model


view : msg -> msg -> Model -> Html msg
view increaseMsg decreaseMsg model =
    div [ class "enter-page" ]
        [ h1
            [ class "enter-page__count"
            ]
            [ Numeral.format "0,00.00" model.weight |> text ]
        , buttonView Down decreaseMsg
        , buttonView Up increaseMsg
        ]


buttonView : BtnType -> msg -> Html msg
buttonView btnType msg =
    let
        className =
            case btnType of
                Up ->
                    " enter-page__btn--up"

                Down ->
                    " enter-page__btn--up"
    in
        input
            [ type_ "button"
            , class <| "enter-page__btn" ++ className
            , onClick msg
            ]
            [ text "down" ]
