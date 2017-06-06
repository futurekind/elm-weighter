module EnterPage exposing (Model, init, view)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Numeral


type alias Model =
    { weight : Float
    , date : Maybe Date
    , dirty : Bool
    , loading : Bool
    }


type BtnType
    = Up
    | Down


init : Float -> Maybe Date -> Model
init weight date =
    { weight = weight
    , date = date
    , dirty = False
    , loading = True
    }


view : msg -> msg -> msg -> Model -> Html msg
view increaseMsg decreaseMsg saveMsg model =
    div [ class "enter-page" ]
        [ if model.loading == True then
            div [ class "loader" ] []
          else
            contentView increaseMsg decreaseMsg saveMsg model
        ]


toDateString : Date -> String
toDateString date =
    let
        dayStr =
            date
                |> Date.day
                |> toString

        monthStr =
            date
                |> Date.month
                |> toString

        yearStr =
            date
                |> Date.year
                |> toString
    in
    dayStr ++ ". " ++ monthStr ++ " " ++ yearStr


contentView : msg -> msg -> msg -> Model -> Html msg
contentView increaseMsg decreaseMsg saveMsg model =
    div []
        [ dateView model
        , h1
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
            [ button
                [ onClick saveMsg
                , class "btn"
                ]
                [ text "Save" ]
            ]
        ]


dateView : Model -> Html msg
dateView model =
    case model.date of
        Just date ->
            div []
                [ date
                    |> toDateString
                    |> text
                ]

        Nothing ->
            span [] []


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
