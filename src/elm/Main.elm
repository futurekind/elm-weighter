module Main exposing (..)

import Page exposing (Page)
import EnterPage
import Html exposing (..)
import Html.Attributes exposing (..)
import TouchEvents


type alias Model =
    { pageIndex : Int
    , touchStartX : Float
    , pages : List Page
    , enterPage : EnterPage.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { pageIndex = 0
      , touchStartX = 0.0
      , pages =
            [ { class = "page--enter" }
            ]
      , enterPage = EnterPage.init
      }
    , Cmd.none
    )


type Msg
    = TouchStart TouchEvents.Touch
    | TouchEnd TouchEvents.Touch
    | Count


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TouchStart touch ->
            ( { model | touchStartX = touch.clientX }, Cmd.none )

        TouchEnd touch ->
            ( updatePageIndex touch model, Cmd.none )

        Count ->
            let
                enterPage =
                    model.enterPage

                newEnterPage =
                    { enterPage | count = model.enterPage.count + 1 }
            in
                ( { model | enterPage = newEnterPage }, Cmd.none )


updatePageIndex : TouchEvents.Touch -> Model -> Model
updatePageIndex touch model =
    let
        direction =
            TouchEvents.getDirectionX model.touchStartX touch.clientX

        delta =
            model.touchStartX - touch.clientX |> abs
    in
        if delta > 70 then
            case direction of
                TouchEvents.Left ->
                    { model | pageIndex = getPageIndex (model.pageIndex + 1) (List.length model.pages) }

                TouchEvents.Right ->
                    { model | pageIndex = getPageIndex (model.pageIndex - 1) (List.length model.pages) }

                _ ->
                    model
        else
            model


getPageIndex : Int -> Int -> Int
getPageIndex nextIndex upperEnd =
    if nextIndex == upperEnd then
        upperEnd - 1
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
        (List.indexedMap
            (\index page ->
                pageView index page model
            )
            model.pages
        )


pageView : Int -> Page -> Model -> Html Msg
pageView index page model =
    let
        children =
            case index of
                0 ->
                    EnterPage.view Count model.enterPage

                _ ->
                    div [] []
    in
        Page.view index model.pageIndex children page


listPageView : Model -> Html Msg
listPageView model =
    div [ class "list-page" ]
        [ h1 [ class "page__title" ] [ text "some title" ] ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
