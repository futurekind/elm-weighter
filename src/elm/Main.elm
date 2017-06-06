port module Main exposing (..)

import Date exposing (Date)
import EnterPage
import Html exposing (..)
import Html.Attributes exposing (..)
import ListPage
import Page exposing (Page)
import Task
import TouchEvents


-- MODEL


type alias Model =
    { pageIndex : Int
    , touchStartX : Float
    , pages : List Page
    , enterPage : EnterPage.Model
    , listPage : ListPage.Model
    }


type alias ServerData =
    { value : Float, date : String, title : String }


init : ( Model, Cmd Msg )
init =
    ( { pageIndex = 0
      , touchStartX = 0.0
      , pages =
            [ { class = "page--enter" }
            , { class = "page--list" }
            ]
      , enterPage = EnterPage.init 0.0 Nothing
      , listPage = ListPage.init []
      }
    , Cmd.batch
        [ Task.perform NewDate Date.now
        , loadData ""
        ]
    )



-- PORTS


port loadData : String -> Cmd msg


port dataFromServer : (List ServerData -> msg) -> Sub msg



--UPDATE


type Msg
    = SlidePageStart TouchEvents.Touch
    | SlidePageEnd TouchEvents.Touch
    | IncreaseWeightValue
    | DecreseWeightValue
    | Save
    | NewDate Date
    | DataFromServer (List ServerData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
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

                listPage =
                    model.listPage

                listPageData =
                    model.listPage.data

                newData =
                    { date = model.enterPage.date
                    , value = model.enterPage.weight
                    , title = ""
                    }

                newEnterPage =
                    { enterPage | dirty = False }

                newListPage =
                    { listPage | data = updateListPageData newData model.listPage.data }
            in
            ( { model | enterPage = newEnterPage, listPage = newListPage }, Cmd.none )

        NewDate date ->
            let
                enterPage =
                    model.enterPage

                newEnterPage =
                    { enterPage | date = Just date }
            in
            ( { model | enterPage = newEnterPage }, Cmd.none )

        DataFromServer data ->
            let
                listPage =
                    model.listPage

                enterPage =
                    model.enterPage

                newData =
                    List.map (\item -> { item | date = convertToMaybeDate item.date }) data

                enterPageWeight =
                    case List.head newData of
                        Just item ->
                            item.value

                        Nothing ->
                            100.0

                newListPage =
                    { listPage | data = newData }

                newEnterPage =
                    { enterPage | weight = enterPageWeight }
            in
            ( { model | listPage = newListPage, enterPage = newEnterPage }, Cmd.none )


updateListPageData : ListPage.Weight -> List ListPage.Weight -> List ListPage.Weight
updateListPageData weight data =
    case List.head data of
        Just item ->
            if item.date == weight.date then
                let
                    rest =
                        List.drop 1 data
                in
                weight :: rest
            else
                weight :: data

        Nothing ->
            [ weight ]


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



--HELPER


getPageIndex : Int -> Int -> Int
getPageIndex nextIndex upperEnd =
    if nextIndex == upperEnd then
        upperEnd - 1
    else if nextIndex == -1 then
        0
    else
        nextIndex


convertToMaybeDate : String -> Maybe Date
convertToMaybeDate dateString =
    case Date.fromString dateString of
        Ok value ->
            Just value

        Err e ->
            Nothing



--SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    dataFromServer DataFromServer



--VIEW


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
