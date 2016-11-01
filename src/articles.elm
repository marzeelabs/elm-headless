module Main exposing (..)

import Http
import Html exposing (Html, h1, h2, button, div, text, ul, li, i)
import Html.Attributes exposing (class, href, src, style, target)
import Html.App as Html
import Html.Events exposing (onClick)
import Time exposing (Time)
import Json.Decode as JD exposing ((:=))
import String exposing (toInt, toFloat)
import Task
import Date exposing (..)
import Date.Format
import RemoteData exposing (RemoteData(..), WebData)


-- MAIN


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


headlessServer : String
headlessServer =
    --"http://campaign.lab/api/node/article?_format=api_json"
    "http://localhost:4000/db"


type alias Id =
    Int


type alias Author =
    { id : Id
    , name : String
    }


type alias Article =
    --{ author : Author
    { body : String
    , id : Id
    , label : String
    , created : Float
    }


type alias Articles =
    List Article


type alias Model =
    { articles : WebData Articles }


init : ( Model, Cmd Msg )
init =
    ( Model NotAsked, fetch )



-- UPDATE


type Msg
    = FetchResponse (WebData Articles)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResponse response ->
            ( Model response, Cmd.none )


fetch : Cmd Msg
fetch =
    Http.get decodeData headlessServer
        |> RemoteData.asCmd
        |> Cmd.map FetchResponse



-- DECODERS


decodeArticle : JD.Decoder Article
decodeArticle =
    let
        -- Cast String to Int.
        number : JD.Decoder Int
        number =
            JD.oneOf [ JD.int, JD.customDecoder JD.string String.toInt ]

        numberFloat : JD.Decoder Float
        numberFloat =
            JD.oneOf [ JD.float, JD.customDecoder JD.string String.toFloat ]

        decodeId =
            JD.at [ "" ]

        decodeAuthor =
            JD.object2 Author
                ("id" := number)
                ("label" := JD.string)

        decodeImage =
            JD.at [ "styles" ]
                ("thumbnail" := JD.string)

        --decodeTime : JD.Decoder Date
        --decodeTime =
        --JD.customDecoder JD.string Date.fromTime
    in
        JD.object4 Article
            --("user" := decodeAuthor)
            --(JD.oneOf [ "body" := JD.string, JD.succeed "" ])
            ("body" := ("value" := JD.string))
            ("nid" := number)
            --("image" := JD.string)
            --(JD.maybe ("image" := decodeImage))
            ("title" := JD.string)
            ("created" := numberFloat)


decodeData : JD.Decoder Articles
decodeData =
    JD.at [ "data" ] <| JD.list <| JD.at [ "attributes" ] <| decodeArticle



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "ui container main" ]
        [ h2 [] [ text "Latest articles" ]
        , viewArticles model.articles
        ]


viewArticles : WebData Articles -> Html Msg
viewArticles articles =
    case articles of
        Success articles ->
            div [ class "ui list" ] (List.map viewArticle articles)

        Failure error ->
            div [] [ text ("Error loading data: " ++ (toString error)) ]

        NotAsked ->
            div [] [ text "Not asked yet" ]

        Loading ->
            div [] [ text "Loading data..." ]


viewArticle : Article -> Html Msg
viewArticle article =
    div [ class "item" ]
        [ div [ class "header" ] [ text article.label ]
        , i [ class "calendar outline icon" ] []
        , div [ class "content" ] [ text (article.created |> formatDate) ]
        ]


formatDate : Float -> String
formatDate timestamp =
    timestamp * 1000 |> Date.fromTime |> Date.Format.format "%A, %e %B"
