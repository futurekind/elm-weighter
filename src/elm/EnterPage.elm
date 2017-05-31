module EnterPage exposing (view, init, Model)

import Numeral
import Html exposing (..)
import Html.Attributes exposing (..)
import TouchEvents


type alias Model =
    { weight : Float }


init : Model -> Model
init model =
    model


view : (TouchEvents.Touch -> msg) -> (TouchEvents.Touch -> msg) -> Model -> Html msg
view startMsg moveMsg model =
    div [ class "enter-page" ]
        [ h1
            [ class "enter-page__count"
            , TouchEvents.onTouchEvent TouchEvents.TouchStart startMsg
            , TouchEvents.onTouchEvent TouchEvents.TouchMove moveMsg
            ]
            [ Numeral.format "0,00.00" model.weight |> text ]
        ]
