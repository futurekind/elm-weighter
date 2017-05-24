module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { pageIndex : Int }


init : ( Model, Cmd Msg )
init =
    ( { pageIndex = 0
      }
    , Cmd.none
    )


type Msg
    = IncrementPageIndex


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncrementPageIndex ->
            ( { model | pageIndex = getPageIndex <| model.pageIndex + 1 }, Cmd.none )


getPageIndex : Int -> Int
getPageIndex nextIndex =
    if Debug.log "next" nextIndex == 3 then
        0
    else
        nextIndex


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div
        [ class "pages"
        , onClick IncrementPageIndex
        ]
        [ div
            [ class "page"
            , style
                [ ( "background", "red" )
                , ( "transform", getTranslateValue 0 model.pageIndex )
                ]
            ]
            [ text "Rot" ]
        , div
            [ class "page"
            , style
                [ ( "background", "green" )
                , ( "transform", getTranslateValue 1 model.pageIndex )
                ]
            ]
            [ text "green" ]
        , div
            [ class "page"
            , style
                [ ( "background", "blue" )
                , ( "transform", getTranslateValue 2 model.pageIndex )
                ]
            ]
            [ text "blue" ]
        ]


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
        "translateX(" ++ (toString value) ++ "%)"


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
