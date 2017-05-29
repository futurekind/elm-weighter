module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import TouchEvents


type alias Model =
    { pageIndex : Int
    , touchStartX : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { pageIndex = 0
      , touchStartX = 0.0
      }
    , Cmd.none
    )


type Msg
    = TouchStart TouchEvents.Touch
    | TouchEnd TouchEvents.Touch


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "click" msg of
        TouchStart touch ->
            ( { model | touchStartX = touch.clientX }, Cmd.none )

        TouchEnd touch ->
            if touch.clientX < model.touchStartX then
                ( { model | pageIndex = getPageIndex <| model.pageIndex + 1 }, Cmd.none )
            else
                ( { model | pageIndex = getPageIndex <| model.pageIndex - 1 }, Cmd.none )


getPageIndex : Int -> Int
getPageIndex nextIndex =
    if nextIndex == 3 then
        2
    else if nextIndex == -1 then
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
        , TouchEvents.onTouchEvent TouchEvents.TouchStart TouchStart
        , TouchEvents.onTouchEvent TouchEvents.TouchEnd TouchEnd
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
        "translateX(" ++ toString value ++ "%)"


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
