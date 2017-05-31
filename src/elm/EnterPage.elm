module EnterPage exposing (view, init, Model)

import Numeral
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { count : Float }


init : Model -> Model
init model =
    model


view : msg -> Model -> Html msg
view msg model =
    div [ class "enter-page" ]
        [ h1
            [ class "enter-page__count"
            , onClick msg
            ]
            [ Numeral.format "0,00.00" model.count |> text ]
        ]
