module Main exposing (..)

import Page exposing (Page)
import EnterPage
import ListPage
import Html exposing (..)
import Html.Attributes exposing (..)
import TouchEvents


type alias Model =
    { pageIndex : Int
    , touchStartX : Float
    , pages : List Page
    , enterPage : EnterPage.Model
    , listPage : ListPage.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { pageIndex = 1
      , touchStartX = 0.0
      , pages =
            [ { class = "page--enter" }
            , { class = "page--list" }
            ]
      , enterPage = EnterPage.init 85.3
      , listPage = ListPage.init
      }
    , Cmd.none
    )


type Msg
    = SlidePageStart TouchEvents.Touch
    | SlidePageEnd TouchEvents.Touch
    | IncreaseWeightValue
    | DecreseWeightValue
    | Save


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SlidePageStart touch ->
            ( { model | touchStartX = touch.clientX }, Cmd.none )

        SlidePageEnd touch ->
            ( updatePageIndex touch model, Cmd.none )

        IncreaseWeightValue ->
            ( updateEnterPageWeight 0.1 model, Cmd.none )

        DecreseWeightValue ->
            ( updateEnterPageWeight -0.1 model, Cmd.none )

        Save ->
            let
                enterPage =
                    model.enterPage

                newEnterPage =
                    { enterPage | dirty = False }
            in
                ( { model | enterPage = newEnterPage }, Cmd.none )


updateEnterPageWeight : Float -> Model -> Model
updateEnterPageWeight value model =
    let
        enterPage =
            model.enterPage

        newEnterPage =
            { enterPage | weight = enterPage.weight + value }

        newEnterPageDirty =
            { newEnterPage | dirty = True }
    in
        { model | enterPage = newEnterPageDirty }


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
        , TouchEvents.onTouchEvent TouchEvents.TouchStart SlidePageStart
        , TouchEvents.onTouchEvent TouchEvents.TouchEnd SlidePageEnd
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
                    EnterPage.view IncreaseWeightValue DecreseWeightValue Save model.enterPage

                1 ->
                    ListPage.view model.listPage

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
