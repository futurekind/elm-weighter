module Main exposing (..)

import Page
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
    case msg of
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
        [ Page.view 0 model.pageIndex
        , Page.view 1 model.pageIndex
        , Page.view 2 model.pageIndex
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
