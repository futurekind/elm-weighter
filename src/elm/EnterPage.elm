module EnterPage exposing (view, init, Model)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { count : Int }


init : Model
init =
    { count = 0 }


view : msg -> Model -> Html msg
view msg model =
    div [ class "enter-page" ]
        [ h1
            [ class "page__title"
            , onClick msg
            ]
            [ toString model.count |> text ]
        ]
