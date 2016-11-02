module Main exposing (..)

import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing (onClick, onSubmit, onInput)
import Time exposing (Time)
import Json.Decode as JD exposing ((:=))
import Json.Encode as JE exposing (string, int)
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

type alias ArticleForm =
    { title : String }

type alias Model =
    { articles : WebData Articles
    , articleForm : ArticleForm
    }

init : ( Model, Cmd Msg )
init =
    ( Model Loading (ArticleForm ""), fetch )



-- UPDATE


type Msg
    = FetchResponse (WebData Articles)
    | TryPost
    | PrintJSON String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResponse response ->
            ({model | articles = response}, Cmd.none )
        TryPost ->
            -- todo: send out the command for an actual POST request
            (model, Cmd.none)
        PrintJSON title ->
            let
                form = ArticleForm title
            in
                ({model | articleForm = form}, Cmd.none)


fetch : Cmd Msg
fetch =
    Http.get decodeData headlessServer
        |> RemoteData.asCmd
        |> Cmd.map FetchResponse

--post : Cmd Msg
--post =
--    Http.post encodeDate headlessServer


-- ENCODERS / DECODERS

dataToJson : ArticleForm -> String
dataToJson data =
    JE.encode 4
        <| JE.object
            [ ("data", encodeData <| data)
            ]

encodeData data =
    JE.object
        [ ("type", string "node--article")
        , ("attributes", encodeAttributes <| data)
        ]

encodeAttributes data =
    JE.object
        [ ("title", string data.title)
        , ("status", int 1)
        ]

decodeData : JD.Decoder Articles
decodeData =
    JD.at [ "data" ] <| JD.list <| JD.at [ "attributes" ] <| decodeArticle

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


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ ]
        [ h2 [ class "ui dividing header" ] [ text "Latest articles" ]
        , viewArticles model.articles
        , h2 [ class "ui dividing header" ] [ text "Add new article" ]
        , viewForm model.articleForm.title
        , viewDebugJson model.articleForm
        ]


viewArticles : WebData Articles -> Html Msg
viewArticles articles =
    case articles of
        Success articles ->
            div [ class "ui list" ] (List.map viewArticle articles)

        Failure error ->
            div [] [ text ("Error loading data. Tip: make sure to run 'npm run api'. Message: " ++ (toString error)) ]

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

viewForm : String -> Html Msg
viewForm title =
    Html.form
        [ onSubmit TryPost ]
        [ input
            [ type' "text"
            , placeholder "Title for a new article.."
            , onInput PrintJSON
            , value title
            ]
            []
        ]

viewDebugJson : ArticleForm -> Html Msg
viewDebugJson data =
    code [] [ text (data |> dataToJson) ]

formatDate : Float -> String
formatDate timestamp =
    timestamp * 1000 |> Date.fromTime |> Date.Format.format "%A, %e %B"
